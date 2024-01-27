
############################
#   BASE IMAGE
############################
FROM ubuntu AS build

WORKDIR /app

COPY . /app

RUN apt-get update && \
    apt install python3 &&\
    apt install pip

#########################################################
#     MULTI container
########################################################

FROM gcr.io/distroless/python3

ENTRYPOINT [ "python3"]

CMD ["first-python.py"]