*** settings ***
Resource          get_token.robot
Library           Lib.conversions
Library           Lib/RequestsLibrary.py
Library           Lib/Common.py
Library           RequestsLibrary
Library           Collections


*** Keywords ***
Create Vrf
    [Arguments]  ${vrf} 
    Get Token
    Create Session  Plugin  http://${APGW_PLUGIN}:9696  headers=${X-AUTH}
    ${data}=  Create Dictionary   vrf=${vrf}
    ${data}=  Get Json From Dict  ${data}
    ${result} =  Post  Plugin  /v2.0/apgw/vrfs  ${data}
    Log     ${result.status_code}
    Log     ${result.json()['vrf']}
    Should Be Equal As Strings  ${result.status_code}  202
    [return]  ${result.json()['vrf']['id']}

Get Vrf
    [Arguments]  ${vpn_id}
    Create Session  Plugin  http://${APGW_PLUGIN}:9696  headers=${X-AUTH}
    ${result} =  Get  Plugin  /v2.0/apgw/vrfs/${vpn_id}
    Log     ${result.status_code}
    Log     ${result.json()['vrf']}
    Should Be Equal As Strings  ${result.status_code}  200
    [return]  ${result.json()['vrf']['status']}

Check Status Create_Vrf
    [Arguments]  ${vpn_id}   ${expected_value} 
    ${result}=  Get Vrf  ${vpn_id}
    Should Contain  ${result}  ${expected_value}
