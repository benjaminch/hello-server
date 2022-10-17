FROM rust:1.62 AS builder
COPY . .
RUN cargo build --release

FROM debian:buster-slim
EXPOSE 3000
COPY --from=builder ./target/release/echo_server ./target/release/echo_server
CMD ["/target/release/echo_server"]