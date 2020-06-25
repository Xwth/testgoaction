FROM golang:latest

WORKDIR /go/src/test
COPY . .

RUN go get ./
RUN go build

CMD ["test"]