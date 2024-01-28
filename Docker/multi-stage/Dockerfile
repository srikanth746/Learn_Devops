FROM ubuntu

WORKDIR /app

COPY . /app

RUN apt-get update &&  \\
    apt-get install python3 -y && \\
    python3-pip

CMD [ "python3","first-python.py"]