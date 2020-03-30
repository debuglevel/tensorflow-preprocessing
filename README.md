# Tensorflow data preparation & model training

This scripts aim to do some preparations and preprocessing on training data, and then start the model training.

# Data preparation

We assume that there are original pictures, which are quite useless for Tensorflow training. In this case, we got a questionnaire with many items. All of those items are Likert scale 1 to 5 (which is good for classification). But Tensorflow cannot work with a page of many items, but only with one item at a time. Therefore, this scripts preprocess the questionnaire scans, i.e. cut them into useful picture files (and sort them into "pre-classified directories").

```
docker build -t tf-preprocessing preprocessing-scripts
rm -rf training-data/*
docker run -ti --rm -v ${PWD}/original-data:/app/original-data -v ${PWD}/training-data:/app/training-data tf-preprocessing
```

# Tensorflow model training

The rather easy and more common part is to take the pircture files in the pre-classified directories and train the Tensflow model on this prictures.

```
docker build -t tf-training training-scripts
rm -rf trained-model/*
docker run -ti --rm -v ${PWD}/training-data:/app/training-data -v ${PWD}/trained-model:/app/trained-model tf-training
```

# Tensorflow model testing

```
docker build -t tf-testing testing-scripts
docker run -ti --rm -v ${PWD}/testing-data:/app/testing-data -v ${PWD}/trained-model:/app/data tf-testing
```

# TensorBoard visualization

Not yet possible; see [https://github.com/tensorflow/hub/issues/541]

# TensorFlow serving

```
docker run -ti --rm -p 8501:8501 -v ${PWD}/trained-model/model:/models/questionnaire/1 -e MODEL_NAME=questionnaire tensorflow/serving
for i in ./testing-data/ETA\ v6/1/*.jpg; do python3 ./examples/tensorflow-serving/client.py --picture="$i" 2> /dev/null; done
```

# Directories

```
original-data              unprocessed original data
training-data              processed data will be placed in here
tensorflow-model           trained Tensorflow model will be placed in here

preprocessing-scripts      scripts to process data in original-data and put results in training-data
training-scripts           scripts to train tensorflow model
```
