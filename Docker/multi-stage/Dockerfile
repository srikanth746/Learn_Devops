FROM ubuntu

WORKDIR /app

COPY . /app

RUN apt-get update && \
    apt install python3 &&\
    apt install pip

CMD [ "python3","first-python.py"]