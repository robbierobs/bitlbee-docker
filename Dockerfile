FROM alpine:latest

ARG BUILD_DATE
ARG MAKEFLAGS=-j12
ARG VCS_REF

# Updates 06/09/2022
# Facebook
# Discord

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="BitlBee" \
      org.label-schema.description="BitlBee, fully loaded." \
      org.label-schema.url="https://tiuxo.com" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/brianclemens/bitlbee-docker" \
      org.label-schema.vendor="Tiuxo" \
      org.label-schema.schema-version="1.1"

ENV BITLBEE_COMMIT=fe122f3 \
    DISCORD_COMMIT=607f988 \
    FACEBOOK_COMMIT=a31ccbe \
    HANGOUTS_COMMIT=3f7d89b \
    LINE_COMMIT=156f411 \
    MASTODON_COMMIT=aa9f931 \
    MATRIX_COMMIT=4494ba2 \
    MATTERMOST_COMMIT=19db180 \
    PUSHBULLET_COMMIT=8a7837c \
    ROCKETCHAT_COMMIT=826990b \
    SKYPE_COMMIT=2f5a3e2 \
    SLACK_COMMIT=8acc4eb \
    STEAM_COMMIT=a6444d2 \
    TELEGRAM_COMMIT=b101bbb \
    VK_COMMIT=51a91c8 \
    WECHAT_COMMIT=eecd9c6 \
    WHATSAPP_COMMIT=81c7285 \
    YAHOO_COMMIT=fbbd9c5 \
    RUNTIME_DEPS=" \
        glib \
        gnutls \
        json-glib \
        libevent \
        libgcrypt \
        libotr \
        libpurple \
        libpurple-bonjour \
        libpurple-oscar \
        libpurple-xmpp \
        openldap \
        protobuf-c"


# bitlbee
RUN apk add --update --no-cache --virtual build-dependencies \
    build-base \
    git \
    gnutls-dev \
    libevent-dev \
    libotr-dev \
    pidgin-dev \
    openldap-dev; \
    apk add --no-cache --virtual runtime-dependencies ${RUNTIME_DEPS}; \
    apk add --no-cache su-exec; \
    cd /root; \
    git clone -n https://github.com/bitlbee/bitlbee; \
    cd bitlbee; \
    git checkout ${BITLBEE_COMMIT}; \
    cp bitlbee.conf /bitlbee.conf; \
    mkdir /bitlbee-data; \
    ./configure --build=x86_64-alpine-linux-musl --host=x86_64-alpine-linux-musl --debug=0 --events=libevent --ldap=1 --otr=plugin --purple=1 --config=/bitlbee-data; \
    make; \
    make install; \
    make install-dev; \
    make install-etc; \
    rm -rf /root; \
    mkdir /root; \
    apk del --purge build-dependencies

# discord
RUN apk add --no-cache --virtual build-dependencies \
    autoconf \
    automake \
    build-base \
    git \
    glib-dev \
    libtool; \
    cd /root; \
    git clone -n https://github.com/sm00th/bitlbee-discord; \
    cd bitlbee-discord; \
    git checkout ${DISCORD_COMMIT}; \
    ./autogen.sh; \
    ./configure --build=x86_64-alpine-linux-musl --host=x86_64-alpine-linux-musl; \
    make; \
    make install; \
    strip /usr/local/lib/bitlbee/discord.so; \
    rm -rf /root; \
    mkdir /root; \
    apk del --purge build-dependencies

# facebook
RUN apk add --no-cache --virtual build-dependencies \
    autoconf \
    automake \
    build-base \
    git \
    json-glib-dev \
    libtool; \
    cd /root; \
    git clone -n https://github.com/jgeboski/bitlbee-facebook; \
    cd bitlbee-facebook; \
    git checkout ${FACEBOOK_COMMIT}; \
    ./autogen.sh --build=x86_64-alpine-linux-musl --host=x86_64-alpine-linux-musl; \
    make; \
    make install; \
    strip /usr/local/lib/bitlbee/facebook.so; \
    rm -rf /root; \
    mkdir /root; \
    apk del --purge build-dependencies

