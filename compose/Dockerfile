FROM ruby:2.6.3-alpine

MAINTAINER Anatols Baymaganov <cheesy_cheese@enicad.com>
LABEL Description="Сервис информации о версиях Ruby и Rails по проектам в gitlab" \
      Vendor="Enicad" \
      Version="1.0"

RUN apk --update add --no-cache alpine-sdk sqlite-dev

WORKDIR /iris

ADD Gemfile* ./

RUN gem install bundler
RUN bundle install
