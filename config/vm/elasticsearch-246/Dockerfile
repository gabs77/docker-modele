FROM elasticsearch:2.4.6

RUN apt-get update \
  && apt-get install -y htop vim nano wget

RUN bin/plugin install analysis-icu
RUN bin/plugin install analysis-phonetic

RUN echo "script.inline: on" >> /etc/elasticsearch/elasticsearch.yml && \
    echo "script.indexed: on" >> /etc/elasticsearch/elasticsearch.yml

