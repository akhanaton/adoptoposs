FROM elixir:1.10.1-alpine as dev

COPY .build-deps /
RUN cat .build-deps | xargs apk add

WORKDIR /app

COPY mix* ./
RUN mix do \
    local.hex --force, \
    local.rebar --force

FROM dev as ci
RUN mix do \
    deps.get, \
    deps.compile

COPY assets/package.json assets/yarn.lock /app/assets/
RUN apk update \
    && apk add -u yarn \
    && cd assets \
    && yarn install

COPY . ./
