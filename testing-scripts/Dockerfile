FROM tensorflow/tensorflow:2.1.0-py3 AS test

RUN pip3 install Pillow==5.2.0

COPY . /app/testing-scripts

WORKDIR /app/
CMD ./testing-scripts/main