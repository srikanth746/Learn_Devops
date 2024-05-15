#let's add the base image
FROM Ubuntu:latest

#Now add the workdir

WORKDIR /app

#Let's COPY the content to workdir
COPY . /app

#Lets download the java lib
RUN apt-get update && apt install openjdk-11-jre && apt install default-jdk

CMD javac Simple.java && java Simple

