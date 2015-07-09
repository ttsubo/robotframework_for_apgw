*** settings ***
Library     RequestsLibrary
Library     Collections

*** Variables ***
${cmd}                        ping

*** Keywords ***
Action Ping
    [Arguments]  ${vpn_id}  ${destination}
    ${params}=  Create Dictionary  destination=${destination}
    ${action}=  Create Dictionary  params=${params}
                                   ...  method=${cmd}
    Create Session  Plugin  http://${APGW_PLUGIN}:9696  headers=${X-AUTH}
    ${data}=  Create Dictionary   action=${action}
    ${result} =  Put  Plugin  /v2.0/apgw/vrfs/${vpn_id}/action  ${data}
#    ${data}=  Get Json From Dict  ${data}
    Log     ${result.status_code}
    Log     ${result.json()['action']['results']}
    Should Be Equal As Strings  ${result.status_code}  200
    [return]  ${result.json()['action']['results']}

Check Connectivity
    [Arguments]  ${vpn_id}  ${destination}  ${expected_value}
    ${result}=  Action Ping  ${vpn_id}  ${destination}
    Should Contain  ${result}  ${expected_value}
