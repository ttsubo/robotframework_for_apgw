*** settings ***
Library     Lib.conversions
Library     RequestsLibrary
Library     Collections

*** Keywords ***
Get Event
    [Arguments]  ${TestServer}
    ${headers}=  Create Dictionary  Content-Type=application/json
    Create Session  TestServer  http://${TestServer}:8080  ${headers}
    ${result} =  Get  TestServer  /apgw/event/latest
    Log     ${result.json()['event']['event_id']}
    Log     ${result.json()['event']['ping_result']}
    Log     ${result.json()['event']['ping_recv']}
    Log     ${result.json()['event']['show_rib_result']}
    Log     ${result.json()['event']['show_neighbor_result']}
    Should Be Equal As Strings  ${result.status_code}  200
    [return]  ${result.json()['event']['ping_result']}
