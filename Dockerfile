# base image
FROM alpine:3.5

# install python and pip
RUN apk add --update py2-pip

# install Python modules needed by the Python app 
COPY requirements.txt /usr/src/app/
RUN pip install --no-cache-dir -r /usr/src/app/requirements.txt

# copy files required for the app to run
COPY . /usr/src/app/
WORKDIR /usr/src/app/

# tell the port number the container should expose
EXPOSE 5000

# run the application
CMD ["python", "/usr/src/app/web.py"]