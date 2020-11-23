FROM golang:alpine AS builder

# Installs git
# Required for fetching the dependencies
RUN apk update && apk add --no-cache git

# Sets the path for the project and copies it to it
WORKDIR $GOPATH/src/test/
COPY . .

# Fetch dependencies
# -d flag stops from installing unncessary packages
RUN go get -d -v

# Builds the binary to the output specified
# And compiles only to linux for smaller foot print
RUN GOOS=linux GOARCH=amd64 go build -ldflags="-w -s" -o $GOPATH/bin/test

# Step 2, build a small image
FROM scratch

# Copy our static executable built, from-to path
COPY --from=builder $GOPATH/bin/test /go/bin/test

ENTRYPOINT [ "test" ]