FROM ubuntu:latest

#Installation of java dependenices .
RUN apt-get update && \
    apt-get install -y openjdk-11-jdk && \
    apt-get install -y maven && \
    rm -rf /var/lib/apt/lists/*


RUN java -version

RUN mvn clean install

CMD echo "Java and maven installed successfully"
