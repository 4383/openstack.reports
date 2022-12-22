cd_oslo
cd releases
if [ -d openstack.reports ]; then
    rm -rf openstack.reports
fi
git clone git@github.com:4383/openstack.reports
cd_releses
sh ~/dev/redhat/upstream/openstack/oslo/releases/openstack.reports/reports/releases/oslo/2022-12-22-06-12-1671685202/master.sh
sh ~/dev/redhat/upstream/openstack/oslo/releases/openstack.reports/reports/releases/oslo/2022-12-22-06-12-1671685202/zed.sh
sh ~/dev/redhat/upstream/openstack/oslo/releases/openstack.reports/reports/releases/oslo/2022-12-22-06-12-1671685202/yoga.sh
sh ~/dev/redhat/upstream/openstack/oslo/releases/openstack.reports/reports/releases/oslo/2022-12-22-06-12-1671685202/xena.sh
sh ~/dev/redhat/upstream/openstack/oslo/releases/openstack.reports/reports/releases/oslo/2022-12-22-06-12-1671685202/wallaby.sh
sh ~/dev/redhat/upstream/openstack/oslo/releases/openstack.reports/reports/releases/oslo/2022-12-22-06-12-1671685202/independent.sh
