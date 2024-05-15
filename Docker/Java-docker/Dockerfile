#let's add the base image
FROM ubuntu:latest
#Now add the workdir
WORKDIR /app
#Let's COPY the content to workdir
COPY . /app
#Lets download the java lib
RUN apt-get update && apt install openjdk-11-jre -y && apt install default-jdk -y

CMD javac Simple.java && java Simple

