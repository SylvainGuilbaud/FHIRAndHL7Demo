ARG IMAGE=docker.iscinternal.com/intersystems/irishealth:2019.2.0-latest
ARG IMAGE=store/intersystems/irishealth-community:2019.4.0.379.0

FROM $IMAGE
LABEL maintainer="Guillaume Rongier <guillaume.rongier@intersystems.com>"

RUN echo "password" > /tmp/password.txt && /usr/irissys/dev/Container/changePassword.sh /tmp/password.txt

#COPY misc/iris.key /usr/irissys/mgr/iris.key

COPY . /tmp/src

WORKDIR /tmp/src

RUN chmod 777 /home/$IRIS_OWNER/src/sampleFiles

COPY misc/$IRIS_LICENSE_FILENAME /usr/irissys/mgr/$IRIS_LICENSE_FILENAME
RUN iris start $ISC_PACKAGE_INSTANCENAME EmergencyId=sys,sys && \
 sh install.sh $ISC_PACKAGE_INSTANCENAME && \
 /bin/echo -e "sys\nsys\n" | iris stop $ISC_PACKAGE_INSTANCENAME quietly 

WORKDIR /home/irisowner/