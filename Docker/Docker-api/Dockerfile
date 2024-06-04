FROM ubuntu:latest

#Installation of java dependenices .
RUN apt-get update && \
    apt-get install openjdk-11-jdk -y && \
    apt-get install maven -y && \
    rm -rf /var/lib/apt/lists/*


RUN java -version

RUN mvn clean install

CMD echo "Java and maven installed successfully"
