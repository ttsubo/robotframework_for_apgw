*** Settings ***
Resource          Resources/delete_interface.robot
Resource          Resources/action_ping.robot
Library           Lib.conversions
Library           Lib/RequestsLibrary.py
Library           Lib/Common.py
Library           RequestsLibrary
Library           Collections

*** Variables ***
${nw_user_id}                 V06010002
${name}                       SA061100020
${ipv4_gatesw_active}         30.2.0.1/24
${ipv4_gatesw_primary}        30.2.0.2
${ipv4_gatesw_secondary}      30.2.0.3
${ipv4_vfw1}                  30.2.0.4
${ipv4_vfw2}                  30.2.0.5
${expected_result_vfw1}       No Route to 30.2.0.4
${expected_result_vfw2}       No Route to 30.2.0.5

*** TestCases ***
(8-1) Delete Interface
    Delete Interface  ${VRF_UUIDS['${nw_user_id}']}  ${INF_UUIDS['${name}']}

(8-2) Check Status of Delete_Interface
    Wait Until Keyword Succeeds  30s  10s
    ...  Check Status Delete_Interface
    ...  ${VRF_UUIDS['${nw_user_id}']}
    ...  ${INF_UUIDS['${name}']}

(8-3) Check Connectivity From GateSW to vFirewall(Primary)
    Wait Until Keyword Succeeds  60s  10s
    ...  Check Connectivity
    ...  ${VRF_UUIDS['${nw_user_id}']}
    ...  ${ipv4_vfw1}
    ...  ${expected_result_vfw1}

(8-4) Check Connectivity From GateSW to vFirewall(Secondary)
    Wait Until Keyword Succeeds  60s  10s
    ...  Check Connectivity
    ...  ${VRF_UUIDS['${nw_user_id}']}
    ...  ${ipv4_vfw2}
    ...  ${expected_result_vfw2}
