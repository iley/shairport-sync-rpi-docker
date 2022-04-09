FROM ubuntu:20.04 AS builder
RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    build-essential git xxd xmltoman autoconf automake libtool \
    libpopt-dev libconfig-dev libasound2-dev avahi-daemon libavahi-client-dev libssl-dev libsoxr-dev \
    libplist-dev libsodium-dev libavutil-dev libavcodec-dev libavformat-dev uuid-dev libgcrypt-dev
RUN git clone https://github.com/mikebrady/shairport-sync.git /build/shairport-sync
WORKDIR /build/shairport-sync
RUN git checkout development && \
  autoreconf -fi && \
  ./configure --sysconfdir=/etc --with-alsa --with-soxr --with-avahi --with-ssl=openssl --with-systemd --with-airplay-2 && \
  make -j && \
  make install
RUN git clone https://github.com/mikebrady/nqptp.git /build/nqptp
WORKDIR /build/nqptp
RUN autoreconf -fi && ./configure --with-systemd-startup && make install

FROM ubuntu:20.04
RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    libpopt0 libconfig9 libasound2 avahi-daemon libavahi-client3 libssl1.1 libsoxr0 \
    libplist3 libsodium23 libavutil56 libavcodec58 libavformat58 libuuid1 libgcrypt20
COPY --from=builder /usr/local/bin/shairport-sync /usr/local/bin/shairport-sync
COPY --from=builder /etc/shairport-sync.conf /etc/shairport-sync.conf
COPY --from=builder /usr/local/bin/nqptp /usr/local/bin/nqptp
COPY start.sh /start.sh
WORKDIR /
ENV AIRPLAY_NAME RaspberryPi
# output device e.g. hw:sndrpihifiberry
ENV OUTPUT_DEVICE default
ENTRYPOINT ["/start.sh"]
