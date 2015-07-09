*** settings ***
Library           Lib.conversions
Library           Lib/RequestsLibrary.py
Library           Lib/Common.py
Library           RequestsLibrary
Library           Collections

*** Keywords ***
Get Route
    [Arguments]  ${vpn_id}  ${route_id}
    Create Session  Plugin  http://${APGW_PLUGIN}:9696  headers=${X-AUTH}
    ${result} =  Get  Plugin  /v2.0/apgw/vrfs/${vpn_id}/routes/${route_id}
    Log     ${result.status_code}
    Log     ${result.json()['route']}
    Should Be Equal As Strings  ${result.status_code}  200
    [return]  ${result.json()['route']['status']}

Get non_Route
    [Arguments]  ${vpn_id}  ${route_id}
    Create Session  Plugin  http://${APGW_PLUGIN}:9696  headers=${X-AUTH}
    ${result} =  Get  Plugin  /v2.0/apgw/vrfs/${vpn_id}/routes/${route_id}
    Log     ${result.status_code}
    [return]  ${result.status_code}
