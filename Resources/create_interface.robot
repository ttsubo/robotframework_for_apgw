*** settings ***
Resource          get_interface.robot          
Library           Lib.conversions
Library           Lib/RequestsLibrary.py
Library           Lib/Common.py
Library           RequestsLibrary
Library           Collections


*** Keywords ***
Create Interface
    [Arguments]  ${vpn_id}  ${interface} 
    Create Session  Plugin  http://${APGW_PLUGIN}:9696  headers=${X-AUTH}
    ${data}=  Create Dictionary   interface=${interface}
    ${data}=  Get Json From Dict  ${data}
    ${result} =  Post  Plugin  /v2.0/apgw/vrfs/${vpn_id}/interfaces  ${data}
    Log     ${result.status_code}
    Log     ${result.json()['interface']}
    Should Be Equal As Strings  ${result.status_code}  202
    [return]  ${result.json()['interface']['id']}

Check Status Create_Interface
    [Arguments]  ${vpn_id}  ${interface_id}  ${expected_value} 
    ${result}=  Get Interface  ${vpn_id}  ${interface_id}
    Should Contain  ${result}  ${expected_value}
