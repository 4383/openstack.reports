#!/bin/bash

# Run it at every minute past hour 6 on Monday, Wednesday, and Friday
# 0 6 * * 1,3,5 hberaud cd /home/hberaud/dev/perso/openstack.reports; tools/release_oslo.sh

current=$(pwd)
base=/home/hberaud
id=$(date '+%Y-%m-%d-%H-%m-%s')
report_path=reports/releases/oslo/${id}
output=${current}/${report_path}

if [ -d ${output} ]; then
    rm -rf ${output}
fi
mkdir ${output}

cd ${base}/dev/redhat/upstream/openstack/releases;

#########################################
# cmd to use
#########################################
cat <<EOF > ${output}/shortcuts.sh
cd_oslo
cd releases
if [ -d openstack.reports ]; then
    rm -rf openstack.reports
fi
git clone git@github.com:4383/openstack.reports
cd_releses
sh ~/dev/redhat/upstream/openstack/oslo/releases/openstack.reports/${report_path}/master.sh
sh ~/dev/redhat/upstream/openstack/oslo/releases/openstack.reports/${report_path}/victoria.sh
sh ~/dev/redhat/upstream/openstack/oslo/releases/openstack.reports/${report_path}/ussuri.sh
sh ~/dev/redhat/upstream/openstack/oslo/releases/openstack.reports/${report_path}/train.sh
sh ~/dev/redhat/upstream/openstack/oslo/releases/openstack.reports/${report_path}/stein.sh
sh ~/dev/redhat/upstream/openstack/oslo/releases/openstack.reports/${report_path}/independent.sh
EOF

#########################################
# master
#########################################
.tox/venv/bin/list-deliverables --team oslo -r | awk -F "/" '{print "# tools/new_release.sh wallaby $2 " bugfix"}' > ${output}/master.sh
tox -e venv --notest
./tools/list_unreleased_changes.sh --ignore-all master \
    $(.tox/venv/bin/list-deliverables --team oslo -r) > ${output}/master.tmp
awk 'NF' ${output}/master.tmp > ${output}/master.tmp2
sed -i -e 's/^/#-# /' ${output}/master.tmp2
cat ${output}/master.tmp2 >> ${output}/master
#########################################
# independent
#########################################
.tox/venv/bin/list-deliverables --team oslo -r --series independent | awk -F "/" '{print "# tools/new_release.sh independent " $2 " bugfix"}' > ${output}/independent.sh
./tools/list_unreleased_changes.sh --ignore-all master \
    $(.tox/venv/bin/list-deliverables --team oslo -r --series independent) > ${output}/indep.tmp
awk 'NF' ${output}/indep.tmp > ${output}/indep.tmp2
sed -i -e 's/^/#-# /' ${output}/indep.tmp2
cat ${output}/indep.tmp2 >> ${output}/indep
#########################################
# victoria
#########################################
.tox/venv/bin/list-deliverables --team oslo -r --series victoria | awk -F "/" '{print "# tools/new_release.sh victoria " $2 " bugfix"}' > ${output}/victoria.sh
./tools/list_unreleased_changes.sh --ignore-all stable/victoria \
    $(.tox/venv/bin/list-deliverables --team oslo -r --series victoria) > ${output}/victoria.tmp
awk 'NF' ${output}/victoria.tmp > ${output}/victoria.tmp2
sed -i -e 's/^/#-# /' ${output}/victoria.tmp2
cat ${output}/victoria.tmp2 >> ${output}/victoria
#########################################
# ussuri
#########################################
.tox/venv/bin/list-deliverables --team oslo -r --series ussuri | awk -F "/" '{print "# tools/new_release.sh ussuri " $2 " bugfix"}' > ${output}/ussuri.sh
./tools/list_unreleased_changes.sh --ignore-all stable/ussuri \
    $(.tox/venv/bin/list-deliverables --team oslo -r --series ussuri) > ${output}/ussuri.tmp
awk 'NF' ${output}/ussuri.tmp > ${output}/ussuri.tmp2
sed -i -e 's/^/#-# /' ${output}/ussuri.tmp2
cat ${output}/ussuri.tmp2 >> ${output}/ussuri
#########################################
# train
#########################################
.tox/venv/bin/list-deliverables --team oslo -r --series train | awk -F "/" '{print "# tools/new_release.sh train " $2 " bugfix"}' > ${output}/train.sh
./tools/list_unreleased_changes.sh --ignore-all stable/train \
    $(.tox/venv/bin/list-deliverables --team oslo -r --series train) > ${output}/train.tmp
awk 'NF' ${output}/train.tmp > ${output}/train.tmp2
sed -i -e 's/^/#-# /' ${output}/train.tmp2
cat ${output}/train.tmp2 >> ${output}/train
#########################################
# stein
#########################################
.tox/venv/bin/list-deliverables --team oslo -r --series stein | awk -F "/" '{print "# tools/new_release.sh train " $2 " bugfix"}' > ${output}/stein.sh
./tools/list_unreleased_changes.sh --ignore-all stable/stein \
    $(.tox/venv/bin/list-deliverables --team oslo -r --series stein) > ${output}/stein.tmp
awk 'NF' ${output}/stein.tmp > ${output}/stein.tmp2
sed -i -e 's/^/#-# /' ${output}/stein.tmp2
cat ${output}/stein.tmp2 >> ${output}/stein

#########################################
# cleaning
#########################################
rm ${output}/*.tmp*

#########################################
# reporting
#########################################
cd ${current}
git add ${output}
git commit -m "[report] Oslo releases report $(date)"
git push
