FROM ruby:2.6

ENV LANG=C.UTF-8 \
  TZ=Asia/Tokyo

WORKDIR /app

RUN apt-get update -qq && \
  apt-get install -y nodejs default-mysql-client


COPY . /app
RUN bundle install

EXPOSE 3000
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
