FROM alpine:latest
LABEL maintainer=bclemens

ENV BITLBEE_COMMIT 246b98b
ENV DISCORD_COMMIT 4fc5649
ENV FACEBOOK_COMMIT 553593d
ENV HANGOUTS_COMMIT 0e137e6
ENV LINE_COMMIT 156f411
ENV MASTODON_COMMIT 0095ef0
ENV SKYPE_COMMIT c395028
ENV SLACK_COMMIT b0f1550
ENV STEAM_COMMIT a6444d2
ENV TELEGRAM_COMMIT 94dd3be
ENV VK_COMMIT 51a91c8
ENV WECHAT_COMMIT 17b15e5
ENV YAHOO_COMMIT fbbd9c5

RUN set -x \
    && apk update \
    && apk upgrade \
    && apk add --virtual build-dependencies \
    autoconf \
    automake \
    bison \
    boost-dev \
    build-base \
    cargo \
    clang \
    cmake \
    curl \
    flex \
    git \
    json-glib-dev \
    libotr-dev \
    libtool \
    libxml2-dev \
    mercurial \
    openssl-dev \
    protobuf-c-dev \
    && apk add --virtual runtime-dependencies \
    glib-dev \
    gnutls-dev \
    json-glib \
    libgcrypt-dev \
    libotr \
    libpurple \
    libpurple-bonjour \
    libpurple-oscar \
    libpurple-xmpp \
    libwebp-dev \
    openssl \
    pidgin-dev \
    protobuf-c \
    && cd /root \
    && git clone -n https://github.com/bitlbee/bitlbee \
    && cd bitlbee \
    && git checkout ${BITLBEE_COMMIT} \
    && mkdir /bitlbee-data \
    && ./configure --build=x86_64-alpine-linux-musl --host=x86_64-alpine-linux-musl --otr=plugin --purple=1 --ssl=openssl --config=/bitlbee-data \
    && make \
    && make install \
    && make install-dev \
    && make install-etc \
    && cd /root \
    && git clone -n https://github.com/sm00th/bitlbee-discord \
    && cd bitlbee-discord \
    && git checkout ${DISCORD_COMMIT} \
    && ./autogen.sh \
    && ./configure \
    && make \
    && make install \
    && strip /usr/local/lib/bitlbee/discord.so \
    && cd /root \
    && git clone -n https://github.com/jgeboski/bitlbee-facebook \
    && cd bitlbee-facebook \
    && git checkout ${FACEBOOK_COMMIT} \
    && ./autogen.sh \
    && make \
    && make install \
    && strip /usr/local/lib/bitlbee/facebook.so \
    && cd /root \
    && hg clone https://bitbucket.org/EionRobb/purple-hangouts \
    && cd purple-hangouts \
    && hg update ${HANGOUTS_COMMIT} \
    && make \
    && make install \
    && strip /usr/lib/purple-2/libhangouts.so \
    && cd /root \
    && git clone -n https://gitlab.com/bclemens/purple-line \
    && cd purple-line \
    && git checkout ${LINE_COMMIT} \
    && make THRIFT_STATIC=true \
    && make install \
    && strip /usr/lib/purple-2/libline.so \
    && cd /root \
    && git clone -n https://github.com/kensanata/bitlbee-mastodon \
    && cd bitlbee-mastodon \
    && git checkout ${MASTODON_COMMIT} \
    && ./autogen.sh \
    && ./configure \
    && make \
    && make install \
    && cd /root \
    && git clone -n https://github.com/EionRobb/skype4pidgin \
    && cd skype4pidgin \
    && git checkout ${SKYPE_COMMIT} \
    && cd skypeweb \
    && make \
    && make install \
    && strip /usr/lib/purple-2/libskypeweb.so \
    && cd /root \
    && git clone -n https://github.com/dylex/slack-libpurple \
    && cd slack-libpurple \
    && git checkout ${SLACK_COMMIT} \
    && make \
    && make install \
    && cd /root \
    && git clone -n https://github.com/bitlbee/bitlbee-steam \
    && cd bitlbee-steam \
    && git checkout ${STEAM_COMMIT} \
    && ./autogen.sh \
    && make \
    && make install \
    && strip /usr/local/lib/bitlbee/steam.so \
    && cd /root \
    && git clone -n https://github.com/majn/telegram-purple \
    && cd telegram-purple \
    && git checkout ${TELEGRAM_COMMIT} \
    && git submodule update --init --recursive \
    && ./configure \
    && make \
    && make install \
    && strip /usr/lib/purple-2/telegram-purple.so \
    && cd /root \
    && git clone -n https://github.com/sbwtw/pidgin-wechat \
    && cd pidgin-wechat \
    && git checkout ${WECHAT_COMMIT} \
    && cargo build --release \
    && cp target/release/libwechat.so /usr/lib/purple-2/ \
    && strip /usr/lib/purple-2/libwechat.so \
    && cd /root \
    && hg clone https://bitbucket.org/olegoandreev/purple-vk-plugin \
    && cd purple-vk-plugin \
    && hg update ${VK_COMMIT} \
    && cd build \
    && cmake .. \
    && make \
    && make install \
    && cd /root \
    && git clone -n https://github.com/EionRobb/funyahoo-plusplus \
    && cd funyahoo-plusplus \
    && git checkout ${YAHOO_COMMIT} \
    && make \
    && make install \
    && strip /usr/lib/purple-2/libyahoo-plusplus.so \
    && apk del --purge build-dependencies \
    && rm -rf /root/* \
    && rm -rf /var/cache/apk/* \
    && adduser -u 1000 -S bitlbee \
    && addgroup -g 1000 -S bitlbee \
    && chown -R bitlbee:bitlbee /bitlbee-data \
    && touch /var/run/bitlbee.pid \
    && chown bitlbee:bitlbee /var/run/bitlbee.pid; exit 0

USER bitlbee
VOLUME /bitlbee-data
ENTRYPOINT ["/usr/local/sbin/bitlbee", "-F", "-n", "-d", "/bitlbee-data"]
