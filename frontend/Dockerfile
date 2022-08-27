FROM golang:latest
RUN mkdir /app
ADD . /app/
WORKDIR /app
RUN go mod download github.com/joho/godotenv
RUN go build -o ./build/main github.com/github-ragil/go-trivia/frontend/cmd/triviafrontend
CMD ["/app/build/main"]