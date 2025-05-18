FROM otel/opentelemetry-collector-builder:0.123.0 as builder
WORKDIR /app
COPY . .
RUN CGO_ENABLED=0 ocb --config=./manifest.yaml

FROM alpine/git:2.47.2 AS fetcher
RUN git clone --depth=1 --branch v0.4.0 https://github.com/k4ji/tracesimulationreceiver.git /tmp/tracesim

FROM gcr.io/distroless/static-debian12
COPY --from=builder /app/otelcol /otelcol
COPY --from=fetcher /tmp/tracesim/example /etc/otelcol/example
USER nonroot
ENTRYPOINT ["/otelcol"]
