*** settings ***
Resource          get_vrf.robot
Library           Lib.conversions
Library           Lib/RequestsLibrary.py
Library           Lib/Common.py
Library           RequestsLibrary
Library           Collections


*** Keywords ***
Create Vrf
    [Arguments]  ${vrf} 
    Create Session  Plugin  http://${APGW_PLUGIN}:9696  headers=${X-AUTH}
    ${data}=  Create Dictionary   vrf=${vrf}
    ${data}=  Get Json From Dict  ${data}
    ${result} =  Post  Plugin  /v2.0/apgw/vrfs  ${data}
    Log     ${result.status_code}
    Log     ${result.json()['vrf']}
    Should Be Equal As Strings  ${result.status_code}  202
    [return]  ${result.json()['vrf']['id']}


Create Vrf Error
    [Arguments]  ${vrf} 
    Create Session  Plugin  http://${APGW_PLUGIN}:9696  headers=${X-AUTH}
    ${data}=  Create Dictionary   vrf=${vrf}
    ${data}=  Get Json From Dict  ${data}
    ${result} =  Post  Plugin  /v2.0/apgw/vrfs  ${data}
    Log     ${result.status_code}
    Should Be Equal As Strings  ${result.status_code}  400


Check Status Create_Vrf
    [Arguments]  ${vpn_id}   ${expected_value} 
    ${result}=  Get Vrf  ${vpn_id}
    Should Contain  ${result}  ${expected_value}
