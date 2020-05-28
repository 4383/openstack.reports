#!/bin/bash

source $( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )/base.sh

if [ -d ${BASE}/.venv ]; then
    rm -rf .venv
fi
python3.8 -m venv ${BASE}/.venv
source ${BASE}/.venv/bin/activate
${BASE}/tools/prepare.sh
${BASE}/tools/report.sh
deactivate
