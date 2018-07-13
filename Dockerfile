FROM tomwilkie/prom-run:latest

RUN apk add --no-cache curl bash

RUN curl -LJo /kubecfg https://github.com/ksonnet/kubecfg/releases/download/v0.8.0/kubecfg-linux-amd64 && chmod +x /kubecfg

ADD runner.sh ./

ENTRYPOINT ["./prom-run"]
