FROM ruby:3.0.0
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
WORKDIR /app
COPY . /app
RUN bundle install
ENTRYPOINT ["./rails_starter.sh"]
EXPOSE 3000
