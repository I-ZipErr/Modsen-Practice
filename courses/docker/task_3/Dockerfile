FROM golang:alpine AS builder
WORKDIR /build
ENV CGO_ENABLED=0
ENV GOOS=linux
COPY . .
RUN go mod download
RUN go build -ldflags="-s -w" -o tictactoe game.go

FROM alpine
WORKDIR /game
COPY --from=builder /build/tictactoe ./tictactoe
ENTRYPOINT ["./tictactoe"]