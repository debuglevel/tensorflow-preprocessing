FROM python:3.7 AS data_generator

RUN pip3 install Pillow==5.2.0
RUN apt-get update && apt-get -y install imagemagick

COPY . /app/preprocessing-scripts

WORKDIR /app
CMD ./preprocessing-scripts/main
