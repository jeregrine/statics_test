ARG ELIXIR_VERSION=1.14.2
ARG OTP_VERSION=25.2
ARG DEBIAN_VERSION=bullseye-20221004-slim

ARG BUILDER_IMAGE="hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-debian-${DEBIAN_VERSION}"

FROM ${BUILDER_IMAGE}

# install build dependencies
RUN apt-get update -y && apt-get install -y build-essential git libstdc++6 openssl libncurses5 locales \
    && apt-get clean && rm -f /var/lib/apt/lists/*_*

# Set the locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

WORKDIR "/app"

ENV ECTO_IPV6 true
ENV ERL_AFLAGS "-proto_dist inet6_tcp"

COPY ./static /app/static
COPY index.html /app/
COPY scratch.exs /app
COPY init.sh /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

CMD ["/app/init.sh"]
