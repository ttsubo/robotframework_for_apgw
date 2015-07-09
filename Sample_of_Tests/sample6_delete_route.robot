*** Settings ***
Resource          Resources/delete_route.robot
Resource          Resources/action_ping.robot
Library           Lib.conversions
Library           Lib/RequestsLibrary.py
Library           Lib/Common.py
Library           RequestsLibrary
Library           Collections

*** Variables ***
${nw_user_id}                 V06010002
${prefix}                     40.2.1.0/24
${local_vm}                   40.2.1.1
${expected_result}            No Route to 40.2.1.1

*** TestCases ***
(6-1) Delete Route
    Delete Route  ${VRF_UUIDS['${nw_user_id}']}  ${ROUTE_UUIDS['${prefix}']}

(6-2) Check Status of Delete_Route
    Wait Until Keyword Succeeds  30s  10s
    ...  Check Status Delete_Route
    ...  ${VRF_UUIDS['${nw_user_id}']}
    ...  ${ROUTE_UUIDS['${prefix}']}

(6-3) Check Connectivity From GateSW to Local_vm
    Wait Until Keyword Succeeds  60s  10s
    ...  Check Connectivity
    ...  ${VRF_UUIDS['${nw_user_id}']}
    ...  ${local_vm}
    ...  ${expected_result}
