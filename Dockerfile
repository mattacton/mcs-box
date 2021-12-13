FROM openjdk:18-slim-bullseye

RUN apt-get update && apt-get install -y \
    dumb-init \
    jq

EXPOSE 25565
VOLUME [ "/mcs" ]
RUN mkdir /mcs-server /mcs-extras

COPY server /mcs-server
RUN chmod 544 /mcs-server/pre-start.sh

COPY datapacks/* /mcs-extras

WORKDIR /mcs
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["bash", "-c", "/mcs-server/pre-start.sh && exec java -Xms1G -Xmx3G -Dlog4j2.formatMsgNoLookups=true -jar server.jar nogui"]
