FROM ruby:3.0.0
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
WORKDIR /app
COPY . /app
RUN bundle install
CMD ["rails", "server", "-b", "0.0.0.0"]
EXPOSE 3000
