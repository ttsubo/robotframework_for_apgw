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
${nw_user_id}         V06010002
${gatesw_cluster_1}   cb806e16-46f7-4a05-86b9-c9d0967fc910
${expected_status}    error

*** TestCases ***
(1-1) Create Vrf(V06010002) in GateSW#1 => Error
    ${vrf}=  Create Dictionary   name=${nw_user_id}
             ...                 nw_user_id=${nw_user_id}
             ...                 gatesw_cluster=${gatesw_cluster_1}
    Create Vrf Error  ${vrf}
