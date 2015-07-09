*** Settings ***
Resource          Resources/create_vrf.robot
Resource          Resources/create_interface.robot
Resource          Resources/create_route.robot
Resource          Resources/action_ping.robot
Resource          Resources/update_vrf.robot
Resource          Resources/get_event.robot
Library           Lib.conversions
Library           Lib/RequestsLibrary.py
Library           Lib/Common.py
Library           RequestsLibrary
Library           Collections

*** Variables ***
${nw_user_id}         V06010001
${gatesw_cluster_2}   e8824ffd-79e7-462f-a11d-7ef8cb80d638
${expected_status}    active
${test_num}           TestCase12_in_vrf

${if_name}                    SA061100011
${vlan}                       2001
${ipv4_gatesw_active}         30.1.0.1/24
${ipv4_gatesw_primary}        30.1.0.2
${ipv4_gatesw_secondary}      30.1.0.3
${ipv4_vfw1}                  30.1.0.4
${ipv4_vfw2}                  30.1.0.5
${service_type}               guarantee
${remotePrefix}               192.168.200.1
${expected_status}            active
${expected_result}            5 packets transmitted, 5 received, 0% packet loss
${expected_value}             OK
${TestServer}                 10.79.5.199
${test_num_vlan}              TestCase12_in_vlan
${test_num_previous}          TestCase12_in_vrf

${prefix}                     40.1.1.0/24
${nexthop}                    30.1.0.4
${local_vm}                   40.1.1.1
${test_num_route}             TestCase12_in_route

${extranet_user_id}           V06010002
${expected_status}            active
${ipv4_vfw1_extra}            30.2.0.4
${ipv4_vfw2_extra}            30.2.0.5

*** TestCases ***
(12-1) Create Vrf(V06010001) in GateSW#2
    ${vrf}=  Create Dictionary   name=${nw_user_id}
             ...                 nw_user_id=${nw_user_id}
             ...                 gatesw_cluster=${gatesw_cluster_2}
    ${vpn_id}=  Create Vrf  ${vrf}
    Set To Dictionary  ${VRF_UUIDS}  ${test_num}  ${vpn_id}
    LOG  ${VRF_UUIDS}
    Set Global Variable  ${VRF_UUIDS}

(12-2) Check Status of Create_Vrf
    Wait Until Keyword Succeeds  30s  10s
    ...  Check Status Create_Vrf
    ...  ${VRF_UUIDS['${nw_user_id}']}
    ...  ${expected_status}

(12-3) Create Interface(30.1.0.1/24) in VLAN(2001) in Vrf(V06010001)
    ${ipv4_gatesw_reserve}=  Create List  ${ipv4_gatesw_primary}
                                           ...  ${ipv4_gatesw_secondary}
    ${ipv4_connected}=  Create List  ${ipv4_vfw1}
                                     ...  ${ipv4_vfw2}
    ${vlan}=  Convert To Integer  ${vlan}
    ${bandwidth}=  Create Dictionary  cir=${200000}
                                      ...  pir=${200000}
                                      ...  cbs=${300000}
                                      ...  pbs=${300000}
    ${interface}=  Create Dictionary  name=${if_name}
                                ...  segmentation_id=${vlan}
                                ...  bandwidth=${bandwidth}
                                ...  ipv4_address_active=${ipv4_gatesw_active}
                                ...  ipv4_address_reserve=${ipv4_gatesw_reserve}
                                ...  ipv4_connected_addresses=${ipv4_connected}
                                ...  service_type=${service_type}
    ${interface_id}=  Create Interface  ${VRF_UUIDS['${test_num_previous}']}
                      ...  ${interface}
    Set To Dictionary  ${INF_UUIDS}  ${test_num_vlan}  ${interface_id}
    LOG  ${INF_UUIDS}
    Set Global Variable  ${INF_UUIDS}

(12-4) Check Status of Create_Interface
    Wait Until Keyword Succeeds  30s  10s
    ...  Check Status Create_Interface
    ...  ${VRF_UUIDS['${test_num_previous}']}
    ...  ${INF_UUIDS['${test_num_vlan}']}
    ...  ${expected_status}

(12-5) Check Connectivity From GateSW to vFirewall(Primary)
    Wait Until Keyword Succeeds  60s  10s
    ...  Check Connectivity
    ...  ${VRF_UUIDS['${test_num_previous}']}
    ...  ${ipv4_vfw1}
    ...  ${expected_result}

(12-6) Check Connectivity From GateSW to vFirewall(Secondary)
    Wait Until Keyword Succeeds  60s  10s
    ...  Check Connectivity
    ...  ${VRF_UUIDS['${test_num_previous}']}
    ...  ${ipv4_vfw2}
    ...  ${expected_result}

(12-7) Check Connectivity From GateSW to remotePrefix(192.168.200.1)
    Wait Until Keyword Succeeds  60s  10s
    ...  Check Connectivity
    ...  ${VRF_UUIDS['${test_num_previous}']}
    ...  ${remotePrefix}
    ...  ${expected_result}

(12-8) Create Route(40.1.1.0/24) in Vrf(V06010001)
    ${route}=  Create Dictionary  prefix=${prefix}
                                  ...  nexthop=${nexthop}
    ${route_id}=  Create Route  ${VRF_UUIDS['${test_num_previous}']}  ${route}
    Set To Dictionary  ${ROUTE_UUIDS}  ${test_num_route}  ${route_id}
    LOG  ${ROUTE_UUIDS}
    Set Global Variable  ${ROUTE_UUIDS}

(12-9) Check Status of Create_Route
    Wait Until Keyword Succeeds  30s  10s
    ...  Check Status Create_Route
    ...  ${VRF_UUIDS['${test_num_previous}']}
    ...  ${ROUTE_UUIDS['${test_num_route}']}
    ...  ${expected_status}

(12-10) Check Connectivity From GateSW to Local_vm(40.1.1.1)
    Wait Until Keyword Succeeds  60s  10s
    ...  Check Connectivity
    ...  ${VRF_UUIDS['${test_num_previous}']}
    ...  ${local_vm}
    ...  ${expected_result}

(12-11) Update Vrf(V06010001) Extranets
    ${extranets}=  Create List  ${extranet_user_id}
    ${vrf}=  Create Dictionary  extranets=${extranets}
    Update Vrf Extranets  ${VRF_UUIDS['${nw_user_id}']}
                                  ...  ${vrf}

(12-12) Check Status of Update_Vrf for extranet
    Wait Until Keyword Succeeds  30s  10s
    ...  Check Status Update_Vrf
    ...  ${VRF_UUIDS['${nw_user_id}']}
    ...  ${expected_status}

(12-13) Check Connectivity From GateSW to vFirewall(Primary) for extranet
    Wait Until Keyword Succeeds  60s  10s
    ...  Check Connectivity
    ...  ${VRF_UUIDS['${nw_user_id}']}
    ...  ${ipv4_vfw1_extra}
    ...  ${expected_result}

(12-14) Check Connectivity From GateSW to vFirewall(Secondary) for extranet
    Wait Until Keyword Succeeds  60s  10s
    ...  Check Connectivity
    ...  ${VRF_UUIDS['${nw_user_id}']}
    ...  ${ipv4_vfw2_extra}
    ...  ${expected_result}
