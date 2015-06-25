*** settings ***
Resource          get_token.robot
Library           Lib.conversions
Library           Lib/RequestsLibrary.py
Library           Lib/Common.py
Library           RequestsLibrary
Library           Collections


*** Keywords ***
Delete Interface
    [Arguments]  ${vpn_id}  ${interface_id}
    Create Session  Plugin  http://${APGW_PLUGIN}:9696  headers=${X-AUTH}
    ${result} =  Delete  Plugin
                 ...  /v2.0/apgw/vrfs/${vpn_id}/interfaces/${interface_id}
    Log     ${result.status_code}
    Log     ${result.json()['interface']}
    Should Be Equal As Strings  ${result.status_code}  202

Get non_Interface
    [Arguments]  ${vpn_id}  ${interface_id}
    Create Session  Plugin  http://${APGW_PLUGIN}:9696  headers=${X-AUTH}
    ${result} =  Get  Plugin
                 ...  /v2.0/apgw/vrfs/${vpn_id}/interfaces/${interface_id}
    Log     ${result.status_code}
    [return]  ${result.status_code}

Check Status Delete_Interface
    [Arguments]  ${vpn_id}  ${interface_id}
    ${result}=  Get non_Interface  ${vpn_id}  ${interface_id}
    Should Be Equal As Strings  ${result}  404
