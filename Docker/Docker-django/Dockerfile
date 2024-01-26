# getting the base image
FROM UBUNTU

#Now add the working directory
WORKDIR /app

#COPY the content and requirments to it.
COPY requirements.txt /app
COPY devops /app

#Run the system updates and install the required packages.
RUN apt-get update && \
    apt-get install -y python3 python3-pip && \
    pip install -r requirements.txt && \
    cd devops

#adding the entrypoint and commands to the docker.
ENTRYPOINT ["python3"]
CMD ["manage.py","runserver","0.0.0.0:8000"]