# hangouts
RUN apk add --no-cache --virtual build-dependencies \
    build-base \
    json-glib-dev \
    mercurial \
    pidgin-dev \
    protobuf-c-dev; \
    cd /root; \
    hg clone -U https://bitbucket.org/EionRobb/purple-hangouts; \
    cd purple-hangouts; \
    hg update ${HANGOUTS_COMMIT}; \
    make; \
    make install; \
    strip /usr/lib/purple-2/libhangouts.so; \
    rm -rf /root; \
    mkdir /root; \
    apk del --purge build-dependencies

# naver line
# naver insta-bans 3rd-party clients now
# RUN apk add --no-cache --virtual build-dependencies \
#     boost-dev \
#     build-base \
#     curl \
#     flex \
#     git \
#     libgcrypt-dev \
#     libtool \
#     openssl-dev \
#     pidgin-dev; \
#     cd /root; \
#     git clone -n https://gitlab.com/bclemens/purple-line; \
#     cd purple-line; \
#     git checkout ${LINE_COMMIT}; \
#     make THRIFT_STATIC=true; \
#     make install; \
#     strip /usr/lib/purple-2/libline.so; \
#     rm -rf /root; \
#     mkdir /root; \
#     apk del --purge build-dependencies

# mastodon
RUN apk add --no-cache --virtual build-dependencies \
    autoconf \
    automake \
    build-base \
    git \
    glib-dev \
    libtool; \
    cd /root; \
    git clone -n https://github.com/kensanata/bitlbee-mastodon; \
    cd bitlbee-mastodon; \
    git checkout ${MASTODON_COMMIT}; \
    ./autogen.sh; \
    ./configure --build=x86_64-alpine-linux-musl --host=x86_64-alpine-linux-musl; \
    make; \
    make install; \
    strip /usr/local/lib/bitlbee/mastodon.so; \
    rm -rf /root; \
    mkdir /root; \
    apk del --purge build-dependencies

# matrix
RUN apk add --no-cache --virtual build-dependencies \
    build-base \
    http-parser-dev \
    json-glib-dev \
    git \
    sqlite-dev \
    pidgin-dev; \
    cd /root; \
    git clone -n https://github.com/matrix-org/purple-matrix; \
    cd purple-matrix; \
    git checkout ${MATRIX_COMMIT}; \
    make; \
    make install; \
    strip /usr/lib/purple-2/libmatrix.so; \
    rm -rf /root; \
    mkdir /root; \
    apk del --purge build-dependencies

# mattermost
RUN apk add --no-cache --virtual build-dependencies \
    build-base \
    discount-dev \
    git \
    json-glib-dev \
    pidgin-dev; \
    cd /root; \
    git clone -n https://github.com/EionRobb/purple-mattermost; \
    cd purple-mattermost; \
    git checkout ${MATTERMOST_COMMIT}; \
    make; \
    make install; \
    strip /usr/lib/purple-2/libmattermost.so; \
    rm -rf /root; \
    mkdir /root; \
    apk del --purge build-dependencies

# pushbullet
RUN apk add --no-cache --virtual build-dependencies \
    build-base \
    git \
    json-glib-dev \
    pidgin-dev; \
    cd /root; \
    git clone -n https://github.com/EionRobb/pidgin-pushbullet; \
    cd pidgin-pushbullet; \
    git checkout ${PUSHBULLET_COMMIT}; \
    make; \
    make install; \
    strip /usr/lib/purple-2/libpushbullet.so; \
    rm -rf /root; \
    mkdir /root; \
    apk del --purge build-dependencies

# rocket.chat
RUN apk add --no-cache --virtual build-dependencies \
    build-base \
    discount-dev \
    json-glib-dev \
    mercurial \
    pidgin-dev; \
    cd /root; \
    hg clone -U https://bitbucket.org/EionRobb/purple-rocketchat; \
    cd purple-rocketchat; \
    hg update ${ROCKETCHAT_COMMIT}; \
    make; \
    make install; \
    strip /usr/lib/purple-2/librocketchat.so; \
    rm -rf /root; \
    mkdir /root; \
    apk del --purge build-dependencies

# skype
RUN apk add --no-cache --virtual build-dependencies \
    build-base \
    git \
    json-glib-dev \
    pidgin-dev; \
    cd /root; \
    git clone -n https://github.com/EionRobb/skype4pidgin; \
    cd skype4pidgin; \
    git checkout ${SKYPE_COMMIT}; \
    cd skypeweb; \
    make; \
    make install; \
    strip /usr/lib/purple-2/libskypeweb.so; \
    rm -rf /root; \
    mkdir /root; \
    apk del --purge build-dependencies

