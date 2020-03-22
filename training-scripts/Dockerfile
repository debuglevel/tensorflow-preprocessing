FROM tensorflow/tensorflow:2.1.0-py3 AS model_builder

RUN pip install "tensorflow-hub[make_image_classifier]~=0.6"

COPY . /app/training-scripts
RUN mkdir /app/output

WORKDIR /app/
CMD ./training-scripts/main 
