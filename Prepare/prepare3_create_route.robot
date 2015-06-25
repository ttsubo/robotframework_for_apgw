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
${nw_user_id}                 V06010001
${prefix}                     40.1.1.0/24
${nexthop}                    30.1.0.4
${local_vm}                   40.1.1.1
${expected_status}            active
${expected_result}            5 packets transmitted, 5 received, 0% packet loss
${expected_value}             OK


*** TestCases ***
(3-1) Create Route
    ${ROUTE_UUIDS}=  Create Dictionary
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
