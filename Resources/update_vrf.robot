*** settings ***
Resource          get_vrf.robot
Library           Lib.conversions
Library           Lib/RequestsLibrary.py
Library           Lib/Common.py
Library           RequestsLibrary
Library           Collections


*** Keywords ***
Update Vrf Extranets
    [Arguments]  ${vpn_id}  ${vrf} 
    Create Session  Plugin  http://${APGW_PLUGIN}:9696  headers=${X-AUTH}
    ${data}=  Create Dictionary   vrf=${vrf}
#    ${data}=  Get Json From Dict  ${data}
    ${result} =  Put  Plugin
                 ...  /v2.0/apgw/vrfs/${vpn_id}
                 ...  ${data}
    Log     ${result.status_code}
    Log     ${result.json()['vrf']}
    Should Be Equal As Strings  ${result.status_code}  202
    [return]  ${result.json()['vrf']['id']}

Check Status Update_Vrf
    [Arguments]  ${vpn_id}  ${expected_value} 
    ${result}=  Get Vrf  ${vpn_id}
    Should Contain  ${result}  ${expected_value}
