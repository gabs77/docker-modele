FROM ruby:2.4-alpine

# Versions of mailcatcher > 0.5.12 break with UTF-8 encoded emails
RUN apk add --update --virtual build-dependencies \
  build-base \
  ruby-dev \
  && apk add --update libstdc++ \
  sqlite-dev \
  && gem install mailcatcher -v 0.5.12 --no-rdoc --no-ri \
  && apk del build-dependencies

EXPOSE 1080 1025

CMD ["mailcatcher", "--ip=0.0.0.0", "--foreground"]