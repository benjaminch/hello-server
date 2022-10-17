FROM clux/muslrust as builder

RUN apt-get update && apt-get install -y ca-certificates

RUN rustup target add x86_64-unknown-linux-musl

WORKDIR /app

# Copy just the Cargo.toml/Cargo.lock over, so source code changes don't
# invalidate the cached layers
COPY Cargo.toml .
COPY Cargo.lock .

# Copy the actual source code over
COPY src/ src/

# Build the binary
RUN cargo build --release --target x86_64-unknown-linux-musl

FROM scratch

WORKDIR /app

# Copy the SSL certs over
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

# Copy just the binary over
COPY --from=builder \
  /app/target/x86_64-unknown-linux-musl/release/hello_server ./

CMD ["/app/hello_server"]