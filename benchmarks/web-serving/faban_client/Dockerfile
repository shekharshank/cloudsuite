FROM ubuntu:14.04
#MAINTAINER Nooshin Mirzadeh <nooshin.mirzadeh@epfl.ch>
MAINTAINER shashank shekhar <shekharshank@gmail.com> - performed few modifications for custom execution 

RUN apt-get update && apt-get install -y \
	ant \
	build-essential \
        curl \
	wget \
	software-properties-common \
	htop

# Install Java.
RUN \
  echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java7-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk7-installer

ENV JAVA_HOME /usr/lib/jvm/java-7-oracle

# Setup Faban 

RUN wget https://github.com/shekharshank/faban/raw/master/nightly/faban-kit-latest.tar.gz
RUN tar zxvf faban-kit-latest.tar.gz

COPY files/web20_benchmark /web20_benchmark

WORKDIR /web20_benchmark

# Build the Faban benchmark and the user-generation tool
RUN ant deploy.jar
RUN ant usergen-jar


# Copy files to their required locations
RUN cp /web20_benchmark/build/Web20Driver.jar /faban/benchmarks/

COPY files/usersetup.properties /faban/usersetup.properties

ADD bootstrap.sh /etc/bootstrap.sh
RUN chown root:root /etc/bootstrap.sh
RUN chmod 700 /etc/bootstrap.sh

ENTRYPOINT ["/etc/bootstrap.sh"]
