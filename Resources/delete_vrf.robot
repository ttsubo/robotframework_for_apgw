*** settings ***
Resource          get_token.robot
Library           Lib.conversions
Library           Lib/RequestsLibrary.py
Library           Lib/Common.py
Library           RequestsLibrary
Library           Collections


*** Keywords ***
Delete Vrf
    [Arguments]  ${vpn_id}
    Create Session  Plugin  http://${APGW_PLUGIN}:9696  headers=${X-AUTH}
    ${result} =  Delete  Plugin  /v2.0/apgw/vrfs/${vpn_id}
    Log     ${result.status_code}
    Log     ${result.json()['vrf']}
    Should Be Equal As Strings  ${result.status_code}  202

Get non_Vrf
    [Arguments]  ${vpn_id}
    Create Session  Plugin  http://${APGW_PLUGIN}:9696  headers=${X-AUTH}
    ${result} =  Get  Plugin  /v2.0/apgw/vrfs/${vpn_id}
    Log     ${result.status_code}
    [return]  ${result.status_code}

Check Status Delete_Vrf
    [Arguments]  ${vpn_id} 
    ${result}=  Get non_Vrf  ${vpn_id}
    Should Be Equal As Strings  ${result}  404
