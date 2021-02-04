FROM python:3.7-stretch
LABEL robinhood-services

########################################
# Setup Base Dependencies
########################################

RUN apt update && \
    apt install -y wget zip unzip vim curl && 

RUN pip install --upgrade pip && \
    pip install databricks-cli

########################################
# Local Project Setup
########################################

WORKDIR /workspace

# Development requirements
COPY ./admin/requirements.txt ./admin/requirements.txt
RUN python3 -m pip install -r admin/requirements.txt

# Project requirements
COPY ./requirements.txt ./requirements.txt
RUN python3 -m pip install -r requirements.txt

COPY . .

CMD ["/workspace/admin/entrypoint.sh"]
