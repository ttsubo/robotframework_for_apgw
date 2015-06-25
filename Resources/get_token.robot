*** Settings ***
Library     SSHLibrary
Library     Collections
Library     Lib/RequestsLibrary.py
Library     Lib/Common.py

*** Variables ***
${UserInfo}=  {"auth": {"tenantName": "admin", "passwordCredentials": {"username": "admin", "password": "secrete"}}}

** Keywords ***
Get Token
    ${headers}=  Create Dictionary  Content-Type=application/json
    Create Session  KeyStoneSession  http://${APGW_PLUGIN}:5000  ${headers} 
    ${resp}      post    KeyStoneSession     /v2.0/tokens    ${UserInfo}
    Should Be Equal As Strings    ${resp.status_code}     200
    ${result}	To JSON   ${resp.content}
    ${result}   Get From Dictionary   ${result}  access
    ${result}   Get From Dictionary   ${result}  token
    ${TOKEN}	Get From Dictionary   ${result}  id
    ${X-AUTH}	Create Dictionary     X-Auth-Token=${TOKEN}
                ...                   Content-Type=application/json      
    Set Global Variable   ${X-AUTH}
