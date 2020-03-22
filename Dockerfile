FROM python:3.7 AS data_generator

RUN pip3 install Pillow==5.2.0
RUN apt-get update && apt-get -y install imagemagick

COPY preprocessing-scripts /app/preprocessing-scripts
COPY original-data /app/original-data

WORKDIR /app
RUN ./preprocessing-scripts/main



FROM tensorflow/tensorflow:2.1.0-py3 AS model_builder

RUN pip install "tensorflow-hub[make_image_classifier]~=0.6"

COPY training-scripts /app/training-scripts
COPY --from=data_generator /app/training-data/ /app/training-data/
RUN mkdir /app/output

WORKDIR /app/
RUN ./training-scripts/main 


# verify our model by testing some pictures
FROM tensorflow/tensorflow:2.1.0-py3 AS test

RUN pip3 install Pillow==5.2.0

COPY testing-scripts /app/testing-scripts
COPY --from=model_builder /app/output/model /app/data/model/
COPY --from=model_builder /app/output/class_labels.txt /app/data/
COPY --from=model_builder /app/output/mobile_model.tflite /app/data/

COPY testing-data /app/testing-data

WORKDIR /app/
# should all predict "1"
RUN ./testing-scripts/main "/app/testing-data/ETA v6/1/1.jpg"
RUN ./testing-scripts/main "/app/testing-data/ETA v6/1/2.jpg"
RUN ./testing-scripts/main "/app/testing-data/ETA v6/1/3.jpg"
RUN ./testing-scripts/main "/app/testing-data/ETA v6/1/x1.jpg"
RUN ./testing-scripts/main "/app/testing-data/ETA v6/1/x2.jpg"
RUN ./testing-scripts/main "/app/testing-data/ETA v6/1/x3.jpg"