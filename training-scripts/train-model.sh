DIR=$(dirname $0)
. $DIR/config.sh

VERSION=$1
MODULE="https://tfhub.dev/google/tf2-preview/mobilenet_v2/feature_vector/4"
SAVED_MODEL_DIRECTORY="trained-model/model/$VERSION"
LABELS_OUTPUT_FILE="trained-model/model/$VERSION/class_labels.txt"
TFLITE_OUTPUT_FILE="trained-model/model/$VERSION/mobile_model.tflite"
IMAGE_DIRECTORY=training-data

echo "Training model..."
echo "  Image directory: $IMAGE_DIRECTORY"
echo "  Image size: ${CONFIG_IMAGE_SIZE}"
echo "  Module: $MODULE"
echo "  Fine-Tuning: $CONFIG_FINE_TUNING"
echo "  Epochs: $CONFIG_TRAINING_EPOCHS"
echo "  Version: $VERSION"
echo "  SavedModel directory: $SAVED_MODEL_DIRECTORY"
echo "  Labels output file: $LABELS_OUTPUT_FILE"
echo "  TFlite output file: $TFLITE_OUTPUT_FILE"

make_image_classifier \
  --image_dir $IMAGE_DIRECTORY \
  --tfhub_module $MODULE \
  --image_size ${CONFIG_IMAGE_SIZE} \
  --saved_model_dir $SAVED_MODEL_DIRECTORY \
  --labels_output_file $LABELS_OUTPUT_FILE \
  --tflite_output_file $TFLITE_OUTPUT_FILE \
  $CONFIG_FINE_TUNING \
  --train_epochs $CONFIG_TRAINING_EPOCHS