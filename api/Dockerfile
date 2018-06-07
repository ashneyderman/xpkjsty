FROM elixir:1.5.2-alpine

RUN apk --no-cache update && \
    apk --no-cache add bash && \
    rm -rf /var/cache/apk/*

# Install apidocs archive pulling it from AWS
RUN mkdir /service
COPY ./_build/prod/rel/tcb_challenge/releases/0.0.1/tcb_challenge.tar.gz .
RUN tar zxf ./tcb_challenge.tar.gz -C /service/
 
EXPOSE 4000

STOPSIGNAL SIGTERM

CMD ["/service/bin/tcb_challenge", "foreground"]