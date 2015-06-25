*** settings ***
Library           RequestsLibrary
Library           Collections
Library           Lib.conversions

*** Keywords ***
Start BGPSpeaker
    [Arguments]  ${RyuBGP}  ${bgp}
    ${headers}=  Create Dictionary  Content-Type=application/json
    Create Session  RyuBGP  http://${RyuBGP}:8080  ${headers}
    ${data}=  Create Dictionary   bgp=${bgp}
    ${data}=  Get Json From Dict  ${data}
    ${result} =  Post  RyuBGP  /openflow/0000000000000001/bgp  ${data}
    Log     ${result.status_code}
    Log     ${result.json()['bgp']}
    Should Be Equal As Strings  ${result.status_code}  200

Create Interface
    [Arguments]  ${RyuBGP}  ${interface}
    ${headers}=  Create Dictionary  Content-Type=application/json
    Create Session  RyuBGP  http://${RyuBGP}:8080  ${headers}
    ${data}=  Create Dictionary   interface=${interface}
    ${data}=  Get Json From Dict  ${data}
    ${result} =  Post  RyuBGP  /openflow/0000000000000001/interface  ${data}
    Log     ${result.status_code}
    Log     ${result.json()['interface']}
    Should Be Equal As Strings  ${result.status_code}  200

Create Vrf
    [Arguments]  ${RyuBGP}  ${vrf}
    ${headers}=  Create Dictionary  Content-Type=application/json
    Create Session  RyuBGP  http://${RyuBGP}:8080  ${headers}
    ${data}=  Create Dictionary   vrf=${vrf}
    ${data}=  Get Json From Dict  ${data}
    ${result} =  Post  RyuBGP  /openflow/0000000000000001/vrf  ${data}
    Log     ${result.status_code}
    Log     ${result.json()['vrf']}
    Should Be Equal As Strings  ${result.status_code}  200

Set Redistribute On
    [Arguments]  ${RyuBGP}  ${bgp}
    ${headers}=  Create Dictionary  Content-Type=application/json
    Create Session  RyuBGP  http://${RyuBGP}:8080  ${headers}
    ${data}=  Create Dictionary   bgp=${bgp}
    ${data}=  Get Json From Dict  ${data}
    ${result} =  Post  RyuBGP  /openflow/0000000000000001/redistribute  ${data}
    Log     ${result.status_code}
    Log     ${result.json()['bgp']}
    Should Be Equal As Strings  ${result.status_code}  200

Set Static Routing
    [Arguments]  ${RyuBGP}  ${route}
    ${headers}=  Create Dictionary  Content-Type=application/json
    Create Session  RyuBGP  http://${RyuBGP}:8080  ${headers}
    ${data}=  Create Dictionary   route=${route}
    ${data}=  Get Json From Dict  ${data}
    ${result} =  Post  RyuBGP  /openflow/0000000000000001/route  ${data}
    Log     ${result.status_code}
    Log     ${result.json()['route']}
    Should Be Equal As Strings  ${result.status_code}  200

Start Bmp
    [Arguments]  ${RyuBGP}  ${bmp}
    ${headers}=  Create Dictionary  Content-Type=application/json
    Create Session  RyuBGP  http://${RyuBGP}:8080  ${headers}
    ${data}=  Create Dictionary   bmp=${bmp}
    ${data}=  Get Json From Dict  ${data}
    ${result} =  Post  RyuBGP  /openflow/0000000000000001/bmp  ${data}
    Log     ${result.status_code}
    Log     ${result.json()['bmp']}
    Should Be Equal As Strings  ${result.status_code}  200
