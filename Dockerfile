FROM python:3.10
COPY /App /App
WORKDIR /App
RUN pip install pip==22.1.2
RUN pip install -r requirements.txt
RUN sleep 1000