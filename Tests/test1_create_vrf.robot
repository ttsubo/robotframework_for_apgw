*** Settings ***
Resource          Resources/create_vrf.robot
Library           Lib.conversions
Library           Lib/RequestsLibrary.py
Library           Lib/Common.py
Library           RequestsLibrary
Library           Collections

*** Variables ***
${name}               V06010002
${nw_user_id}         V06010002
${gatesw_cluster}     289e97e0-cf14-458a-880d-369ea8e4c6cb
${expected_status}    active

*** TestCases ***
(1-1) Create Vrf
    ${VRF_UUIDS}=  Create Dictionary
    ${vrf}=  Create Dictionary   name=${name}
             ...                 nw_user_id=${nw_user_id}
             ...                 gatesw_cluster=${gatesw_cluster}
    ${vpn_id}=  Create Vrf  ${vrf}
    Set To Dictionary  ${VRF_UUIDS}  ${name}  ${vpn_id}
    LOG  ${VRF_UUIDS}
    Set Global Variable  ${VRF_UUIDS}

(1-2) Check Status of Create_Vrf
    Wait Until Keyword Succeeds  30s  10s
    ...  Check Status Create_Vrf
    ...  ${VRF_UUIDS['${nw_user_id}']}
    ...  ${expected_status}
