*** Settings ***
Resource          Resources/update_interface.robot
Resource          Resources/action_ping.robot
Resource          Resources/get_event.robot
Library           Lib.conversions
Library           Lib/RequestsLibrary.py
Library           Lib/Common.py
Library           RequestsLibrary
Library           Collections

*** Variables ***
${local_vm}                   40.2.1.1
${expected_status}            active
${change_service_type}        best_effort
${ipv4_vfw1}                  30.2.0.4
${ipv4_vfw2}                  30.2.0.5
${remotePrefix}               192.168.204.1
${expected_result}            5 packets transmitted, 5 received, 0% packet loss
${expected_value}             OK
${TestServer}                 10.79.5.199
${test_num_previous_vlan}     TestCase4_in_vlan
${test_num_previous_vrf}      TestCase2_in_vrf

*** TestCases ***
(16-1) Update Interface ServiceType
    ${bandwidth}=  Create Dictionary  cir=${200000}
                                      ...  pir=${200000}
                                      ...  cbs=${300000}
                                      ...  pbs=${300000}
    ${interface}=  Create Dictionary  service_type=${change_service_type}
                                      ...  bandwidth=${bandwidth}
    Update Interface ServiceType  ${VRF_UUIDS['${test_num_previous_vrf}']}
                                  ...  ${INF_UUIDS['${test_num_previous_vlan}']}
                                  ...  ${interface}

(16-2) Check Status of Update_Interface
    Wait Until Keyword Succeeds  30s  10s
    ...  Check Status Update_Interface
    ...  ${VRF_UUIDS['${test_num_previous_vrf}']}
    ...  ${INF_UUIDS['${test_num_previous_vlan}']}
    ...  ${expected_status}

(16-3) Check Connectivity From GateSW to vFirewall(Primary)
    Wait Until Keyword Succeeds  60s  10s
    ...  Check Connectivity
    ...  ${VRF_UUIDS['${test_num_previous_vrf}']}
    ...  ${ipv4_vfw1}
    ...  ${expected_result}

(16-4) Check Connectivity From GateSW to vFirewall(Secondary)
    Wait Until Keyword Succeeds  60s  10s
    ...  Check Connectivity
    ...  ${VRF_UUIDS['${test_num_previous_vrf}']}
    ...  ${ipv4_vfw2}
    ...  ${expected_result}

(16-5) Check Connectivity From GateSW to remotePrefix
    Wait Until Keyword Succeeds  60s  10s
    ...  Check Connectivity
    ...  ${VRF_UUIDS['${test_num_previous_vrf}']}
    ...  ${remotePrefix}
    ...  ${expected_result}

(16-6) Check Connectivity From GateSW to Local_vm(40.2.1.1)
    Wait Until Keyword Succeeds  60s  10s
    ...  Check Connectivity
    ...  ${VRF_UUIDS['${test_num_previous_vrf}']}
    ...  ${local_vm}
    ...  ${expected_result}

