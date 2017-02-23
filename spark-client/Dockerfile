FROM ubuntu:16.04

MAINTAINER Pedro Alves <pmgalves@gmail.com>

WORKDIR /root

# install openssh-server, openjdk and wget
RUN apt-get update && apt-get install -y software-properties-common openssh-server openjdk-8-jdk wget curl

ENV HADOOP_VERSION=2.7.3
ENV SPARK_VERSION=2.1.0
ENV SPARK_HADOOP_VERSION=2.7

# instal Spark 2.1.0
RUN \
	curl http://d3kbcqa49mib13.cloudfront.net/spark-${SPARK_VERSION}-bin-hadoop${SPARK_HADOOP_VERSION}.tgz | tar -xz -C /usr/local/ && \
	ln -s /usr/local/spark-* /usr/local/spark

# set environment variable
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 
ENV HADOOP_HOME=/usr/local/hadoop
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV SPARK_HOME=/usr/local/spark
ENV PATH=$PATH:/usr/local/hadoop/bin:/usr/local/hadoop/sbin:/usr/local/spark/bin:/usr/local/spark/sbin

# ssh without key
RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys


COPY /config/* /tmp/

RUN mv /tmp/ssh_config ~/.ssh/config && \
		mkdir -p $HADOOP_CONF_DIR && \
    mv /tmp/*.xml $HADOOP_CONF_DIR && \ 
		echo spark.yarn.jars hdfs://hadoop-master:9000/spark/* > $SPARK_HOME/conf/spark-defaults.conf



# Configuring no_vnc

RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8 
ENV TERM xterm
RUN update-locale LANG=en_US.UTF-8 LC_MESSAGES=POSIX 
RUN echo Building core image
ENV DEBIAN_FRONTEND noninteractive

ENV DISPLAY :1
ENV NO_VNC_HOME /root/noVNC
ENV VNC_PORT 5901
ENV NO_VNC_PORT 6901

ENV VNC_COL_DEPTH 24
ENV VNC_RESOLUTION 1280x1024
ENV VNC_PW pentaho

RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections 
RUN add-apt-repository ppa:webupd8team/java && \
	apt-get update && \
	apt-get install -y oracle-java8-installer 

############## xvnc / xfce installation
RUN apt-get install -y supervisor net-tools vim xfce4 vnc4server wget firefox chromium-browser chromium-codecs-ffmpeg libwebkitgtk-1.0-0

### Install noVNC - HTML5 based VNC viewer
RUN mkdir -p $NO_VNC_HOME/utils/websockify \
    #&& wget -qO- https://github.com/ConSol/noVNC/archive/consol_1.0.0.tar.gz | tar xz --strip 1 -C $NO_VNC_HOME \
    && wget -qO- https://github.com/novnc/noVNC/archive/master.tar.gz | tar xz --strip 1 -C $NO_VNC_HOME \
    &&  wget -qO- https://github.com/kanaka/websockify/archive/v0.7.0.tar.gz | tar xz --strip 1 -C $NO_VNC_HOME/utils/websockify \
    && chmod +x -v /root/noVNC/utils/*.sh \
    && ln -s /usr/bin/chromium-browser /usr/bin/google-chrome \
    && echo "CHROMIUM_FLAGS='--no-sandbox --start-maximized --user-data-dir'" > ~/.chromium-browser.init


ADD files/ /root
RUN chmod +x /root/.vnc/xstartup /etc/X11/xinit/xinitrc /root/scripts/*.sh /root/Desktop/*.desktop



# xvnc server port, if $DISPLAY=:1 port will be 5901
EXPOSE 5901
# novnc web port
EXPOSE 6901


#ENTRYPOINT ["/bin/bash"]
ENTRYPOINT ["scripts/vnc_startup.sh","-t"]

