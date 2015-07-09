*** Settings ***
Resource          Resources/delete_vrf.robot
Library           Lib.conversions
Library           Lib/RequestsLibrary.py
Library           Lib/Common.py
Library           RequestsLibrary
Library           Collections

*** Variables ***
${nw_user_id}                 V06010002

*** TestCases ***
(8-1) Delete Vrf
    Delete Vrf  ${VRF_UUIDS['${nw_user_id}']}

(8-2) Check Status of Delete_Vrf
    Wait Until Keyword Succeeds  30s  10s
    ...  Check Status Delete_Vrf
    ...  ${VRF_UUIDS['${nw_user_id}']}
