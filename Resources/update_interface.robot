*** settings ***
Resource          get_interface.robot
Library           Lib.conversions
Library           Lib/RequestsLibrary.py
Library           Lib/Common.py
Library           RequestsLibrary
Library           Collections


*** Keywords ***
Update Interface ServiceType
    [Arguments]  ${vpn_id}  ${interface_id}  ${interface} 
    Create Session  Plugin  http://${APGW_PLUGIN}:9696  headers=${X-AUTH}
    ${data}=  Create Dictionary   interface=${interface}
#    ${data}=  Get Json From Dict  ${data}
    ${result} =  Put  Plugin
                 ...  /v2.0/apgw/vrfs/${vpn_id}/interfaces/${interface_id}
                 ...  ${data}
    Log     ${result.status_code}
    Log     ${result.json()['interface']}
    Should Be Equal As Strings  ${result.status_code}  202
    [return]  ${result.json()['interface']['id']}

Check Status Update_Interface
    [Arguments]  ${vpn_id}  ${interface_id}  ${expected_value} 
    ${result}=  Get Interface  ${vpn_id}  ${interface_id}
    Should Contain  ${result}  ${expected_value}
