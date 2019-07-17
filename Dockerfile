FROM ruby:2.6.3-alpine

MAINTAINER Anatols Baymaganov <cheesy_cheese@enicad.com>
LABEL Description="Сервис информации о версиях Ruby и Rails по проектам в gitlab" \
      Vendor="Enicad" \
      Version="1.0"

RUN apk --update add --no-cache alpine-sdk postgresql-libs libpq postgresql-dev

WORKDIR /iris

ADD Gemfile* ./

RUN gem install bundler --no-doc
RUN bundle install --without development test

COPY . .
COPY config/database.yml.sample config/database.yml

ENTRYPOINT ["./bin/entrypoint"]
