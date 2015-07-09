*** Settings ***
Resource          Resources/create_interface.robot
Resource          Resources/action_ping.robot
Resource          Resources/get_event.robot
Resource          Resources/delete_interface.robot
Library           Lib.conversions
Library           Lib/RequestsLibrary.py
Library           Lib/Common.py
Library           RequestsLibrary
Library           Collections

*** Variables ***
${test_user_id}               V06010002
${if_name}                    SA061100021
${vlan}                       2001
${ipv4_gatesw_active}         30.1.0.1/24
${ipv4_gatesw_primary}        30.1.0.2
${ipv4_gatesw_secondary}      30.1.0.3
${ipv4_vfw1}                  30.1.0.4
${ipv4_vfw2}                  30.1.0.5
${service_type}               guarantee
${remotePrefix}               192.168.204.1
${expected_status}            active
${expected_result}            5 packets transmitted, 5 received, 0% packet loss
${expected_value}             OK
${TestServer}                 10.79.5.199
${test_num}                   TestCase3_in_vlan
${test_num_previous}          TestCase2_in_vrf

*** TestCases ***
(3-1) Create Interface(30.1.0.1/24) in VLAN(2001) in Vrf(V06010002)
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
    Set To Dictionary  ${INF_UUIDS}  ${test_num}  ${interface_id}
    LOG  ${INF_UUIDS}
    Set Global Variable  ${INF_UUIDS}

(3-2) Check Status of Create_Interface
    Wait Until Keyword Succeeds  30s  10s
    ...  Check Status Create_Interface
    ...  ${VRF_UUIDS['${test_num_previous}']}
    ...  ${INF_UUIDS['${test_num}']}
    ...  ${expected_status}

(3-3) Check Connectivity From GateSW to vFirewall(Primary)
    Wait Until Keyword Succeeds  60s  10s
    ...  Check Connectivity
    ...  ${VRF_UUIDS['${test_num_previous}']}
    ...  ${ipv4_vfw1}
    ...  ${expected_result}

(3-4) Check Connectivity From GateSW to vFirewall(Secondary)
    Wait Until Keyword Succeeds  60s  10s
    ...  Check Connectivity
    ...  ${VRF_UUIDS['${test_num_previous}']}
    ...  ${ipv4_vfw2}
    ...  ${expected_result}

(3-5) Check Connectivity From GateSW to remotePrefix(192.168.204.1)
    Wait Until Keyword Succeeds  60s  10s
    ...  Check Connectivity
    ...  ${VRF_UUIDS['${test_num_previous}']}
    ...  ${remotePrefix}
    ...  ${expected_result}

(3-6) Check Connectivity From remotePrefix to vFirewall
    Sleep  30 seconds
    ${result}=  Get Event  ${TestServer}
    Sleep  10 seconds
    Should Be Equal As Strings  ${result}  ${expected_value}

(3-7) Delete Interface
    Delete Interface
    ...  ${VRF_UUIDS['${test_num_previous}']}
    ...  ${INF_UUIDS['${test_num}']}

(3-8) Check Status of Delete_Interface
    Wait Until Keyword Succeeds  30s  10s
    ...  Check Status Delete_Interface
    ...  ${VRF_UUIDS['${test_num_previous}']}
    ...  ${INF_UUIDS['${test_num}']}

    # WA: peer down/up in case of receiving BGP UPDATE(withdrawn)
    Sleep  90 seconds