# slack
RUN apk add --no-cache --virtual build-dependencies \
    build-base \
    git \
    pidgin-dev; \
    cd /root; \
    git clone -n https://github.com/dylex/slack-libpurple; \
    cd slack-libpurple; \
    git checkout ${SLACK_COMMIT}; \
    make; \
    make install; \
    rm -rf /root; \
    mkdir /root; \
    apk del --purge build-dependencies

# steam
RUN apk add --no-cache --virtual build-dependencies \
    autoconf \
    automake \
    build-base \
    git \
    glib-dev \
    libgcrypt-dev \
    libtool; \
    cd /root; \
    git clone -n https://github.com/bitlbee/bitlbee-steam; \
    cd bitlbee-steam; \
    git checkout ${STEAM_COMMIT}; \
    ./autogen.sh --build=x86_64-alpine-linux-musl --host=x86_64-alpine-linux-musl; \
    make; \
    make install; \
    strip /usr/local/lib/bitlbee/steam.so; \
    rm -rf /root; \
    mkdir /root; \
    apk del --purge build-dependencies

# telegram
RUN apk add --no-cache --virtual build-dependencies \
    build-base \
    git \
    libgcrypt-dev \
    pidgin-dev; \
    cd /root; \
    git clone -n https://github.com/majn/telegram-purple; \
    cd telegram-purple; \
    git checkout ${TELEGRAM_COMMIT}; \
    git submodule update --init --recursive; \
    ./configure --build=x86_64-alpine-linux-musl --host=x86_64-alpine-linux-musl --disable-libwebp; \
    make; \
    make install; \
    strip /usr/lib/purple-2/telegram-purple.so; \
    rm -rf /root; \
    mkdir /root; \
    apk del --purge build-dependencies

# wechat
RUN apk add --no-cache --virtual build-dependencies \
    build-base \
    cargo \
    clang \
    git \
    openssl-dev \
    pidgin-dev; \
    cd /root; \
    git clone -n https://github.com/sbwtw/pidgin-wechat; \
    cd pidgin-wechat; \
    git checkout ${WECHAT_COMMIT}; \
    cargo build --release; \
    cp target/release/libwechat.so /usr/lib/purple-2; \
    strip /usr/lib/purple-2/libwechat.so; \
    rm -rf /root; \
    mkdir /root; \
    apk del --purge build-dependencies

# vkontakt
RUN apk add --no-cache --virtual build-dependencies \
    build-base \
    cmake \
    libtool \
    libxml2-dev \
    mercurial \
    pidgin-dev; \
    cd /root; \
    hg clone -U https://bitbucket.org/olegoandreev/purple-vk-plugin; \
    cd purple-vk-plugin; \
    hg update ${VK_COMMIT}; \
    cd build; \
    cmake ..; \
    make; \
    make install; \
    strip /usr/lib/purple-2/libpurple-vk-plugin.so; \
    rm -rf /root; \
    mkdir /root; \
    apk del --purge build-dependencies

# whatsapp
RUN apk add --no-cache --virtual build-dependencies \
    build-base \
    git \
    pidgin-dev \
    protobuf-dev; \
    cd /root; \
    git clone -n https://github.com/jakibaki/whatsapp-purple; \
    cd whatsapp-purple; \
    git checkout ${WHATSAPP_COMMIT}; \
    make; \
    make install; \
    strip /usr/lib/purple-2/libwhatsapp.so; \
    rm -rf /root; \
    mkdir /root; \
    apk del --purge build-dependencies

# yahoo
RUN apk add --no-cache --virtual build-dependencies \
    build-base \
    git \
    json-glib-dev \
    pidgin-dev; \
    cd /root; \
    git clone -n https://github.com/EionRobb/funyahoo-plusplus; \
    cd funyahoo-plusplus; \
    git checkout ${YAHOO_COMMIT}; \
    make; \
    make install; \
    strip /usr/lib/purple-2/libyahoo-plusplus.so; \
    rm -rf /root; \
    mkdir /root; \
    apk del --purge build-dependencies

EXPOSE 6667
VOLUME /bitlbee-data

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["/usr/local/sbin/bitlbee", "-F", "-n", "-d", "/bitlbee-data", "-c", "/bitlbee.conf"]
