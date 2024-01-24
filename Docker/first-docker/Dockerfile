#Adding the base image
FROM ubuntu:latest

#Now let us add the working dir
WORKDIR /app

#Let is copy  the content to /app directory
COPY . /app

#Install the required packages to run the docker python script.
RUN apt-get update && apt-get install -y python3 python3-pip

#Set the environment variables.
ENV NAME World

#Commands to run the python file.
CMD["python3" , "first-python.py"]
