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
sh ~/dev/redhat/upstream/openstack/oslo/releases/openstack.reports/${report_path}/yoga.sh
sh ~/dev/redhat/upstream/openstack/oslo/releases/openstack.reports/${report_path}/xena.sh
sh ~/dev/redhat/upstream/openstack/oslo/releases/openstack.reports/${report_path}/wallaby.sh
sh ~/dev/redhat/upstream/openstack/oslo/releases/openstack.reports/${report_path}/independent.sh
EOF

#########################################
# master (Zed)
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
# yoga
#########################################
.tox/venv/bin/list-deliverables --team oslo -r --series yoga | awk -F "/" '{print "# tools/new_release.sh yoga " $2 " bugfix"}' > ${output}/yoga.sh
./tools/list_unreleased_changes.sh --ignore-all stable/yoga \
    $(.tox/venv/bin/list-deliverables --team oslo -r --series yoga) > ${output}/yoga.tmp
awk 'NF' ${output}/yoga.tmp > ${output}/yoga.tmp2
sed -i -e 's/^/#-# /' ${output}/yoga.tmp2
cat ${output}/yoga.tmp2 >> ${output}/yoga
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
