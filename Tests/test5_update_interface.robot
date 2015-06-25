*** Settings ***
Resource          Resources/update_interface.robot
Resource          Resources/action_ping.robot
Library           Lib.conversions
Library           Lib/RequestsLibrary.py
Library           Lib/Common.py
Library           RequestsLibrary
Library           Collections

*** Variables ***
${nw_user_id}                 V06010002
${name}                       SA061100020
${expected_status}            active
${change_service_type}        best_effort
${ipv4_vfw1}                  30.2.0.4
${ipv4_vfw2}                  30.2.0.5
${remotePrefix}               192.168.204.1
${expected_result}            5 packets transmitted, 5 received, 0% packet loss

*** TestCases ***
(5-1) Update Interface ServiceType
    ${bandwidth}=  Create Dictionary  cir=${200000}
                                      ...  pir=${200000}
                                      ...  cbs=${300000}
                                      ...  pbs=${300000}
    ${interface}=  Create Dictionary  service_type=${change_service_type}
                                      ...  bandwidth=${bandwidth}
    Update Interface ServiceType  ${VRF_UUIDS['${nw_user_id}']}
                                  ...  ${INF_UUIDS['${name}']}
                                  ...  ${interface}

(5-2) Check Status of Update_Interface
    Wait Until Keyword Succeeds  30s  10s
    ...  Check Status Update_Interface
    ...  ${VRF_UUIDS['${nw_user_id}']}
    ...  ${INF_UUIDS['${name}']}
    ...  ${expected_status}

(5-3) Check Connectivity From GateSW to vFirewall(Primary)
    Wait Until Keyword Succeeds  60s  10s
    ...  Check Connectivity
    ...  ${VRF_UUIDS['${nw_user_id}']}
    ...  ${ipv4_vfw1}
    ...  ${expected_result}

(5-4) Check Connectivity From GateSW to vFirewall(Secondary)
    Wait Until Keyword Succeeds  60s  10s
    ...  Check Connectivity
    ...  ${VRF_UUIDS['${nw_user_id}']}
    ...  ${ipv4_vfw2}
    ...  ${expected_result}

(5-5) Check Connectivity From GateSW to remotePrefix
    Wait Until Keyword Succeeds  60s  10s
    ...  Check Connectivity
    ...  ${VRF_UUIDS['${nw_user_id}']}
    ...  ${remotePrefix}
    ...  ${expected_result}
