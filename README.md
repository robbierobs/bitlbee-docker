## BitlBee, fully loaded.
![Docker Pulls](https://img.shields.io/docker/pulls/bclemens/bitlbee.svg)
![Docker Stars](https://img.shields.io/docker/stars/bclemens/bitlbee.svg)

Batteries-included build of BitlBee with OTR and support for:
* AIM
* Bonjour
* [Discord](https://github.com/sm00th/bitlbee-discord)
* [Facebook](https://github.com/jgeboski/bitlbee-facebook)
* Gadu-Gadu
* [Hangouts](https://bitbucket.org/EionRobb/purple-hangouts)
* ICQ
* Indenti.ca
* Jabber / XMPP
* [Mastodon](https://github.com/kensanata/bitlbee-mastodon)
* [Naver LINE](https://gitlab.com/bclemens/purple-line)
* Novell GroupWise
* [Skype](https://github.com/EionRobb/skype4pidgin)
* [Slack](https://github.com/dylex/slack-libpurple)
* [Steam](https://github.com/bitlbee/bitlbee-steam)
* [Telegram](https://github.com/majn/telegram-purple)
* [Wechat](https://github.com/sbwtw/pidgin-wechat)
* [Yahoo](https://github.com/EionRobb/funyahoo-plusplus)
* Zephyr

## Typical Usage

For configuration persistance, `/opt/dockerdata/bitlbee` should be present on the host with sufficient permissions.

##### Using Docker CLI
```
docker run -d --name bitlbee --restart=always \
-v /opt/dockerdata/bitlbee:/bitlbee-data:rw \
-v /etc/localtime:/etc/localtime:ro \
-p 6667:6667 \
bclemens/bitlbee
```

##### Using Docker Compose
```
docker-compose up -d
```


