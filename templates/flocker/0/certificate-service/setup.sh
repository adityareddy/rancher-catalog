#!/bin/bash

META_URL="http://rancher-metadata/2015-07-25"
SELF_NAME=$(curl -s -H 'Accept: application/json' ${META_URL}/self/host| jq -r .name)

export PATH=$PATH:/opt/flocker/bin/

rm /etc/flocker/*
cp /app/agent.yml /etc/flocker/agent.yml
echo -e "\n  hostname: \"${SELF_NAME}\"" >> /etc/flocker/agent.yml
curl -LOk https://s3.ap-south-1.amazonaws.com/adityareddy-rancher/certs/cluster.crt
curl -LOk https://s3.ap-south-1.amazonaws.com/adityareddy-rancher/certs/cluster.key
# if [ "$NODE" = "CONTROL" ]
# then
    flocker-ca create-control-certificate $(hostname) 
    rename 's/[^.]*/control-service/' control*
# fi
flocker-ca create-node-certificate
for OUTPUT in $(ls -Art | tail -n 2)
do
  echo $OUTPUT
	mv $OUTPUT ${OUTPUT/*./node.}
done
chmod 0600 /etc/flocker/*

git clone https://github.com/adityareddy/lunanode-flocker-plugin
/opt/flocker/bin/pip install huawei-oceanstor-flocker-plugin/