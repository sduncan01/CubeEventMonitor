Class CubeEventMonitor.BuildErrors Extends %Persistent
{

Index IDK On (CubeName, SourceId) [ IdKey ];

Property SourceId As %Library.Integer;

Property CubeName As %String;

Property ErrorInfo As %String;

Property ErrorText As %String [ Calculated, SqlComputeCode = {set {*}=##class(%SYSTEM.Status).GetErrorText({ErrorInfo})}, SqlComputed ];

Parameter DEFAULTGLOBAL = "^CubeEventMonitor.BuildErr";

Storage Default
{
<Data name="BuildErrorsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ErrorInfo</Value>
</Value>
</Data>
<DataLocation>^CubeEventMonitor.BuildErrD</DataLocation>
<DefaultData>BuildErrorsDefaultData</DefaultData>
<IdLocation>^CubeEventMonitor.BuildErrD</IdLocation>
<IndexLocation>^CubeEventMonitor.BuildErrI</IndexLocation>
<StreamLocation>^CubeEventMonitor.BuildErrS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
