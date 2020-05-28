#!/bin/bash

# Run it every thursday morning at 6am
# 0 6 * * 4 hberaud cd /home/hberaud/dev/perso/openstack.reports; tools/release_oslo.sh
output=./reports/releases/oslo/$(date '+%Y-%m-%d-%H-%m-%s')

if [ -d ${output} ]; then
    rm -rf ${output}
fi
mkdir ${output}

cd ${base}/dev/redhat/upstream/openstack/releases;
./tools/list_unreleased_changes.sh master \
    $(.tox/venv/bin/list-deliverables --team oslo -r) > ${output}/master.tmp
awk 'NF' ${output}/master.tmp > ${output}/master.tmp2
sed -i -e 's/^/#-# /' ${output}/master.tmp2
cat ${output}/master.tmp2 >> ${output}/master
./tools/list_unreleased_changes.sh master \
    $(.tox/venv/bin/list-deliverables --team oslo -r --series independent) > ${output}/indep.tmp
awk 'NF' ${output}/indep.tmp > ${output}/indep.tmp2
sed -i -e 's/^/#-# /' ${output}/indep.tmp2
cat ${output}/indep.tmp2 >> ${output}/indep
./tools/list_unreleased_changes.sh stable/ussuri \
    $(.tox/venv/bin/list-deliverables --team oslo -r --series ussuri) > ${output}/ussuri.tmp
awk 'NF' ${output}/ussuri.tmp > ${output}/ussuri.tmp2
sed -i -e 's/^/#-# /' ${output}/ussuri.tmp2
cat ${output}/ussuri.tmp2 >> ${output}/ussuri
./tools/list_unreleased_changes.sh stable/train \
    $(.tox/venv/bin/list-deliverables --team oslo -r --series train) > ${output}/train.tmp
awk 'NF' ${output}/train.tmp > ${output}/train.tmp2
sed -i -e 's/^/#-# /' ${output}/train.tmp2
cat ${output}/train.tmp2 >> ${output}/train
./tools/list_unreleased_changes.sh stable/stein \
    $(.tox/venv/bin/list-deliverables --team oslo -r --series stein) > ${output}/stein.tmp
awk 'NF' ${output}/stein.tmp > ${output}/stein.tmp2
sed -i -e 's/^/#-# /' ${output}/stein.tmp2
cat ${output}/stein.tmp2 >> ${output}/stein
rm ${output}/*.tmp*

git add ${output}
git commit -m "Oslo releases report $(date)"
git push
