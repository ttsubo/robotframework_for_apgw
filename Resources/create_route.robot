*** settings ***
Resource          get_route.robot
Library           Lib.conversions
Library           Lib/RequestsLibrary.py
Library           Lib/Common.py
Library           RequestsLibrary
Library           Collections


*** Keywords ***
Create Route
    [Arguments]  ${vpn_id}  ${route} 
    Create Session  Plugin  http://${APGW_PLUGIN}:9696  headers=${X-AUTH}
    ${data}=  Create Dictionary   route=${route}
    ${data}=  Get Json From Dict  ${data}
    ${result} =  Post  Plugin  /v2.0/apgw/vrfs/${vpn_id}/routes  ${data}
    Log     ${result.status_code}
    Log     ${result.json()['route']}
    Should Be Equal As Strings  ${result.status_code}  202
    [return]  ${result.json()['route']['id']}

Check Status Create_Route
    [Arguments]  ${vpn_id}  ${route_id}  ${expected_value} 
    ${result}=  Get Route  ${vpn_id}  ${route_id}
    Should Contain  ${result}  ${expected_value}
