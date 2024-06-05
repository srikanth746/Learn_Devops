FROM ubuntu:latest

#Installation of java dependenices .
RUN apt-get update && \
    apt-get install openjdk-11-jdk -y && \
    apt-get install wget -y && \
    rm -rf /var/lib/apt/lists/*

RUN wget https://apache.osuosl.org/maven/maven-3/3.8.8/binaries//apache-maven-3.8.8-bin.tar.gz && \
    tar -xf apache-maven-3.8.8-bin.tar.gz && \
    mv apache-maven-3.8.8 /usr/local && \
    ln -s /usr/local/apache-maven-3.8.8/bin/mvn /usr/bin/mvn

RUN rm apache-maven-3.8.8-bin.tar.gz

ENV MAVEN_HOME=/usr/local/apache-maven-3.8.8
ENV MAVEN_CONFIG=/root/.m2

RUN java -version

RUN mvn -version

CMD echo "Java and maven installed successfully"
