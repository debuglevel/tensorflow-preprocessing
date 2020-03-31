FROM tensorflow/tensorflow:2.1.0-py3 AS model_builder

RUN pip install "tensorflow-hub[make_image_classifier]~=0.6"

COPY . /app/training-scripts
RUN mkdir /app/output
# TODO: remove this once https://github.com/tensorflow/hub/pull/551 is accepted or https://github.com/tensorflow/hub/issues/541 is solved otherwise
RUN pip install /app/training-scripts/tensorflow_hub-0.9.0.dev0-py2.py3-none-any.whl

WORKDIR /app/
CMD ./training-scripts/main 
