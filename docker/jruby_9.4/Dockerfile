##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

##
# JRuby 9.4 (CRuby 3.1 compatible) with Node.js 20.x.
# - https://www.jruby.org/download
#
# NOTE: Linted by hadolint.
#
#   docker run --rm -i ghcr.io/hadolint/hadolint < docker/jruby_9.4/Dockerfile
#
# NOTE: A command to build image.
#
#   cd convenient_service
#   cp Gemfile Gemfile.jruby_9.4
#   docker build . -f docker/jruby_9.4/Dockerfile -t convenient_service:jruby_9.4
#   # or `ENGINE=jruby RUBY_VERSION=9.4 task docker:build`
#
# NOTE: A command to run bash in container.
#
#   cd convenient_service
#   docker run --rm -it -v $(pwd):/gem convenient_service:jruby_9.4 bash
#   # or `task docker:bash RUBY_ENGINE=jruby RUBY_VERSION=9.4`
#
# NOTE: If there are no memory, performance, or cost constraints, prefer to use as standard Linux distribution as it is possible.
# In a general case, you simply won't have enough time to resolve all the "quirks" of more specific distributions if you are an application developer.
# `jruby:9.4` uses Ubuntu under the hood.
# - https://hub.docker.com/_/jruby/tags
# - https://github.com/jruby/docker-jruby/blob/master/9.4/jre8/Dockerfile
# - https://github.com/adoptium/containers/blob/main/19/jdk/ubuntu/jammy/Dockerfile.releases.full#L20
#
FROM jruby:9.4

##
# NOTE: `git` is `bundle install` dependency.
#
# NOTE: `curl` and `gnupg2` are Node.js 16.x dependencies.
# - https://github.com/timbru31/docker-ruby-node/blob/master/3.2/16/slim/Dockerfile
#
# NOTE: `curl` for `go-task`.
# - https://taskfile.dev/docs/installation
#
RUN apt-get update -qq \
  && apt-get install --no-install-recommends -y git \
  && apt-get install --no-install-recommends -y curl \
  && apt-get install --no-install-recommends -y gnupg2 \
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

ENV RUBY_ENGINE=jruby

ENV RUBY_ENGINE_VERSION=9.4

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
