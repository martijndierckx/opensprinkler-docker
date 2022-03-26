FROM alpine:latest as base-img

# BUILD
# -----------------------------
FROM base-img as build-img
RUN apk --no-cache add bash ca-certificates g++ unzip wget mosquitto-dev wiringpi
RUN wget https://github.com/OpenSprinkler/OpenSprinkler-Firmware/archive/master.zip
RUN unzip master.zip
RUN cd /OpenSprinkler-Firmware-master && \
    ./build.sh -s ospi

# RUN
# -----------------------------
FROM base-img
RUN apk --no-cache add libstdc++ mosquitto-dev
RUN mkdir /OpenSprinkler
RUN mkdir -p /data/logs
RUN cd /OpenSprinkler && \
    ln -s /data/stns.dat && \
    ln -s /data/iopts.dat && \
    ln -s /data/nvcon.dat && \
    ln -s /data/done.dat && \
    ln -s /data/prog.dat && \
    ln -s /data/sopts.dat && \
    ln -s /data/nvm.dat && \
    ln -s /data/ifkey.txt && \
    ln -s /data/logs
COPY --from=build-img /OpenSprinkler-Firmware-master/OpenSprinkler /OpenSprinkler/OpenSprinkler
WORKDIR /OpenSprinkler

EXPOSE 8080
CMD [ "./OpenSprinkler" ]