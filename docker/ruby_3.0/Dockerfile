##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

##
# Ruby 3.0 with Node.js 16.x.
#
# NOTE: Linted by hadolint.
#
#   docker run --rm -i ghcr.io/hadolint/hadolint < docker/ruby_3.0/Dockerfile
#
# NOTE: A command to build image.
#
#   cd convenient_service
#   cp Gemfile Gemfile.ruby_3.0
#   docker build . -f docker/ruby_3.0/Dockerfile -t convenient_service:ruby_3.0
#   # or `RUBY_ENGINE=ruby RUBY_VERSION=3.0 task docker:build`
#
# NOTE: A command to run bash in container.
#
#   cd convenient_service
#   docker run --rm -it -v $(pwd):/gem convenient_service:ruby_3.0 bash
#   # or `task docker:bash RUBY_ENGINE=ruby RUBY_VERSION=3.0`
#
# NOTE: If there are no memory, performance, or cost constraints, prefer to use as standard Linux distribution as it is possible.
# In a general case, you simply won't have enough time to resolve all the "quirks" of more specific distributions if you are an application developer.
# That is why a `slim` version is used instead of `alpine`.
# Also `slim` is more similar to Ubuntu.
# - https://github.com/timbru31/docker-ruby-node/tree/master/ruby-3.0/16
# - https://medium.com/swlh/alpine-slim-stretch-buster-jessie-bullseye-bookworm-what-are-the-differences-in-docker-62171ed4531d
# - https://hub.docker.com/r/timbru31/ruby-node/tags
#
FROM ruby:3.0-slim

##
# NOTE: `bundle install` dependencies.
#
# NOTE: `curl` for `go-task`.
# - https://taskfile.dev/docs/installation
#
RUN apt-get update -qq \
  && apt-get install --no-install-recommends -y git \
  && apt-get install --no-install-recommends -y make \
  && apt-get install --no-install-recommends -y gcc \
  && apt-get install --no-install-recommends -y curl \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

##
# NOTE: Installs `task`.
# - https://taskfile.dev/docs/installation
#
RUN curl -1sLf 'https://dl.cloudsmith.io/public/task/task/setup.deb.sh' | bash \
  && apt install task --no-install-recommends -y \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

##
# NOTE: Intalls Node.js 20.x and `yarn`.
# - https://github.com/timbru31/docker-ruby-node/blob/master/3.2/16/slim/Dockerfile
#
RUN curl -sL https://deb.nodesource.com/setup_20.x | bash -\
  && apt-get update -qq \
  && apt-get install -qq --no-install-recommends nodejs \
  && apt-get upgrade -qq \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*\
  && npm install -g yarn@1

ENV RUBY_ENGINE=ruby

ENV RUBY_ENGINE_VERSION=3.0

##
# NOTE: Every container has its own copy of `Gemfile`. This way a developer doesn't need to delete `Gemfile.lock` all the time when changing containers.
# - https://docs.docker.com/engine/reference/builder/#env
# - https://stackoverflow.com/questions/48863711/is-it-possible-to-override-gemfile-for-local-development
#
ENV BUNDLE_GEMFILE=Gemfile.${RUBY_ENGINE}_${RUBY_ENGINE_VERSION}

##
# NOTE: Is used to check whether a command is executed inside a Docker container. See Rakefile for examples.
# - https://stackoverflow.com/a/65942222/12201472
#
ENV IN_DOCKER_CONTAINER=true

RUN mkdir -p /gem

WORKDIR /gem

COPY . /gem

RUN task deps:install
