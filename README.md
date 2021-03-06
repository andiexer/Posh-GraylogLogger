# Posh-GraylogLogger
Powershell Modul for logging your script logs into GrayLog via GELF. 

> ATTENTION! This module is experimental only at the moment. i'll try to get it stable as soon as possible!
> therefore if you enable $DebugPreference = 'Continue' you will see a lot of messages for debugging purposes

## Description
this repository contains a powershell module for writting log entries into graylog via gelf http (tcp/udp work in progress). following features are implemented:
- simple text logging
- structured logging

## TODO's

- [x] global logging properties
- [x] glogal logging properties as hashtable
- [x] http gelf support
- [x] basic logging and structured logging
- [x] additional log properties per request
- [x] add tcp and udp support
- [ ] tcp tls support?

more to come...
 
## Functions

### New-GLServerConnection
Creates connection to graylog server

Parameter | ParameterSet | Mandatory | Type | DefaultValue | Description
--------- | ------------ | --------- | ---- | ------------ | -----------
Server | Server | true | string | - | servername or ip
Port | Server | true | int | - | port of your gelf http endpoint
TransportMode | Server | true | GLTransportMode | Http | transport mode for logging (https/http/tcp/udp)
Endpoint | Server | false | string | gelf | your endpoint name (text behind :Port/...)
ConfigFile | ConfigFile | false | switch | false | use this switch if you wanna use a config file for parmeters  
ConfigFilePath | ConfigFile | false | string | - | if you wanna provide a custom settings file (full path)

#### Configfile
the default config file is called **psgrayloglogger.settings** which is basically a json file and looks like this
```json
{
    "Server" : "yourserver",
    "Port" : 12201,
    "Endpoint" : "gelf",
    "TransportMode" : "Http"
}
```
default path is the powershell module directory.


### Add-GLGlobalLogProperty
Adding a global logging property which will be appended on each log entry

Parameter | Mandatory | Type | DefaultValue | Description
--------- | --------- | ---- | ------------ | -----------
PropertyName | true | string | - | name of the property 
PropertyValue | true | object | - | value of the property (will be converted to string value)

### Add-GLGlobalLogProperties
Adding multiple global logging properties which will be appended on each log entry

Parameter | Mandatory | Type | DefaultValue | Description
--------- | --------- | ---- | ------------ | -----------
Properties | true | hashtable | - | hashtable with properties

### Write-GLLog
Creates a log entry and writes it into graylog

Parameter | Mandatory | Type | DefaultValue | Description
--------- | --------- | ---- | ------------ | -----------
LogLevel | true | GLLogLevel | - | loglevel of current entry
LogText | true | string | - | logtext (simple or structured)
PropertyValues | false | object | - | if Logtext is structured you have to provide the properties to replace the placeholders
AdditionalProperties | true | object | - | additional properties which will be indexed into graylog but not shown in the logtext (scope logentry only) Hashtable

> you can also add custom objects to the PropertyValues and AdditionalProperties. PSGraylogLogger will try to convert these to json and adds these values to the logtext or as additional property

### Set-GLDefaultCmdlets
Overwrites the basic cmdlets Write-Debug, Write-Verbose, Write-Output, Write-Warning and Write-Error. As a result you are able to send every message written by these cmdlets additional to the graylog server.

Parameter | Mandatory | Type | DefaultValue | Description
--------- | --------- | ---- | ------------ | -----------
Enable | false | switch | - | imports the overwrite functions
Disable | false | switch | - | removes the overwrite functions

## Examples

**import the module**
```powershell
Import-Module PSGrayLogLogger
```

**set connection to graylog server with 'server' parameterset**
```powershell
New-GLServerConnection -Server <SERVERNAME or IP> -Port <GELF Port> -Endpoint <Endpointname (Default 'gelf')> -TransportMode Http
New-GLServerConnection -Server <SERVERNAME or IP> -Port <GELF Port> -TransportMode Udp
```

**set connection to graylog server with 'configfile' parameterset**
```powershell
New-GLServerConnection -ConfigFile #using default filename 'psgrayloglogger.settings' and default path
New-GLServerConnection -ConfigFile -ConfigFilePath "C:\dev\myconfig.json" #using custom config file
```

**add global log properties to context. these properties will be added to each log entry you will fire up**
```powershell
Add-GLGlobalLogProperty -PropertyName "ScriptName" -PropertyValue "TestScript.ps1"
```
this will add a property called **ScriptName** with value **TestScript.ps1** to every log entry you will create

**add multiple global log properties to context. these properties will be added to each log entry you will fire up**
```powershell
Add-GLGlobalLogProperties -Properties @{PropertyOne = "Hello"; PropertyTwo = "World"}
```
this will add a two properties called **PropertyOne/PropertyTwo** with values **Hello/World** to every log entry you will create

**create simple log entry**
```powershell
Write-GLLog -LogLevel Information -LogText "This is a simple logtext" 
```
### Screenshot
![simple log entry](docs/log_entry_simple.PNG)

**create a structured log entry**
```powershell
Write-GLLog -LogLevel Information -LogText "Current status from api: {apiStatus}" -PropertyValues @('up')
```
this produces a log with logtext: *"Current status from api: up"* and adds a property to graylog called **apiStatus** with value **up**
### Screenshot
![simple log entry](docs/log_entry_structured.PNG)

**create a structured log with simple logtext and additional properties**
```powershell
Write-GLLog -LogLevel Information -LogText "This is a simple logtext" -AdditionalProperties @{TimeElapsedSeconds = 12.5}
```
this produces a log with logtext: *"This is a simple logtext"* and adds a property to graylog called **TimeElapsedSeconds** with value **12.5**
### Screenshot
![simple log entry](docs/log_entry_simple_additional.PNG)

**create a structured log with  and additional properties**
```powershell
Write-GLLog -LogLevel Information "Current status from api: {apiStatus}" -PropertyValues @('up') -AdditionalProperties @{TimeElapsedSeconds = 12.5}
```
this produces a log with logtext: *"Current status from api: up"* and adds a two properties to graylog called **apiStatus** with value **up** and **TimeElapsedSeconds** with value **12.5**
### Screenshot
![simple log entry](docs/log_entry_structured_additional.PNG)



