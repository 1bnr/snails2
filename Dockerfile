FROM ruby:2.2

RUN apt update
RUN apt install -y nodejs

COPY . /code
WORKDIR /code
RUN bundle install

ENV GMAIL_EMAIL=acmpr@umn.edu
ENV RAILS_ENV=development
ENV HOSTNAME=snacks.acm.umn.edu
ENV DEFAULT_PORT=80
CMD rake db:create; \
	rake db:migrate; \
	rails s -b 0.0.0.0 -p 8000
