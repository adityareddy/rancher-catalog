FROM        clusterhq/flocker-dataset-agent:latest

ADD         . /tmp/

RUN         chmod +x /tmp/setup.sh && ./tmp/setup.sh

CMD         ["/tmp/wrap_dataset_agent_mtab.sh"]
