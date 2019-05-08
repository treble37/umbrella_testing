FROM gcr.io/versus-infra-dev/releaser:elixir1.8

WORKDIR /opt/umbrella_testing

ADD . /opt/umbrella_testing

SHELL ["/bin/bash", "-c", "source .envrc"]

RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get

ENV MIX_ENV prod
CMD ["mix", "release"]
