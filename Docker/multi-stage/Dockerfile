
#########################################################
#   BASE IMAGE
#########################################################
FROM ubuntu AS build

RUN apt-get update && \
    apt install python3 &&\
    apt install pip

#########################################################
#     MULTI container
#########################################################

FROM gcr.io/distroless/python3

COPY -- from = build . .

CMD ["python3","first-python.py"]