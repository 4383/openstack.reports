cd_oslo
cd releases
if [ -d openstack.reports ]; then
    rm -rf openstack.reports
fi
git clone git@github.com:4383/openstack.reports
cd_releses
sh ~/dev/redhat/upstream/openstack/oslo/releases/openstack.reports/reports/releases/oslo/2023-04-07-06-04-1680840001/master.sh
sh ~/dev/redhat/upstream/openstack/oslo/releases/openstack.reports/reports/releases/oslo/2023-04-07-06-04-1680840001/zed.sh
sh ~/dev/redhat/upstream/openstack/oslo/releases/openstack.reports/reports/releases/oslo/2023-04-07-06-04-1680840001/yoga.sh
sh ~/dev/redhat/upstream/openstack/oslo/releases/openstack.reports/reports/releases/oslo/2023-04-07-06-04-1680840001/xena.sh
sh ~/dev/redhat/upstream/openstack/oslo/releases/openstack.reports/reports/releases/oslo/2023-04-07-06-04-1680840001/wallaby.sh
sh ~/dev/redhat/upstream/openstack/oslo/releases/openstack.reports/reports/releases/oslo/2023-04-07-06-04-1680840001/independent.sh
