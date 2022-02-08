FROM debian:bullseye-slim AS build

WORKDIR /build
COPY . ./
RUN apt update && \
    apt install -y cmake libgetdns-dev libssl-dev libsystemd-dev libyaml-dev && \
    cmake . && make


FROM debian:bullseye-slim AS final

WORKDIR /stubby
RUN apt update && \
    apt install -y ca-certificates libgetdns10 libyaml-0-2 && \
    rm -rf /var/lib/apt/lists/*
COPY --from=build /build/stubby .

EXPOSE 53/udp

CMD [ "./stubby", "-v", "4" ]
