######################
# BASE
######################
FROM ubuntu

WORKDIR /app

COPY . /app

RUN apt-get update && apt-get install -y python3 python3-pip

#####################CMD [ "python3","first-python.py"]
# Multi-stage-1
#####################
FROM python

CMD ["python3","first-python.py"]