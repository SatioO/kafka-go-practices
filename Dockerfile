FROM golang:alpine AS builder

# Install git.
# Git is required for fetching the dependencies.
RUN apk update && apk add --no-cache git

WORKDIR $GOPATH/src/projects/beanstalk
COPY . .

# Using go get.
RUN go get -d -v
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -ldflags="-w -s" -o /bin/demo application.go

FROM scratch
COPY --from=builder /bin/demo /bin/demo
ENTRYPOINT ["/bin/demo"]