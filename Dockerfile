# Build CLI tool
FROM rust:1-alpine3.18 as builder
RUN apk --no-cache add musl-dev perl make libconfig-dev openssl-dev yarn
WORKDIR /landscape2
COPY src/src src
COPY src/templates templates
COPY src/web web
COPY src/build.rs ./
COPY src/askama.toml ./
COPY src/Cargo.* ./
WORKDIR /landscape2/src
RUN cargo build --release

# Final stage
FROM alpine:3.18.4
RUN addgroup -S landscape2 && adduser -S landscape2 -G landscape2
RUN apk --no-cache add bash chromium font-ubuntu
USER landscape2
WORKDIR /home/landscape2
COPY --from=builder /landscape2/target/release/landscape2 /usr/local/bin
COPY src/scripts/landscape2-validate.sh /

# Run Stuff
WORKDIR /
MAINTAINER christina@cafkafk.com
COPY landscape2 /bin/
COPY build /var/landscape2/build

USER root
WORKDIR /var/landscape2
CMD ["/usr/local/bin/landscape2", "serve", "--addr", "0.0.0.0:80", "--landscape-dir", "build"]
