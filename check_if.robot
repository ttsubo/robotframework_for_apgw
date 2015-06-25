*** Settings ***
Library         SSHLibrary

Test Teardown       Close All Connections

*** Variables ***
${gateswitch1}           10.128.141.15
${gateswitch2}           10.128.141.16
${user}                  root
${pass}                  netronome

*** TestCases ***
Check interface in gatesw1
    Open Connection  ${gateswitch1}
    Login  ${user}  ${pass}
    ${result}=  Execute Command
                ...  ifconfig -a
    Log  ${result}

Down interface for wan-if in gatesw1
    Open Connection  ${gateswitch1}
    Login  ${user}  ${pass}
    ${result}=  Execute Command
                ...  ifconfig OFP31 down
    Log  ${result}

Up interface for wan-if in gatesw1
    Open Connection  ${gateswitch1}
    Login  ${user}  ${pass}
    ${result}=  Execute Command
                ...  ifconfig OFP31 up
    Log  ${result}
