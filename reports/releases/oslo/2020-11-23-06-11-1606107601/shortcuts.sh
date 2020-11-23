cd_oslo
cd releases
if [ -d openstack.reports ]; then
    rm -rf openstack.reports
fi
git clone git@github.com:4383/openstack.reports
cd_releses
sh ~/dev/redhat/upstream/openstack/oslo/releases/openstack.reports/reports/releases/oslo/2020-11-23-06-11-1606107601/master.sh
sh ~/dev/redhat/upstream/openstack/oslo/releases/openstack.reports/reports/releases/oslo/2020-11-23-06-11-1606107601/victoria.sh
sh ~/dev/redhat/upstream/openstack/oslo/releases/openstack.reports/reports/releases/oslo/2020-11-23-06-11-1606107601/ussuri.sh
sh ~/dev/redhat/upstream/openstack/oslo/releases/openstack.reports/reports/releases/oslo/2020-11-23-06-11-1606107601/train.sh
sh ~/dev/redhat/upstream/openstack/oslo/releases/openstack.reports/reports/releases/oslo/2020-11-23-06-11-1606107601/stein.sh
sh ~/dev/redhat/upstream/openstack/oslo/releases/openstack.reports/reports/releases/oslo/2020-11-23-06-11-1606107601/independent.sh
