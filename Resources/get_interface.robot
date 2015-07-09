*** settings ***
Library           Lib.conversions
Library           Lib/RequestsLibrary.py
Library           Lib/Common.py
Library           RequestsLibrary
Library           Collections


*** Keywords ***
Get Interface
    [Arguments]  ${vpn_id}  ${interface_id}
    Create Session  Plugin  http://${APGW_PLUGIN}:9696  headers=${X-AUTH}
    ${result} =  Get  Plugin
                 ...  /v2.0/apgw/vrfs/${vpn_id}/interfaces/${interface_id}
    Log     ${result.status_code}
    Log     ${result.json()['interface']}
    Should Be Equal As Strings  ${result.status_code}  200
    [return]  ${result.json()['interface']['status']}

Get non_Interface
    [Arguments]  ${vpn_id}  ${interface_id}
    Create Session  Plugin  http://${APGW_PLUGIN}:9696  headers=${X-AUTH}
    ${result} =  Get  Plugin
                 ...  /v2.0/apgw/vrfs/${vpn_id}/interfaces/${interface_id}
    Log     ${result.status_code}
    [return]  ${result.status_code}
