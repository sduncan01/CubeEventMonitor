/// 
Class CubeEventMonitor.BuildErrorsCube Extends %DeepSee.CubeDefinition [ DependsOn = (CubeEventMonitor.BuildErrors, CubeEventMonitor.BuildErrorActionKPI), ProcedureBlock ]
{

/// Cube definition from Architect.
XData Cube [ XMLNamespace = "http://www.intersystems.com/deepsee" ]
{
<cube xmlns="http://www.intersystems.com/deepsee" name="BuildErrorsCube" displayName="BuildErrorsCube" disabled="false" abstract="false" sourceClass="CubeEventMonitor.BuildErrors" actionClass="CubeEventMonitor.BuildErrorActionKPI" resource="%DeepSee_Admin" countMeasureName="%COUNT" bucketSize="8" bitmapChunkInMemory="false" precompute="0" disableListingGroups="false">
  <dimension name="CubeName" disabled="false" hasAll="false" allCaption="All CubeName" allDisplayName="CubeName" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="CubeName" disabled="false" sourceProperty="CubeName" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
        <property name="BuildOrder" disabled="false" sourceExpression="$lg(^CubeEventMonitor.RegMapLookup(&quot;cubes&quot;,%source.CubeName),1)_&quot;.&quot;_$lg(^CubeEventMonitor.RegMapLookup(&quot;cubes&quot;,%source.CubeName),2)" hidden="false" sort="asc numeric" isName="false" isDescription="false" isReference="false" useDisplayValue="false">
        </property>
      </level>
    </hierarchy>
  </dimension>
  <dimension name="ErrorInfo" disabled="false" hasAll="false" allCaption="All ErrorInfo" allDisplayName="ErrorInfo" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="ErrorCode" disabled="false" sourceExpression="$piece(%source.ErrorText,&quot;:&quot;,1)" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="ErrorType" disabled="false" sourceExpression="$piece(%source.ErrorText,&quot;:&quot;,1)_&quot; - &quot;_$piece(%source.ErrorText,&quot;:&quot;,2)_&quot;...&quot;" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="ErrorDateTime" disabled="false" hasAll="false" allCaption="All ErrorDateTime" allDisplayName="ErrorDateTime" sourceExpression="$s(%expression.GetInfo&apos;=&quot;&quot;:$lg(%expression.GetInfo,1,&quot;&quot;),1:&quot;&quot;)" type="time" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="Time" disabled="false" hidden="false">
      <level name="ErrorHour" disabled="false" timeFunction="HourNumber" list="false" nullReplacement="No timestamp" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="ErrorTime" disabled="false" timeFunction="MinuteNumber" list="false" nullReplacement="No timestamp" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
    <hierarchy name="Date" disabled="false" hidden="false">
      <level name="ErrorYear" disabled="false" timeFunction="Year" list="false" nullReplacement="No timestamp" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="ErrorMonthYear" disabled="false" timeFunction="MonthYear" list="false" nullReplacement="No timestamp" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="ErrorDMY" disabled="false" timeFunction="DayMonthYear" list="false" nullReplacement="No timestamp" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Job" disabled="false" hasAll="false" allCaption="All Job" allDisplayName="Job" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Job" disabled="false" sourceExpression="$s(%expression.GetInfo&apos;=&quot;&quot;:$lg(%expression.GetInfo,2,&quot;&quot;),1:&quot;&quot;)" list="false" nullReplacement="No job information" useDisplayValue="false" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <expression name="GetInfo" disabled="false" sourceExpression="%cube.GetInfo(%source.CubeName,%source.SourceId)">
  </expression>
  <listing name="DefaultListing" disabled="false" listingType="table" fieldList="CubeName,CAST(SourceId AS CHAR VARYING) SourceID,ErrorText">
  </listing>
</cube>
}

ClassMethod GetInfo(CubeName As %String, ID As %String) As %List
{
	quit $g(^DeepSee.BuildErrors(CubeName,ID,"info"),"")
}

/// Notification that this cube is about to be built.<br/>
ClassMethod %OnBuildCube() As %Status
{
	set ^CubeEventMonitor.BERebuildTime = $zdt($h)
	
	kill ^CubeEventMonitor.RegMapLookup
	set map = ##class(%DeepSee.CubeManager.Utils).BuildRegistryMap(.sc,,,.lookup)
	merge ^CubeEventMonitor.RegMapLookup = lookup
	
	quit sc
}

/// Notification that this cube has completed its build.<br/>
/// The status of the overall build is contained in <var>pBuildStatus</var>. If the build is otherwise successful, 
/// the value of <var>pBuildStatus</var> can be changed within the callback to become the new status returned by %BuildCube.
/// If there were any build errors in the individual facts the count of these errors is reported in 
/// <var>pBuildErrors</var>
ClassMethod %OnAfterBuildCube(pBuildStatus As %Status, pBuildErrors As %Boolean = 0) As %Status
{
	set end = $h
	set start = $zdth(^CubeEventMonitor.BERebuildTime)
	set elapsed = 0
	
	if ($p(end,",",1) = $p(start,",",1)) {
		set elapsed = $p(end,",",2) - $p(start,",",2)
	} elseif ($p(end,",",1) = ($p(start,",",1)+1)) {
		set elapsed = $p(end,",",2) + (86400 - $p(start,",",2))
	} else {
		throw ##class(%Exception.General).%New("Elapsed time invalid or > 1 day")
	}
	
	set hours = elapsed \ 3600
	set minutes = (elapsed # 3600) \ 60
	set seconds = elapsed # 60
	if (hours < 10) set hours = "0"_hours
	if (minutes < 10) set minutes = "0"_minutes
	if (seconds < 10) set seconds = "0"_seconds
	set timeDisplay = hours_":"_minutes_":"_seconds
	set ^CubeEventMonitor.BEElapsed = timeDisplay
	
	Quit $$$OK
}

Parameter DOMAIN;

}
