#!/bin/bash

if [ $# -gt 4 ]; then
  echo "Usage: faban_client WEB_SERVER_IP [LOAD_SCALE] RUNTIME_HOST PORT"
  exit 1
fi

if [ $# -lt 1 ]; then
  echo "Web server IP is a mandatory parameter."
  exit 1
fi

WEB_SERVER_IP=$1
LOAD_SCALE=${2:-7}
RUNTIME_HOST=$3
PORT=$4

#while [ "$(curl -sSI web_server:8080 | grep 'HTTP/1.1' | awk '{print $2}')" != "200" ]; do
#  sleep 1
#done
/faban/master/bin/startup.sh
cd /web20_benchmark/build && java -jar Usergen.jar http://${WEB_SERVER_IP}:8080

sed -i "s/<fa:scale.*/<fa:scale>${LOAD_SCALE}<\\/fa:scale>/" /web20_benchmark/deploy/run.xml
sed -i "s/<fa:rampUp.*/<fa:rampUp>150<\\/fa:rampUp>/" /web20_benchmark/deploy/run.xml
sed -i "s/<fa:rampDown.*/<fa:rampDown>10<\\/fa:rampDown>/" /web20_benchmark/deploy/run.xml
sed -i "s/<fa:steadyState.*/<fa:steadyState>1050<\\/fa:steadyState>/" /web20_benchmark/deploy/run.xml
sed -i "s/<host.*/<host>${WEB_SERVER_IP}<\\/host>/" /web20_benchmark/deploy/run.xml
sed -i "s/<port.*/<port>8080<\\/port>/" /web20_benchmark/deploy/run.xml
sed -i "s/<runtimeStats enabled=\"false*/<runtimeStats enabled=\"true/" /web20_benchmark/deploy/run.xml
sed -i "s/<runtimeStats\ target=\"url*/<runtimeStats target=\"http\:\/\/$RUNTIME_HOST\:$PORT\/api\/runtime_perf/" /web20_benchmark/deploy/run.xml
sed -i "s/<outputDir.*/<outputDir>\/faban\/output<\\/outputDir>/" /web20_benchmark/deploy/run.xml

/bin/bash
#cd /web20_benchmark && /bin/bash
#cd /web20_benchmark && ant run
#cat /faban/output/*/summary.xml

