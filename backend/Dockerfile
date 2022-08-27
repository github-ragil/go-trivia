FROM golang:latest
RUN mkdir /app
ADD . /app/
WORKDIR /app
RUN go build -o ./build/main github.com/github-ragil/go-trivia/backend/cmd/triviabackend
CMD ["/app/build/main"]