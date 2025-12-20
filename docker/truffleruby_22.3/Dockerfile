##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

##
# TruffleRuby 22.3 (CRuby 3.1 compatible) with Node.js 16.x.
# - https://github.com/graalvm/container/blob/master/truffleruby/README.md
# - https://github.com/oracle/truffleruby/blob/master/doc/user/compatibility.md
#
# NOTE: Linted by hadolint.
#
#   docker run --rm -i ghcr.io/hadolint/hadolint < docker/truffleruby-22.3/Dockerfile
#
# NOTE: A command to build image.
#
#   cd convenient_service
#   cp Gemfile Gemfile.truffleruby-22.3
#   docker build . -f docker/truffleruby-22.3/Dockerfile -t convenient_service:truffleruby-22.3
#   # or `RUBY_ENGINE=truffleruby RUBY_VERSION=22.3 task docker:build`
#
# NOTE: A command to run bash in container.
#
#   cd convenient_service
#   docker run --rm -it -v $(pwd):/gem convenient_service:truffleruby-22.3 bash
#   # or `task docker:bash RUBY_ENGINE=jruby RUBY_VERSION=9.4`
#
# NOTE: If there are no memory, performance, or cost constraints, prefer to use as standard Linux distribution as it is possible.
# In a general case, you simply won't have enough time to resolve all the "quirks" of more specific distributions if you are an application developer.
# - https://github.com/graalvm/container/pkgs/container/truffleruby/65464856?tag=debian-22.3
# - https://github.com/graalvm/container/blob/master/truffleruby/Dockerfile.debian#L6
# - https://www.graalvm.org/latest/docs/getting-started/container-images/
#
FROM ghcr.io/graalvm/truffleruby:22.3.0

##
# NOTE: `git`, `make`, `gcc` are `bundle install` dependencies.
#
# NOTE: `curl` and `gnupg2` are Node.js 16.x dependencies.
# - https://github.com/timbru31/docker-ruby-node/blob/master/3.2/16/slim/Dockerfile
#
# NOTE: `curl` for `go-task`.
# - https://taskfile.dev/docs/installation
#
RUN dnf install -y git \
  && dnf install -y make \
  && dnf install -y gcc \
  && dnf install -y curl \
  && dnf install -y gnupg2 \
  && dnf clean all

##
# NOTE: Installs `task`.
# - https://taskfile.dev/docs/installation
#
RUN curl -1sLf 'https://dl.cloudsmith.io/public/task/task/setup.rpm.sh' | bash \
  && dnf install -y task \
  && dnf clean all

##
# NOTE: Intalls Node.js 20.x and `yarn`.
# - https://github.com/timbru31/docker-ruby-node/blob/master/3.2/16/slim/Dockerfile
#
RUN curl -fsSL https://rpm.nodesource.com/setup_20.x | bash - \
  && dnf install -y nodejs \
  && dnf clean all \
  && npm install -g yarn@1

ENV RUBY_ENGINE=truffleruby

ENV RUBY_ENGINE_VERSION=22.3

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
