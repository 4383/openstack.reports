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
sh ~/dev/redhat/upstream/openstack/oslo/releases/openstack.reports/${report_path}/xena.sh
sh ~/dev/redhat/upstream/openstack/oslo/releases/openstack.reports/${report_path}/wallaby.sh
sh ~/dev/redhat/upstream/openstack/oslo/releases/openstack.reports/${report_path}/victoria.sh
sh ~/dev/redhat/upstream/openstack/oslo/releases/openstack.reports/${report_path}/ussuri.sh
sh ~/dev/redhat/upstream/openstack/oslo/releases/openstack.reports/${report_path}/independent.sh
EOF

#########################################
# master (Xena)
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
# xena
#########################################
.tox/venv/bin/list-deliverables --team oslo -r --series xena | awk -F "/" '{print "# tools/new_release.sh xena " $2 " bugfix"}' > ${output}/xena.sh
./tools/list_unreleased_changes.sh --ignore-all stable/xena \
    $(.tox/venv/bin/list-deliverables --team oslo -r --series xena) > ${output}/xena.tmp
awk 'NF' ${output}/xena.tmp > ${output}/xena.tmp2
sed -i -e 's/^/#-# /' ${output}/xena.tmp2
cat ${output}/xena.tmp2 >> ${output}/xena
#########################################
# wallaby
#########################################
.tox/venv/bin/list-deliverables --team oslo -r --series wallaby | awk -F "/" '{print "# tools/new_release.sh wallaby " $2 " bugfix"}' > ${output}/wallaby.sh
./tools/list_unreleased_changes.sh --ignore-all stable/wallaby \
    $(.tox/venv/bin/list-deliverables --team oslo -r --series wallaby) > ${output}/wallaby.tmp
awk 'NF' ${output}/wallaby.tmp > ${output}/wallaby.tmp2
sed -i -e 's/^/#-# /' ${output}/wallaby.tmp2
cat ${output}/wallaby.tmp2 >> ${output}/wallaby
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
