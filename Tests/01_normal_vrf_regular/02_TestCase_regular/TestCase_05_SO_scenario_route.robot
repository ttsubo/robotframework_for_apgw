*** Settings ***
Resource          Resources/create_route.robot
Resource          Resources/action_ping.robot
Resource          Resources/get_event.robot
Library           Lib.conversions
Library           Lib/RequestsLibrary.py
Library           Lib/Common.py
Library           RequestsLibrary
Library           Collections

*** Variables ***
${test_user_id}               V06010002
${prefix}                     40.2.1.0/24
${nexthop}                    30.2.0.4
${local_vm}                   40.2.1.1
${expected_status}            active
${expected_result}            5 packets transmitted, 5 received, 0% packet loss
${expected_value}             OK
${TestServer}                 10.79.5.199
${test_num}                   TestCase5_in_route
${test_num_previous}          TestCase2_in_vrf

*** TestCases ***
(5-1) Create Route(40.2.1.0/24) in Vrf(V06010002)
    ${route}=  Create Dictionary  prefix=${prefix}
                                  ...  nexthop=${nexthop}
    ${route_id}=  Create Route  ${VRF_UUIDS['${test_num_previous}']}  ${route}
    Set To Dictionary  ${ROUTE_UUIDS}  ${test_num}  ${route_id}
    LOG  ${ROUTE_UUIDS}
    Set Global Variable  ${ROUTE_UUIDS}

(5-2) Check Status of Create_Route
    Wait Until Keyword Succeeds  30s  10s
    ...  Check Status Create_Route
    ...  ${VRF_UUIDS['${test_num_previous}']}
    ...  ${ROUTE_UUIDS['${test_num}']}
    ...  ${expected_status}

(5-3) Check Connectivity From GateSW to Local_vm(40.2.1.1)
    Wait Until Keyword Succeeds  60s  10s
    ...  Check Connectivity
    ...  ${VRF_UUIDS['${test_num_previous}']}
    ...  ${local_vm}
    ...  ${expected_result}

(5-4) Check Connectivity From remotePrefix to Local_vm(40.2.1.1)
    Sleep  30 seconds
    ${result}=  Get Event  ${TestServer}
    Sleep  10 seconds
    Should Be Equal As Strings  ${result}  ${expected_value}

