DIR=$(dirname $0)
. $DIR/config.sh

make_image_classifier \
  --image_dir training-data \
  --tfhub_module https://tfhub.dev/google/tf2-preview/mobilenet_v2/feature_vector/4 \
  --image_size ${CONFIG_IMAGE_SIZE} \
  --saved_model_dir output/model \
  --labels_output_file output/class_labels.txt \
  --tflite_output_file output/mobile_model.tflite \
  $CONFIG_FINE_TUNING \
  --train_epochs $CONFIG_TRAINING_EPOCHS