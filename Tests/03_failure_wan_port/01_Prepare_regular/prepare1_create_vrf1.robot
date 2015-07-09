*** Settings ***
Resource          Resources/get_token.robot
Resource          Resources/create_vrf.robot
Library           Lib.conversions
Library           Lib/RequestsLibrary.py
Library           Lib/Common.py
Library           RequestsLibrary
Library           Collections
Suite Setup       Get Token

*** Variables ***
${nw_user_id}         V06010001
${gatesw_cluster_1}   cb806e16-46f7-4a05-86b9-c9d0967fc910
${expected_status}    active

*** TestCases ***
(1-1) Create Vrf(V06010001) in GateSW#1
    ${VRF_UUIDS}=  Create Dictionary
    ${vrf}=  Create Dictionary   name=${nw_user_id}
             ...                 nw_user_id=${nw_user_id}
             ...                 gatesw_cluster=${gatesw_cluster_1}
    ${vpn_id}=  Create Vrf  ${vrf}
    Set To Dictionary  ${VRF_UUIDS}  ${nw_user_id}  ${vpn_id}
    LOG  ${VRF_UUIDS}
    Set Global Variable  ${VRF_UUIDS}

(1-2) Check Status of Create_Vrf
    Wait Until Keyword Succeeds  30s  10s
    ...  Check Status Create_Vrf
    ...  ${VRF_UUIDS['${nw_user_id}']}
    ...  ${expected_status}
