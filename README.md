# populate-nagios-from-zookeeper
Create Dynamic checks in Nagios from zookeeper output

Example output-txt provided, this is very custom where you have lots of internal services that need monitoring. 
Convert each of the Service Types into a check / hostgroup

--needs to be more dynamic, iterate through live zookeeper node and dynamically get the services rather than specifying them.
