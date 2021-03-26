import argparse
import time
import json

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

    # download from S3

    img = cv.imread(image)
    img = resize_img(img, width=600)
    h, w = img.shape[:2]
    out = predict(net, img, h, w)
    out = cv.convertScaleAbs(out, alpha=255.0)
    cv.imwrite("result.jpg", out)

    # upload to S3

'''
{
  "messages": [
    {
      "event_metadata": {
        "event_id": "bb1dd06d-a82c-49b4-af98-d8e0c5a1d8f0",
        "event_type": "yandex.cloud.events.storage.ObjectDelete",
        "created_at": "2019-12-19T14:17:47.847365Z",
        "tracing_context": {
          "trace_id": "dd52ace79c62892f",
          "span_id": "",
          "parent_span_id": ""
        },
        "cloud_id": "b1gvlrnlei4l5idm9cbj",
        "folder_id": "b1g88tflru0ek1omtsu0"
      },
      "details": {
        "bucket_id": "s3-for-trigger",
        "object_id": "dev/0_15a775_972dbde4_orig12.jpg"
      }
    }
  ]
}
'''

def handler(event, context):
    return {
        'statusCode': 200,
        'body': json.dumps({
            'event': event,
        }),
    }


'''
def handler(event, context):
    # parser = argparse.ArgumentParser()
    # parser.add_argument('-i', '--image', type=str, help='path to the input image')
    # parser.add_argument('-m', '--model', type=str, help='path to the model file')
    # parser.add_argument('-o', '--output', type=str, help='path to the output image')
    # args = parser.parse_args()

    process_image(args.image, args.model, args.output)
'''

if __name__ == "__main__":
    main()
