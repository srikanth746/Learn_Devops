
############################
#   BASE IMAGE
############################
FROM ubuntu as build

#Add the work dir
WORKDIR /app

#copy the content to the specified location
COPY . /app

RUN apt-get update && \
    apt install python3 &&\
    apt install pip

#########################################################
#     MULTI container
########################################################

FROM gcr.io/distroless/python3

COPY -- from = build /app .

ENTRYPOINT [ "python3"]

CMD ["first-python.py"]