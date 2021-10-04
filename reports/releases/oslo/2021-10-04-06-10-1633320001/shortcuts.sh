cd_oslo
cd releases
if [ -d openstack.reports ]; then
    rm -rf openstack.reports
fi
git clone git@github.com:4383/openstack.reports
cd_releses
sh ~/dev/redhat/upstream/openstack/oslo/releases/openstack.reports/reports/releases/oslo/2021-10-04-06-10-1633320001/master.sh
sh ~/dev/redhat/upstream/openstack/oslo/releases/openstack.reports/reports/releases/oslo/2021-10-04-06-10-1633320001/wallaby.sh
sh ~/dev/redhat/upstream/openstack/oslo/releases/openstack.reports/reports/releases/oslo/2021-10-04-06-10-1633320001/victoria.sh
sh ~/dev/redhat/upstream/openstack/oslo/releases/openstack.reports/reports/releases/oslo/2021-10-04-06-10-1633320001/ussuri.sh
sh ~/dev/redhat/upstream/openstack/oslo/releases/openstack.reports/reports/releases/oslo/2021-10-04-06-10-1633320001/independent.sh
