#!/bin/bash
set -e
set -x

source $( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )/base.sh
source ${BASE}/.venv/bin/activate

if [ ! -d tmp/ ]; then
    echo "Execution aborted please prepare env first"
fi

cd ${BASE}/tmp/releases
dir=$(date '+%Y-%m-%d')
report_dir=${BASE}/reports/releases/${dir}
if [ -d ${report_dir} ]; then
    rm -rf ${report_dir}
fi
mkdir ${report_dir}
list-deliverables --team oslo -r

eval $(niet -f eval series ${BASE}/conf.yaml)
## generate report for master
#./tools/list_unreleased_changes.sh master ${repos} #> ${report_dir}/master
## generate report for independent
#./tools/list_unreleased_changes.sh master $(.tox/venv/bin/list-deliverables --team oslo -r --series independent) #> ${report_dir}/independent
## generate report for stable branches
#for serie in ${series__stables}; do
#    ./tools/list_unreleased_changes.sh stable/${serie} $(.tox/venv/bin/list-deliverables --team oslo -r --series ${serie}) > ${report_dir}/${serie}
#done
cd $BASE
