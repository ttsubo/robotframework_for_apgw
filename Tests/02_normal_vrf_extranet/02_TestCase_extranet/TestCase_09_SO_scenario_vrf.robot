*** Settings ***
Resource          Resources/create_vrf.robot
Library           Lib.conversions
Library           Lib/RequestsLibrary.py
Library           Lib/Common.py
Library           RequestsLibrary
Library           Collections

*** Variables ***
${nw_user_id}         V06010002
${gatesw_cluster_2}   e8824ffd-79e7-462f-a11d-7ef8cb80d638
${expected_status}    active
${test_num}           TestCase9_in_vrf

*** TestCases ***
(9-1) Create Vrf(V06010002) in GateSW#2
    ${vrf}=  Create Dictionary   name=${nw_user_id}
             ...                 nw_user_id=${nw_user_id}
             ...                 gatesw_cluster=${gatesw_cluster_2}
    ${vpn_id}=  Create Vrf  ${vrf}
    Set To Dictionary  ${VRF_UUIDS}  ${test_num}  ${vpn_id}
    LOG  ${VRF_UUIDS}
    Set Global Variable  ${VRF_UUIDS}

(9-2) Check Status of Create_Vrf
    Wait Until Keyword Succeeds  30s  10s
    ...  Check Status Create_Vrf
    ...  ${VRF_UUIDS['${nw_user_id}']}
    ...  ${expected_status}

