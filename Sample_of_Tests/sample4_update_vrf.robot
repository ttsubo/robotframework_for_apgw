*** Settings ***
Resource          Resources/update_vrf.robot
Resource          Resources/action_ping.robot
Library           Lib.conversions
Library           Lib/RequestsLibrary.py
Library           Lib/Common.py
Library           RequestsLibrary
Library           Collections

*** Variables ***
${nw_user_id}                 V06010002
${extranet_user_id}           V06010001
${name}                       SA061100020
${expected_status}            active
${ipv4_vfw1}                  30.1.0.4
${ipv4_vfw2}                  30.1.0.5
${remotePrefix}               192.168.200.1
${expected_result}            5 packets transmitted, 5 received, 0% packet loss

*** TestCases ***
(4-1) Update Vrf Extranets
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

(4-5) Check Connectivity From GateSW to remotePrefix for extranet
    Wait Until Keyword Succeeds  60s  10s
    ...  Check Connectivity
    ...  ${VRF_UUIDS['${nw_user_id}']}
    ...  ${remotePrefix}
    ...  ${expected_result}
