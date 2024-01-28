######################
# BASE
######################
FROM ubuntu AS build

WORKDIR /app

COPY . /app

RUN apt-get update && apt-get install -y python3 python3-pip

#####################CMD [ "python3","first-python.py"]
# Multi-stage-1
#####################
FROM gcr.io/distroless/python3

COPY --from=build /app .

CMD ["first-python.py"]