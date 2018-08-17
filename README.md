# pjsip-ng
# docker file to use pjsip2mqtt


It based on ubuntu latest with PJSIP version 2.7.2
PJSIP is a free and open source multimedia communication library written in C language implementing standard based protocols such as SIP, SDP, RTP, STUN, TURN, and ICE. It combines signaling protocol (SIP) with rich multimedia framework and NAT traversal functionality into high level API that is portable and suitable for almost any type of systems ranging from desktops, embedded systems, to mobile handsets.

pjsip-ng sip2mqtt working on synology 

```
ENV MQTT_TOPIC sip2mqtt/softphone
ENV MQTT_DOMAIN 192.168.x.x
ENV MQTT_PORT 1830
ENV MQTT_USERNAME user
ENV MQTT_PASSWORD password
ENV SIP_DOMAIN sipgate.de
ENV SIP_USERNAME sipuser
ENV SIP_PASSWORD sippassword
```

You have to configure this values corectly,otherwise the container will not start 

## usage 
To build this image, just clone this repo and build using docker:

```
git clone https://github.com/g3orgs/pjsip-ng.git
cd pjsip-ng
docker build -t pjsip-ng . 
```
it based on https://github.com/respoke/pjsip-docker 
