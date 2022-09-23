##
# TODO: Ruby with Node.js.
#
# NOTE: A command to build image.
#
#   cd convenient_service
#   cp Gemfile Gemfile.2.7
#   docker build . -f docker/2.7/Dockerfile -t convenient_service:2.7
#
# NOTE: A command to run bash in container.
#
#   cd convenient_service
#   docker run --rm -it -v $(pwd):/gem convenient_service:2.7 bash
#
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

RUN bundle exec appraisal install

##
# NOTE: Installs `task'.
# https://taskfile.dev/installation/#install-script
#
RUN sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d

##
# NOTE: Is used to check whether a command is executed inside a Docker container. See Rakefile for examples.
# https://stackoverflow.com/a/65942222/12201472
#
ENV IN_DOCKER_CONTAINER=true
