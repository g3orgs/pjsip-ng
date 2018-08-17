FROM ubuntu:latest
MAINTAINER G3org <info@test.com>

RUN apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
            build-essential \
            ca-certificates \
            curl \
            nano \
            mc \
            libgsm1-dev \
            libspeex-dev \
            libspeexdsp-dev \
            libsrtp0-dev \
            libssl-dev \
            portaudio19-dev \
	    python \
	    python-dev \
            python-pip \
            python-virtualenv \
	    python3-setuptools \
            python-setuptools \
            && \
    apt-get purge -y --auto-remove && rm -rf /var/lib/apt/lists/*
RUN pip install paho-mqtt

COPY config_site.h /tmp/
ENV PJSIP_VERSION=2.7.2
ENV  CFLAGS="-O2 -DNDEBUG"
ENV  CFLAGS="$CFLAGS -fPIC"
RUN mkdir /usr/src/pjsip && \

    cd /usr/src/pjsip && \
    curl -vsL http://www.pjsip.org/release/${PJSIP_VERSION}/pjproject-${PJSIP_VERSION}.tar.bz2 | \
         tar --strip-components 1 -xj && \
    mv /tmp/config_site.h pjlib/include/pj/ && \
    ./configure --enable-shared \
                --disable-opencore-amr \
                --disable-resample \
                --disable-sound \
                --disable-video \
                --with-external-gsm \
                --with-external-pa \
                --with-external-speex \
                --with-external-srtp \
                --prefix=/usr \
                && \
    make all install && \
    /sbin/ldconfig && \
#    rm -rf /usr/src/pjsip
    cd /usr/src/pjsip/pjsip-apps/src/python && \
    python setup.py build && python setup.py install

RUN mkdir /opt/sip2mqtt/
RUN curl -L https://raw.githubusercontent.com/MartyTremblay/sip2mqtt/master/sip2mqtt.py -o /opt/sip2mqtt/sip2mqtt.py

RUN cd /usr/src/pjsip/pjsip-apps/src/python && \
    python setup.py build && python setup.py install


ENV MQTT_TOPIC sip2mqtt/softphone
ENV MQTT_DOMAIN 192.168.5.2
ENV MQTT_PORT 1830
ENV MQTT_USERNAME user
ENV MQTT_PASSWORD password
ENV SIP_DOMAIN sipgate.de
ENV SIP_USERNAME sipuser
ENV SIP_PASSWORD sippassword

CMD /bin/sh -c "python /opt/sip2mqtt/sip2mqtt.py --mqtt_topic $MQTT_TOPIC --mqtt_domain $MQTT_DOMAIN --mqtt_port $MQTT_PORT --mqtt_username $MQTT_USERNAME --mqtt_password $MQTT_PASSWORD --sip_domain $SIP_DOMAIN --sip_username $SIP_USERNAME --sip_password $SIP_PASSWORD"
#CMD /bin/sh -c "python /opt/sip2mqtt/sip2mqtt.py --mqtt_topic $MQTT_TOPIC --mqtt_domain $MQTT_DOMAIN --m$
#CMD ["python", "/opt/sip2mqtt/sip2mqtt.py", ""]

