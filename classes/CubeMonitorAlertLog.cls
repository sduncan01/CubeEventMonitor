/// Logging class for Cube Monitor Alerts tasks - adapted from Peter Steiwer's Data Driven Alerts project, available under the MIT License at https://github.com/psteiwer/DataDrivenAlerts
Class CubeEventMonitor.CubeMonitorAlertLog Extends %Persistent
{

Property Alert As %String;

Property AlertTriggered As %Boolean;

Property SQL As %String(MAXLEN = 32000);

Property AlertStatus As %Status;

Property TimeStamp As %TimeStamp [ InitialExpression = {$zdt($h,3)} ];

Property Value As %Integer;

Parameter DEFAULTGLOBAL = "^CubeEventMonitor.CEMAlertLog";

/// Takes in info about an Alert Task and logs the information to the TaskLog
ClassMethod LogTask(pAlert, pValue, pRes, pAlertStatus, pSQL) As %Status
{
	Set tSC = $$$OK
	
	Set tTaskLog = ##class(CubeEventMonitor.CubeMonitorAlertLog).%New()
	Set tTaskLog.Alert = pAlert
	Set tTaskLog.AlertTriggered = pRes
	Set tTaskLog.SQL = $E(pSQL,1,32000) // Truncate if SQL string is too long
	Set tTaskLog.AlertStatus = pAlertStatus
	Set tTaskLog.Value = pValue
	
	Set tSC = tTaskLog.%Save()
	
	Quit tSC
}

Storage Default
{
<Data name="CubeMonitorAlertLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Alert</Value>
</Value>
<Value name="3">
<Value>AlertTriggered</Value>
</Value>
<Value name="4">
<Value>SQL</Value>
</Value>
<Value name="5">
<Value>AlertStatus</Value>
</Value>
<Value name="6">
<Value>TimeStamp</Value>
</Value>
<Value name="7">
<Value>Value</Value>
</Value>
</Data>
<DataLocation>^CubeEventMonitor.CEMAlertLogD</DataLocation>
<DefaultData>CubeMonitorAlertLogDefaultData</DefaultData>
<IdLocation>^CubeEventMonitor.CEMAlertLogD</IdLocation>
<IndexLocation>^CubeEventMonitor.CEMAlertLogI</IndexLocation>
<StreamLocation>^CubeEventMonitor.CEMAlertLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
