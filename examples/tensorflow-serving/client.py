import requests
import json
import base64
from PIL import Image
import numpy as np
import argparse
import time

def get_picture_as_tensor(filename, height, width, tensorflow_backend="builtin"):
  if tensorflow_backend == "rest":
    retuget_pictureage_as_tensor_rest(filename, height, width)
  elif tensorflow_backend == "builtin":
    return get_picture_as_tensor_builtin(filename, height, width)

def get_picture_as_tensor_rest(filename, height, width):
  url = f'http://localhost:5000/v1/pictures/?height={height}&width={width}'
  data = open(filename, "rb").read()
  response = requests.post(url, data=data)
  json_response = response.json()
  return json_response["tensor"]

def get_picture_as_tensor_builtin(filename, height, width):
  # importing keras/tensorflow is quite slow; only do it if needed
  from keras.preprocessing import image

  img_pil = image.load_img(filename, target_size=(height, width))
  img_array = image.img_to_array(img_pil) / 255.
  img_float = img_array.astype('float16')
  img_list = img_float.tolist()
  return img_list

def build_tensorflowserving_payload(tensor):
  data = json.dumps(
    {
      "signature_name": "serving_default",
      "instances": [{'input_1': tensor}]
     }
    )
  return data

def classify_tensor(tensor, model_name, tfserving_server):
  json_data = build_tensorflowserving_payload(tensor)
  headers = {"content-type": "application/json"}
  json_response = requests.post(f'{tfserving_server}/v1/models/{model_name}:predict', data=json_data, headers=headers)
  predictions = json.loads(json_response.text)['predictions']

  predicted_class = np.argmax(predictions[0])
  predicted_class_name = get_class_name(predicted_class)
  
  print(f'Predicted class: {predicted_class}')

def print_model_details(tfserving_server, model_name):
  print("==== model info ====")
  dl_request = requests.get(f'{tfserving_server}/v1/models/{model_name}')
  dl_request.raise_for_status()
  print(dl_request.content.decode())
  print("== model metadata ==")
  dl_request = requests.get(f'{tfserving_server}/v1/models/{model_name}/metadata')
  dl_request.raise_for_status()
  print(dl_request.content.decode())
  print("====================")

def get_class_name(class_number):
  #predicted_class_name = class_names[predicted_class]
  predicted_class_name = "NOT IMPLEMENTED"
  return predicted_class_name

def main():
  parser = argparse.ArgumentParser()
  parser.add_argument('--picture',
                      help='Picture which should be classified')
  parser.add_argument('--tensorflow-backend',
                      default="builtin",
                      help='Which TF backend should be used for picture conversion ("builtin" or "rest")')
  parser.add_argument('--print-model-details',
                      help='Whether to ask TF-Serving for details on the model')
  parser.add_argument('--tfserving-server',
                      default="http://localhost:8501",
                      help='URL of TF-Serving')
  args = parser.parse_args()
  filename = args.picture
  tensorflow_backend = args.tensorflow_backend
  print_model_details = args.print_model_details
  tfserving_server = args.tfserving_server

  if print_model_details:
    print_model_details(model_name="questionnaire", tfserving_server=tfserving_server)

  tensor = get_picture_as_tensor(filename, height=224, width=224, tensorflow_backend=tensorflow_backend)
  classify_tensor(tensor, model_name="questionnaire", tfserving_server=tfserving_server)

if __name__ == '__main__':
  main()