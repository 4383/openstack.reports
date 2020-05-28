#!/bin/bash
set -e
set -x

source $( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )/base.sh
source ${BASE}/.venv/bin/activate

if [ -d tmp/ ]; then
    rm -rf tmp/
fi

mkdir tmp

cd tmp/
#git clone git@github.com:openstack/governance
git clone git@github.com:openstack/releases
cd releases
pip install pbr
pip install requests
python setup.py develop
pip install -r test-requirements.txt
cd ${BASE}
