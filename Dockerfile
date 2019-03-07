FROM golang:1.12-alpine AS build-env
RUN apk add git
RUN mkdir -p $GOPATH/src/github.com/mongodb
RUN git clone https://github.com/mongodb/mongo-tools-common.git $GOPATH/src/github.com/mongodb/mongo-tools-common
RUN git clone https://github.com/mongodb/mongo-tools.git $GOPATH/src/github.com/mongodb/mongo-tools
RUN cd $GOPATH/src/github.com/mongodb/mongo-tools && \
    . ./set_goenv.sh && \
    mkdir bin && \
    go build -o bin/mongodump mongodump/main/mongodump.go && \
    go build -o bin/mongorestore mongorestore/main/mongorestore.go && \
    cp -pr bin /built-bin

FROM golang:1.12-alpine
COPY --from=build-env /built-bin/mongodump /usr/bin
COPY --from=build-env /built-bin/mongorestore /usr/bin

