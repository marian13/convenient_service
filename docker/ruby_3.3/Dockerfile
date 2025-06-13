##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

##
# Ruby 3.3 with Node.js 18.x.
#
# NOTE: Linted by hadolint.
#
#   docker run --rm -i ghcr.io/hadolint/hadolint < docker/ruby_3.3/Dockerfile
#
# NOTE: A command to build image.
#
#   cd convenient_service
#   cp Gemfile Gemfile.ruby_3.3
#   docker build . -f docker/ruby_3.3/Dockerfile -t convenient_service:ruby_3.3
#   # or `RUBY_ENGINE=ruby RUBY_VERSION=3.3 task docker:build`
#
# NOTE: A command to run bash in container.
#
#   cd convenient_service
#   docker run --rm -it -v $(pwd):/gem convenient_service:ruby_3.3 bash
#   # or `task docker:bash RUBY_ENGINE=ruby RUBY_VERSION=3.3`
#
# NOTE: If there are no memory, performance, or cost constraints, prefer to use as standard Linux distribution as it is possible.
# In a general case, you simply won't have enough time to resolve all the "quirks" of more specific distributions if you are an application developer.
# That is why a `slim` version is used instead of `alpine`.
# Also `slim` is more similar to Ubuntu.
# - https://github.com/timbru31/docker-ruby-node/tree/master/ruby-3.3/18
# - https://medium.com/swlh/alpine-slim-stretch-buster-jessie-bullseye-bookworm-what-are-the-differences-in-docker-62171ed4531d
# - https://hub.docker.com/r/timbru31/ruby-node/tags
#
# NOTE: Hydrogen means Node.js 18.x.
# https://github.com/nodejs/Release
#
FROM timbru31/ruby-node:3.3-slim-hydrogen

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

ENV RUBY_ENGINE_VERSION=3.3

##
# NOTE: Every container has its own copy of `Gemfile`. This way a developer doesn't need to delete `Gemfile.lock` all the time when changing containers.
# - https://docs.docker.com/engine/reference/builder/#env
# - https://stackoverflow.com/questions/48863711/is-it-possible-to-override-gemfile-for-local-development
#
ENV BUNDLE_GEMFILE=Gemfile.${RUBY_ENGINE}_${RUBY_ENGINE_VERSION}

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
