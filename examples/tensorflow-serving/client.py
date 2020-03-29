import requests
import json
import base64
from PIL import Image
from keras.preprocessing import image
import numpy as np
import argparse
import time

def read_image_as_tensor_thingy(filename, height, width):
  # CAVEAT: height and width might be switched; did not verify.
  img = image.load_img(filename, target_size=(height, width))
  img_array = image.img_to_array(img) / 255.
  img_float = img_array.astype('float16')
  img_list = img_float.tolist()
  return img_list

def read_image(filename):
  return Image.open(filename)

def build_json(tensor):
  data = json.dumps(
    {
      "signature_name": "serving_default",
      "instances": [{'input_1': tensor}]
     }
    )

  return data

def get_class_name(class_number):
  #predicted_class_name = class_names[predicted_class]
  predicted_class_name = "NOT IMPLEMENTED"
  return predicted_class_name

def send_request(json_data, model_name, server):
  headers = {"content-type": "application/json"}
  json_response = requests.post(f'{server}/v1/models/{model_name}:predict', data=json_data, headers=headers)
  predictions = json.loads(json_response.text)['predictions']

  predicted_class = np.argmax(predictions[0])
  predicted_class_name = get_class_name(predicted_class)
  
  print(f'Predicted class: {predicted_class}')

def print_model_details(server, model_name):
  print("==== model info ====")
  dl_request = requests.get(f'{server}/v1/models/{model_name}')
  dl_request.raise_for_status()
  print(dl_request.content.decode())
  print("== model metadata ==")
  dl_request = requests.get(f'{server}/v1/models/{model_name}/metadata')
  dl_request.raise_for_status()
  print(dl_request.content.decode())
  print("====================")

def main():
  parser = argparse.ArgumentParser()
  parser.add_argument('--picture')
  args = parser.parse_args()
  filename = args.picture

  #print_model_details(model_name="questionnaire", server="http://localhost:8501")
  tensor_thingy = read_image_as_tensor_thingy(filename, height=224, width=224)
  json = build_json(tensor_thingy)
  send_request(json, model_name="questionnaire", server="http://localhost:8501")

if __name__ == '__main__':
  main()