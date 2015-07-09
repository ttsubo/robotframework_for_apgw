What's Robot Framework for openstack
==========
Sample Test Case for OpenStack w/ Robot Framework

Installation
==========
You need to deploy test environment
- install apgw
- install simpleRouter
- install test server


Quick Start
===========
You can start sample TestCases as bellow

        $ pybot --variable APGW_PLUGIN:10.79.5.177 Tests/01_normal_vrf_regular
        $ pybot --variable APGW_PLUGIN:10.79.5.177 Tests/02_normal_vrf_extranet
        $ pybot -v APGW_PLUGIN:10.79.5.177 -v gateswitch1:10.128.141.15 Tests/03_failure_wan_port
