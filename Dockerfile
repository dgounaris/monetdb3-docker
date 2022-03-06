FROM python:3.8-slim-bullseye

RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install gnupg2 -y
COPY ./monetdb.list /etc/apt/sources.list.d/
COPY ./MonetDB-GPG-KEY /
RUN apt-key add /MonetDB-GPG-KEY
RUN apt-get update
RUN apt-get install -y monetdb5-sql monetdb-client monetdb-python3
COPY ./monet-start.sh /usr/local/bin/monet-start.sh
COPY ./monet-healthcheck.sh /usr/local/bin/monet-health.sh
HEALTHCHECK --interval=1s --timeout=1s --retries=20 CMD /usr/local/bin/monet-health.sh
VOLUME [ "/var/lib/monetdb" ]
EXPOSE 50000
CMD [ "sh", "-c", "/usr/local/bin/monet-start.sh" ]
