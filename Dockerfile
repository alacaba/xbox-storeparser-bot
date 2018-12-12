FROM ruby:2.5-alpine

RUN apk add --update \
  build-base \
  libxml2-dev \
  libxslt-dev \
  git \
  && rm -rf /var/cache/apk/*

RUN bundle config build.nokogiri --use-system-libraries

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .

CMD ["bundle", "exec", "ruby", "bot.rb"]

