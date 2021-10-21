FROM ruby:2.7.1

WORKDIR /app
COPY . /app
RUN bundle install

EXPOSE 3000

CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "3000"]
