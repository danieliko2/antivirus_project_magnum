FROM python:3.10
COPY /App /App
WORKDIR /App

CMD [ "./init.sh; sleep 10000" ]
# RUN pip install pip==22.1.2
# RUN pip install -r requirements.txt

CMD [ "sleep 1000" ]