FROM elixir:1.13.0-rc.1-alpine
RUN apk add build-base
WORKDIR /app
COPY . /app
RUN mix local.hex --force \
    && mix local.rebar --force \
    && mix deps.get \
    && mix deps.compile \
    && mix release

FROM elixir:1.13.0-rc.1-alpine
WORKDIR /app
RUN apk update && apk upgrade && apk add bash
COPY --from=0 /app/_build/dev/rel/latency_simulator /app/latency_simulator
ENTRYPOINT exec /app/latency_simulator/bin/latency_simulator start