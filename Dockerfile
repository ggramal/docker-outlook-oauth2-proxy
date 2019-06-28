FROM golang:1.12 as build

RUN curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh
RUN cd /go/src/ && git clone https://github.com/ggramal/oauth2_proxy.git

WORKDIR /go/src/oauth2_proxy

COPY build.sh .

RUN ./build.sh

FROM golang:1.12
COPY --from=build /go/src/oauth2_proxy/build /go/bin/

ENTRYPOINT ["oauth2_proxy"]
