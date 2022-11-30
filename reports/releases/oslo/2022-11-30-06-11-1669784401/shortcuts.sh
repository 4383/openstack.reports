cd_oslo
cd releases
if [ -d openstack.reports ]; then
    rm -rf openstack.reports
fi
git clone git@github.com:4383/openstack.reports
cd_releses
sh ~/dev/redhat/upstream/openstack/oslo/releases/openstack.reports/reports/releases/oslo/2022-11-30-06-11-1669784401/master.sh
sh ~/dev/redhat/upstream/openstack/oslo/releases/openstack.reports/reports/releases/oslo/2022-11-30-06-11-1669784401/zed.sh
sh ~/dev/redhat/upstream/openstack/oslo/releases/openstack.reports/reports/releases/oslo/2022-11-30-06-11-1669784401/yoga.sh
sh ~/dev/redhat/upstream/openstack/oslo/releases/openstack.reports/reports/releases/oslo/2022-11-30-06-11-1669784401/xena.sh
sh ~/dev/redhat/upstream/openstack/oslo/releases/openstack.reports/reports/releases/oslo/2022-11-30-06-11-1669784401/wallaby.sh
sh ~/dev/redhat/upstream/openstack/oslo/releases/openstack.reports/reports/releases/oslo/2022-11-30-06-11-1669784401/independent.sh
