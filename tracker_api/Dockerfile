# builder
FROM golang:1.25.4 AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-s -w" -o /app/main .

# runtime
FROM gcr.io/distroless/static:nonroot
WORKDIR /
COPY --from=builder /app/main /main
EXPOSE 4000
USER nonroot
ENTRYPOINT ["/main"]
