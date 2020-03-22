CONFIG_IMAGE_SIZE=224
#CONFIG_IMAGE_SIZE=128

# Notes: - the accuracy after the first (few) epochs are quite bad and should only be used for quick development
#        - the accuracy often evolves like this (w/o fine tuning):
#          Epoch    |  1   |  2   |  3   |  4   |  5   |   6 - 13  |  14 - 30  |
#          Accuracy | 0.22 | 0.38 | 0.45 | 0.56 | 0.62 | 0.6 - 0.7 | 0.7 - 0.8 |
#        - therefore, for the final model should actually take many epochs, but for development it would take to long
#        - with fine tuning enabled, accuracy gets pretty good in a few epochs (0.98 in epoch 5); but it takes much longer
#CONFIG_TRAINING_EPOCHS=1
CONFIG_TRAINING_EPOCHS=5
#CONFIG_TRAINING_EPOCHS=30

# Notes: - might easily exceed RAM of a Windows Docker VM,
#        - takes about 3 the time to train
#        - but the accuracy is much better (~0.81 vs ~0.98)
CONFIG_FINE_TUNING="--do_fine_tuning"
#CONFIG_FINE_TUNING=""