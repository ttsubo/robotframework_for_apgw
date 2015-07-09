*** Settings ***
Resource          Resources/delete_route.robot
Resource          Resources/delete_interface.robot
Resource          Resources/delete_vrf.robot
Library           Lib.conversions
Library           Lib/RequestsLibrary.py
Library           Lib/Common.py
Library           RequestsLibrary
Library           Collections

*** Variables ***
${nw_user_id1}                V06010001
${nw_user_id2}                V06010002
${nw_user_id3}                TestCase2_in_vrf

${name1}                      SA061100010
${name2}                      SA061100020
${name3}                      TestCase4_in_vlan
${name4}                      TestCase7_in_vlan

${prefix1}                    40.1.1.0/24
${prefix2}                    40.2.1.0/24
${prefix3}                    TestCase5_in_route
${prefix4}                    TestCase8_in_route

*** TestCases ***
(1) Delete Route
    Delete Route  ${VRF_UUIDS['${nw_user_id1}']}  ${ROUTE_UUIDS['${prefix1}']}

(2) Delete Route
    Delete Route  ${VRF_UUIDS['${nw_user_id2}']}  ${ROUTE_UUIDS['${prefix2}']}

(3) Delete Route
    Delete Route  ${VRF_UUIDS['${nw_user_id3}']}  ${ROUTE_UUIDS['${prefix3}']}

(4) Delete Route
    Delete Route  ${VRF_UUIDS['${nw_user_id3}']}  ${ROUTE_UUIDS['${prefix4}']}

(5) Delete Interface
    Delete Interface  ${VRF_UUIDS['${nw_user_id1}']}  ${INF_UUIDS['${name1}']}

(6) Delete Interface
    Delete Interface  ${VRF_UUIDS['${nw_user_id2}']}  ${INF_UUIDS['${name2}']}

(7) Delete Interface
    Delete Interface  ${VRF_UUIDS['${nw_user_id3}']}  ${INF_UUIDS['${name3}']}

(8) Delete Interface
    Delete Interface  ${VRF_UUIDS['${nw_user_id3}']}  ${INF_UUIDS['${name4}']}

(9) Delete Vrf
    Delete Vrf  ${VRF_UUIDS['${nw_user_id1}']}

(10) Delete Vrf
    Delete Vrf  ${VRF_UUIDS['${nw_user_id2}']}

(11) Delete Vrf
    Delete Vrf  ${VRF_UUIDS['${nw_user_id3}']}

