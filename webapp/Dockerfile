FROM node:alpine

RUN apk --no-cache update && \
    apk --no-cache add bash && \
    rm -rf /var/cache/apk/*

RUN npm install -g serve

RUN mkdir /service
COPY ./build/ /service
 
EXPOSE 3000

STOPSIGNAL SIGTERM

CMD ["serve", "-s", "/service"]

