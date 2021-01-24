FROM ubuntu:20.04

RUN apt-get update
RUN apt-get install -y --no-install-recommends locales unzip wget

RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8

ARG KEY_PATH=/key.dat
ARG PASSWORD_FILE=/password.txt

ARG DOWNLOAD_URL=https://agents.checkbox.in.ua/agents/checkboxAgentSign/Linux/checkbox.sign-linux-x86_64.zip
ARG WORKDIR=/checkbox.sign

RUN wget $DOWNLOAD_URL
RUN unzip *.zip -d $WORKDIR
RUN rm -f *.zip

ARG ACSK
ARG LOGIN
ARG KEY
ARG PASSWORD
ARG API_URL

ENV ACSK=$ACSK
ENV LOGIN=$LOGIN
ENV KEY_PATH=$KEY_PATH
ENV PASSWORD_FILE=$PASSWORD_FILE
ENV API_URL=$API_URL

COPY $KEY $KEY_PATH
RUN test $PASSWORD && echo -n $PASSWORD > $PASSWORD_FILE || :

WORKDIR $WORKDIR
CMD echo $ACSK | ./srso_signer setup && ./srso_signer start --login $LOGIN --password-file $PASSWORD_FILE ${API_URL:+--api-url $API_URL }--infinity $KEY_PATH
