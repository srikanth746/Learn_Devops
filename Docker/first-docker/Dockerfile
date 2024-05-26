#Adding the base image
FROM ubuntu:latest

#Now let us add the working dir
WORKDIR /app

#Let is copy  the content to /app directory
COPY . /app

#Install the required packages to run the docker python script.
RUN apt-get update && apt-get install -y python3 python3-pip

RUN docker build -t srikanth0901/my-docker-second-child:v1 Dockerfilesecond

#Commands to run the python file.exit

ENTRYPOINT [ "python3" ]

CMD ["first-python.py"]


