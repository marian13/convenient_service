FROM ruby:2.7

RUN mkdir -p /gem

WORKDIR /gem

COPY . /gem

##
# NOTE: Every container has its own copy of `Gemfile'. This way a developer doesn't need to delete `Gemfile.lock' all the time when changing containers.
# - https://docs.docker.com/engine/reference/builder/#env
# - https://stackoverflow.com/questions/48863711/is-it-possible-to-override-gemfile-for-local-development
#
ENV BUNDLE_GEMFILE=Gemfile.2.7

RUN bundle install
