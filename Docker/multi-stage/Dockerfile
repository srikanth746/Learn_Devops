#get the base image of the docker file
FROM ubuntu as build

#Add the work dir
WORKDIR /app

#Move the content to the specified location
COPY . /app

RUN apt-get update && \
    apt install python3 &&\
    apt install pip

##################################MULTI container######################## \

FROM python

COPY -- from = build /app .

ENTRYPOINT [ "python3"]

CMD ["first-python.py"]