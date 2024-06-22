FROM node:20-bookworm-slim as node
FROM ruby:3.3.2-slim-bookworm
ENV LANG C.UTF-8

COPY --from=node /opt/yarn-v* /opt/yarn
COPY --from=node /usr/local/bin/node /usr/local/bin/
COPY --from=node /usr/local/lib/node_modules/ /usr/local/lib/node_modules/
RUN ln -s /opt/yarn/bin/yarn /usr/local/bin/yarn \
  && ln -s /opt/yarn/bin/yarn /usr/local/bin/yarnpkg \
  && ln -s /usr/local/bin/node /usr/local/bin/nodejs \
  && ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm \
  && ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npx

# Install packages needed to build gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libpq-dev libvips pkg-config curl postgresql-client file

WORKDIR /app

ENV RAILS_ENV development
ENV RACK_ENV development

RUN gem update --system

COPY .ruby-version .ruby-version
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install --jobs 20 --retry 5

COPY . /app

EXPOSE 3000

ENV RAILS_SERVE_STATIC_FILES 1

# コマンドはdocker-composeのほうで与える
# ENTRYPOINT ["bundle", "exec", "rails", "server", "-p", "3000", "-b", "0.0.0.0"]
