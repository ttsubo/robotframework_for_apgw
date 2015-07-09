*** Settings ***
Resource          Resources/start_ryubgp.robot

*** Variables ***
${RyuBGP}                10.79.5.198
${as_number}             65030
${router_id}             10.10.10.1
${label_range_start}     300
${label_range_end}       399

${port1}                 1
${macaddress1}           2a:12:c8:ba:b3:37
${ipaddress1}            192.168.103.1
${netmask1}              255.255.255.252
${opposite_ipaddress1}   192.168.103.2
${opposite_asnumber1}    9598
${port_offload_bgp1}     3
${bgp_med1}              100

${port2}                 2
${macaddress2}           00:00:00:00:00:01
${ipaddress2}            192.168.104.2
${netmask2}              255.255.255.0
${opposite_ipaddress2}   192.168.104.1
${vrf_routeDist2}        9598:1006010002

${redistribute_on}       ON
${destination}           192.168.204.0
${netmask}               255.255.255.0
${nexthop}               192.168.104.1

${TestServer}            10.79.5.199
${port}                  11019


*** TestCases ***
(0-1) Start RyuBGPSpeaker
    ${bgp}=  Create Dictionary   as_number=${as_number}
             ...                 router_id=${router_id}
             ...                 label_range_start=${label_range_start}
             ...                 label_range_end=${label_range_end}
    Start BGPSpeaker  ${RyuBGP}  ${bgp}

(0-2) Create Interfacer (for WAN-IF)
    Sleep  15 seconds
    ${interface}=  Create Dictionary   port=${port1}
                   ...                 macaddress=${macaddress1}
                   ...                 ipaddress=${ipaddress1}
                   ...                 netmask=${netmask1}
                   ...                 opposite_ipaddress=${opposite_ipaddress1}
                   ...                 opposite_asnumber=${opposite_asnumber1}
                   ...                 port_offload_bgp=${port_offload_bgp1}
                   ...                 bgp_med=${bgp_med1}
                   ...                 bgp_local_pref=
                   ...                 bgp_filter_asnumber=
                   ...                 vrf_routeDist=
    Create Interface  ${RyuBGP}  ${interface}

(0-3) Create Interfacer (for LAN-IF)
    ${interface}=  Create Dictionary   port=${port2}
                   ...                 macaddress=${macaddress2}
                   ...                 ipaddress=${ipaddress2}
                   ...                 netmask=${netmask2}
                   ...                 opposite_ipaddress=${opposite_ipaddress2}
                   ...                 opposite_asnumber=
                   ...                 port_offload_bgp=
                   ...                 bgp_med=
                   ...                 bgp_local_pref=
                   ...                 bgp_filter_asnumber=
                   ...                 vrf_routeDist=${vrf_routeDist2}
    Create Interface  ${RyuBGP}  ${interface}

(0-4) Create Vrf
    Sleep  10 seconds
    ${vrf}=  Create Dictionary   route_dist=${vrf_routeDist2}
             ...                 import=${vrf_routeDist2}
             ...                 export=${vrf_routeDist2}
    Create Vrf  ${RyuBGP}  ${vrf}

(0-5) Set Redistribute On
    Sleep  10 seconds
    ${bgp}=  Create Dictionary   redistribute=${redistribute_on}
             ...                 vrf_routeDist=${vrf_routeDist2}
             ...                 export=${vrf_routeDist2}
    Set Redistribute On  ${RyuBGP}  ${bgp}

(0-6) Set Static Routing
    Sleep  10 seconds
    ${route}=  Create Dictionary   destination=${destination}
               ...                 netmask=${netmask}
               ...                 nexthop=${nexthop}
               ...                 vrf_routeDist=${vrf_routeDist2}
    Set Static Routing  ${RyuBGP}  ${route}

(0-7) Start Bmp
    Sleep  10 seconds
    ${bmp}=  Create Dictionary   address=${TestServer}
             ...                 port=${port}
    Start Bmp  ${RyuBGP}  ${bmp}

