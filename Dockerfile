FROM golang:alpine
MAINTAINER Mark Jozefiak <ImEmJay@gmail.com>

#--
#-- Build variables
#--
ARG DUPLICACY_VERSION=2.3.0

#--
#-- Environment variables
#--
#ENV GOROOT /usr/lib/go
#ENV GOPATH /go
#ENV PATH /go/bin:$PATH

ENV BACKUP_SCHEDULE='* * * * *' \
    BACKUP_NAME='' \
    BACKUP_LOCATION='' \
    BACKUP_ENCRYPTION_KEY='' \
    BACKUP_IMMEDIATLY='no' \
    BACKUP_IMMEDIATELY='no' \
    DUPLICACY_BACKUP_OPTIONS='-threads 4 -stats' \
    DUPLICACY_INIT_OPTIONS='' \
    AWS_ACCESS_KEY_ID='' \
    AWS_SECRET_KEY='' \
    WASABI_KEY='' \
    WASABI_SECRET='' \
    B2_ID='' \
    B2_KEY='' \
    HUBIC_TOKEN_FILE='' \
    SSH_PASSWORD='' \
    SSH_KEY_FILE='' \
    DROPBOX_TOKEN='' \
    AZURE_KEY='' \
    GCD_TOKEN='' \
    GCS_TOKEN_FILE='' \
    ONEDRIVE_TOKEN_FILE='' \
    PRUNE_SCHEDULE='0 0 * * *' \
    DUPLICACY_PRUNE_OPTIONS=''

#--
#-- Other steps
#--
RUN apk --no-cache add ca-certificates && update-ca-certificates
RUN apk --no-cache add git make musl-dev go
RUN go get github.com/gilbertchen/duplicacy/...
RUN cd $GOPATH/src/github.com/gilbertchen/duplicacy && go build duplicacy/duplicacy_main.go

RUN mkdir /app
WORKDIR /app

ADD *.sh ./
RUN chmod +x *.sh

VOLUME ["/data"]
ENTRYPOINT ["/app/entrypoint.sh"]
