FROM python:3
 # ubuntu 24.04
RUN pip3 install flask
COPY app.py /opt/
EXPOSE 8080
ENTRYPOINT [ "python3" ]
CMD ["/opt/app.py"]
