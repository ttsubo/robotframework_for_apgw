** Settings ***
Resource          Resources/create_route.robot
Resource          Resources/action_ping.robot
Resource          Resources/get_event.robot
Library           Lib.conversions
Library           Lib/RequestsLibrary.py
Library           Lib/Common.py
Library           RequestsLibrary
Library           Collections

*** Variables ***
${nw_user_id}                 V06010002
${prefix}                     40.2.1.0/24
${nexthop}                    30.2.0.4
${local_vm}                   40.2.1.1
${expected_status}            active
${expected_result}            5 packets transmitted, 5 received, 0% packet loss
${expected_value}             OK
${TestServer}                 10.79.5.199


*** TestCases ***
(3-1) Create Route(40.2.1.0/24) in Vrf(V06010002)
    ${route}=  Create Dictionary  prefix=${prefix} 
                                  ...  nexthop=${nexthop}
    ${route_id}=  Create Route  ${VRF_UUIDS['${nw_user_id}']}  ${route}
    Set To Dictionary  ${ROUTE_UUIDS}  ${prefix}  ${route_id}
    LOG  ${ROUTE_UUIDS}
    Set Global Variable  ${ROUTE_UUIDS}

(3-2) Check Status of Create_Route
    Wait Until Keyword Succeeds  30s  10s
    ...  Check Status Create_Route
    ...  ${VRF_UUIDS['${nw_user_id}']}
    ...  ${ROUTE_UUIDS['${prefix}']}
    ...  ${expected_status}

(3-3) Check Connectivity From GateSW to Local_vm
    Wait Until Keyword Succeeds  60s  10s
    ...  Check Connectivity
    ...  ${VRF_UUIDS['${nw_user_id}']}
    ...  ${local_vm}
    ...  ${expected_result}

(3-4) Check Connectivity From remotePrefix to vFirewall
    Sleep  30 seconds
    ${result}=  Get Event  ${TestServer}
    Sleep  10 seconds
    Should Be Equal As Strings  ${result}  ${expected_value}
