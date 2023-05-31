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
sh ~/dev/redhat/upstream/openstack/oslo/releases/openstack.reports/${report_path}/antelope.sh
sh ~/dev/redhat/upstream/openstack/oslo/releases/openstack.reports/${report_path}/zed.sh
sh ~/dev/redhat/upstream/openstack/oslo/releases/openstack.reports/${report_path}/yoga.sh
sh ~/dev/redhat/upstream/openstack/oslo/releases/openstack.reports/${report_path}/wallaby.sh
sh ~/dev/redhat/upstream/openstack/oslo/releases/openstack.reports/${report_path}/independent.sh
EOF

#########################################
# master (bobcat)
#########################################
.tox/venv/bin/list-deliverables --team oslo -r | awk -F "/" '{print "# tools/new_release.sh zed $2 " bugfix"}' > ${output}/master.sh
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
# antelope
#########################################
.tox/venv/bin/list-deliverables --team oslo -r --series antelope | awk -F "/" '{print "# tools/new_release.sh antelope " $2 " bugfix"}' > ${output}/antelope.sh
./tools/list_unreleased_changes.sh --ignore-all stable/2023.1 \
    $(.tox/venv/bin/list-deliverables --team oslo -r --series antelope) > ${output}/antelope.tmp
awk 'NF' ${output}/antelope.tmp > ${output}/antelope.tmp2
sed -i -e 's/^/#-# /' ${output}/antelope.tmp2
cat ${output}/antelope.tmp2 >> ${output}/antelope
#########################################
# zed
#########################################
.tox/venv/bin/list-deliverables --team oslo -r | awk -F "/" '{print "# tools/new_release.sh zed $2 " bugfix"}' > ${output}/zed.sh
tox -e venv --notest
./tools/list_unreleased_changes.sh --ignore-all stable/zed \
    $(.tox/venv/bin/list-deliverables --team oslo -r) > ${output}/zed.tmp
awk 'NF' ${output}/zed.tmp > ${output}/zed.tmp2
sed -i -e 's/^/#-# /' ${output}/zed.tmp2
cat ${output}/zed.tmp2 >> ${output}/zed
#########################################
# yoga
#########################################
.tox/venv/bin/list-deliverables --team oslo -r --series yoga | awk -F "/" '{print "# tools/new_release.sh yoga " $2 " bugfix"}' > ${output}/yoga.sh
./tools/list_unreleased_changes.sh --ignore-all stable/yoga \
    $(.tox/venv/bin/list-deliverables --team oslo -r --series yoga) > ${output}/yoga.tmp
awk 'NF' ${output}/yoga.tmp > ${output}/yoga.tmp2
sed -i -e 's/^/#-# /' ${output}/yoga.tmp2
cat ${output}/yoga.tmp2 >> ${output}/yoga
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
