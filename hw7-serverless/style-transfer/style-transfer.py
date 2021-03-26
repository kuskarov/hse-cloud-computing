import time
import json
import boto3
import os

import cv2 as cv


def predict(net, img, h, w):
    blob = cv.dnn.blobFromImage(img, 1.0, (w, h),
                                (103.939, 116.779, 123.680), swapRB=False, crop=False)

    print('[INFO] Setting the input to the model')
    net.setInput(blob)

    print('[INFO] Starting Inference!')
    start = time.time()
    out = net.forward()
    end = time.time()
    print('[INFO] Inference Completed successfully!')

    # Reshape the output tensor and add back in the mean subtraction, and
    # then swap the channel ordering
    out = out.reshape((3, out.shape[2], out.shape[3]))
    out[0] += 103.939
    out[1] += 116.779
    out[2] += 123.680
    out /= 255.0
    out = out.transpose(1, 2, 0)

    # Printing the inference time
    print('[INFO] The model ran in {:.4f} seconds'.format(end - start))

    return out


# Source for this function:
# https://github.com/jrosebr1/imutils/blob/4635e73e75965c6fef09347bead510f81142cf2e/imutils/convenience.py#L65
def resize_img(img, width=None, height=None, inter=cv.INTER_AREA):
    dim = None
    h, w = img.shape[:2]

    if width is None and height is None:
        return img
    elif width is None:
        r = height / float(h)
        dim = (int(w * r), height)
    elif height is None:
        r = width / float(w)
        dim = (width, int(h * r))

    resized = cv.resize(img, dim, interpolation=inter)
    return resized


def process_image(image, model, output):
    net = cv.dnn.readNetFromTorch(model)
    img = cv.imread(image)
    img = resize_img(img, width=600)
    h, w = img.shape[:2]
    out = predict(net, img, h, w)
    out = cv.convertScaleAbs(out, alpha=255.0)
    cv.imwrite(output, out)


def handler(event, context):  
    session = boto3.session.Session()
    s3 = session.client(
        service_name='s3',
        endpoint_url='https://storage.yandexcloud.net',
        aws_access_key_id=os.getenv('AWS_ACCESS_KEY_ID'),
        aws_secret_access_key=os.getenv('AWS_SECRET_ACCESS_KEY')
    )

    bucket_name = os.getenv('UPLOAD_BUCKET_NAME')
    object_name = event['messages'][0]['details']['message']['body']

    # download from s3
    s3.download_file(bucket_name, object_name, '/tmp/input.jpg')

    process_image('/tmp/input.jpg', 'feathers.t7', '/tmp/output.jpg')

    results_bucket_name = os.getenv('RESULTS_BUCKET_NAME')

    # upload to s3
    s3.upload_file('/tmp/output.jpg', results_bucket_name, object_name)

    
