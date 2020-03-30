DIR=$(dirname $0)
. $DIR/config.sh

VERSION=$1
MODULE="https://tfhub.dev/google/tf2-preview/mobilenet_v2/feature_vector/4"
SAVED_MODEL_DIRECTORY="trained-model/model/$VERSION"
LABELS_OUTPUT_FILE="trained-model/model/$VERSION/class_labels.txt"
TFLITE_OUTPUT_FILE="trained-model/model/$VERSION/mobile_model.tflite"
IMAGE_DIRECTORY=training-data
TRAINING_INFORMATION_FILE="trained-model/model/$VERSION/training_information.txt"
TRAINING_FILES=$(find $IMAGE_DIRECTORY -mindepth 1 -type f | wc -l)

mkdir -p $SAVED_MODEL_DIRECTORY

echo "Training model..."
echo "  Image directory: $IMAGE_DIRECTORY"
echo "  Image count: $TRAINING_FILES" | tee -a "$TRAINING_INFORMATION_FILE"
echo "  Image size: ${CONFIG_IMAGE_SIZE}" | tee -a "$TRAINING_INFORMATION_FILE"
echo "  Module: $MODULE" | tee -a "$TRAINING_INFORMATION_FILE"
echo "  Fine-Tuning: $CONFIG_FINE_TUNING" | tee -a "$TRAINING_INFORMATION_FILE"
echo "  Epochs: $CONFIG_TRAINING_EPOCHS" | tee -a "$TRAINING_INFORMATION_FILE"
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