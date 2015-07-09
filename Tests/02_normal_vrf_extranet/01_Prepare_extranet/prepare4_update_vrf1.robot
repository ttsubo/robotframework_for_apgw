*** Settings ***
Resource          Resources/get_token.robot
Resource          Resources/update_vrf.robot
Resource          Resources/action_ping.robot
Library           Lib.conversions
Library           Lib/RequestsLibrary.py
Library           Lib/Common.py
Library           RequestsLibrary
Library           Collections
Suite Setup       Get Token

*** Variables ***
${nw_user_id}                 V06010001
${extranet_user_id}           V06010002
${test_user_id}               V06010002
${expected_status}            active
${ipv4_vfw1}                  30.2.0.4
${ipv4_vfw2}                  30.2.0.5
${expected_result}            5 packets transmitted, 5 received, 0% packet loss

*** TestCases ***
(4-1) Update Vrf(V06010001) Extranets
    ${extranets}=  Create List  ${extranet_user_id}
    ${vrf}=  Create Dictionary  extranets=${extranets}
    Update Vrf Extranets  ${VRF_UUIDS['${nw_user_id}']}
                                  ...  ${vrf}

(4-2) Check Status of Update_Vrf for extranet
    Wait Until Keyword Succeeds  30s  10s
    ...  Check Status Update_Vrf
    ...  ${VRF_UUIDS['${nw_user_id}']}
    ...  ${expected_status}

(4-3) Check Connectivity From GateSW to vFirewall(Primary) for extranet
    Wait Until Keyword Succeeds  60s  10s
    ...  Check Connectivity
    ...  ${VRF_UUIDS['${nw_user_id}']}
    ...  ${ipv4_vfw1}
    ...  ${expected_result}

(4-4) Check Connectivity From GateSW to vFirewall(Secondary) for extranet
    Wait Until Keyword Succeeds  60s  10s
    ...  Check Connectivity
    ...  ${VRF_UUIDS['${nw_user_id}']}
    ...  ${ipv4_vfw2}
    ...  ${expected_result}
