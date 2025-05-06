FROM otel/opentelemetry-collector-builder:0.123.0 as builder

WORKDIR /app

COPY . .

RUN CGO_ENABLED=0 ocb --config=./manifest.yaml

FROM gcr.io/distroless/static-debian12

COPY --from=builder /app/otelcol /otelcol

USER nonroot

ENTRYPOINT ["/otelcol"]
