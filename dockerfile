FROM alpine

RUN apk --update add --no-cache libwebp libwebp-tools

RUN mkdir -p /minecraftftb

WORKDIR /tmp/ftb
COPY setup.sh .
RUN chmod u+x setup.sh

ENV MAXMEMORY="6G"
ENV MINMEMORY="3G"

CMD [ "sh", "./setup.sh" ]
