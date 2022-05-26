FROM alpine:3.15.4
RUN apk add --no-cache bash
COPY env_check.sh /bin/
ENTRYPOINT ["env_check.sh"]
