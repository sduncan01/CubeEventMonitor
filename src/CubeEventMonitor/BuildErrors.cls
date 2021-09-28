Class CubeEventMonitor.BuildErrors Extends %Persistent
{

Index IDK On (CubeName, SourceId) [ IdKey ];

Property SourceId As %Library.Integer;

Property CubeName As %String;

Property ErrorInfo As %String;

Property ErrorText As %String [ Calculated, SqlComputeCode = {set {*}=##class(%SYSTEM.Status).GetErrorText({ErrorInfo})}, SqlComputed ];

Storage Default
{
<CounterLocation>^DeepSee.BuildErrors</CounterLocation>
<Data name="BuildErrorsDefaultData">
<Subscript>"1"</Subscript>
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ErrorText</Value>
</Value>
</Data>
<Data name="DSTIMEDefaultData">
<Attribute>ErrorInfo</Attribute>
<Structure>node</Structure>
</Data>
<DataLocation>^DeepSee.BuildErrors</DataLocation>
<DefaultData>BuildErrorsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DeepSee.BuildErrors</IdLocation>
<IndexLocation>^CubeEventMonitor.BuildErrI</IndexLocation>
<StreamLocation>^CubeEventMonitor.BuildErrS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
