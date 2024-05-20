##
# Kindly copied from `timbru31/docker-ruby-node`, but replaced `FROM`.
# - https://github.com/timbru31/docker-ruby-node/blob/master/3.3/18/slim/Dockerfile
#
FROM ruby:3.4.0-preview1-slim
LABEL maintainer "Tim Brust <github@timbrust.de>"

ARG REFRESHED_AT
ENV REFRESHED_AT $REFRESHED_AT
ARG NODE_MAJOR=18

# hadolint ignore=DL3009
RUN apt-get update -qq && apt-get install -qq --no-install-recommends \
    curl \
    gnupg2 \
    libatomic1

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN printf 'Package: nodejs\nPin: origin deb.nodesource.com\nPin-Priority: 1001' > /etc/apt/preferences.d/nodesource \
  && mkdir -p /etc/apt/keyrings \
  && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
  && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list \
  && apt-get update -qq && apt-get install -qq --no-install-recommends \
    nodejs \
  && apt-get upgrade -qq \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*\
  && npm install -g yarn@1

##
# Ruby 3.4 with Node.js 18.x.
#
# NOTE: Linted by hadolint.
#
#   docker run --rm -i ghcr.io/hadolint/hadolint < docker/ruby-3.4/Dockerfile
#
# NOTE: A command to build image.
#
#   cd convenient_service
#   cp Gemfile Gemfile.ruby-3.4
#   docker build . -f docker/ruby-3.4/Dockerfile -t convenient_service:ruby-3.4
#   # or `RUBY_ENGINE=ruby RUBY_VERSION=3.4 task docker:build`
#
# NOTE: A command to run bash in container.
#
#   cd convenient_service
#   docker run --rm -it -v $(pwd):/gem convenient_service:ruby-3.4 bash
#   # or `task docker:bash RUBY_ENGINE=ruby RUBY_VERSION=3.4`
#
# NOTE: If there are no memory, performance, or cost constraints, prefer to use as standard Linux distribution as it is possible.
# In a general case, you simply won't have enough time to resolve all the "quirks" of more specific distributions if you are an application developer.
# That is why a `slim` version is used instead of `alpine`.
# Also `slim` is more similar to Ubuntu.
# - https://medium.com/swlh/alpine-slim-stretch-buster-jessie-bullseye-bookworm-what-are-the-differences-in-docker-62171ed4531d
#
# NOTE: Hydrogen means Node.js 18.x.
# https://github.com/nodejs/Release
##

##
# NOTE: `bundle install` dependencies.
#
RUN apt-get update -qq \
  && apt-get install --no-install-recommends -y git \
  && apt-get install --no-install-recommends -y make \
  && apt-get install --no-install-recommends -y gcc \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /gem

WORKDIR /gem

COPY . /gem

ENV RUBY_ENGINE=ruby

##
# NOTE: Every container has its own copy of `Gemfile`. This way a developer doesn't need to delete `Gemfile.lock` all the time when changing containers.
# - https://docs.docker.com/engine/reference/builder/#env
# - https://stackoverflow.com/questions/48863711/is-it-possible-to-override-gemfile-for-local-development
#
ENV BUNDLE_GEMFILE=Gemfile.${RUBY_ENGINE}_${RUBY_VERSION}

##
# NOTE: Installs `task`.
# https://taskfile.dev/installation/#install-script
#
# NOTE: `task` is installed into `~/bin`. That is why `-b /bin` is used. See `echo ${PATH}` to debug.
#
RUN sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b /bin

RUN task deps:install

##
# NOTE: Is used to check whether a command is executed inside a Docker container. See Rakefile for examples.
# https://stackoverflow.com/a/65942222/12201472
#
ENV IN_DOCKER_CONTAINER=true
