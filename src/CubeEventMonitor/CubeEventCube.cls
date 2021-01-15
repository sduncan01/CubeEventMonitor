/// 
Class CubeEventMonitor.CubeEventCube Extends %DeepSee.CubeDefinition [ DependsOn = (%DeepSee.CubeManager.CubeEvent, CubeEventMonitor.CubeManagerActionKPI) ]
{

/// Cube definition from Architect.
XData Cube [ XMLNamespace = "http://www.intersystems.com/deepsee" ]
{
<cube xmlns="http://www.intersystems.com/deepsee" name="CubeEvents" displayName="Cube Events" disabled="false" abstract="false" sourceClass="%DeepSee.CubeManager.CubeEvent" actionClass="CubeEventMonitor.CubeManagerActionKPI" resource="%DeepSee_Admin" countMeasureName="%COUNT" bucketSize="8" bitmapChunkInMemory="false" precompute="0" disableListingGroups="false">
  <dimension name="CubeEvent" disabled="false" hasAll="false" allCaption="All CubeEvent" allDisplayName="CubeEvent" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="CubeEvent" disabled="false" sourceProperty="CubeEvent" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="CubeName" disabled="false" hasAll="false" allCaption="All CubeKey" allDisplayName="CubeKey" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="CubeName" disabled="false" sourceProperty="CubeKey" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="EventStatus" disabled="false" hasAll="false" allCaption="All EventStatus" allDisplayName="EventStatus" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="EventStatus" disabled="false" sourceExpression="$S(%source.EventStatus:&quot;Success&quot;,1:&quot;Failure&quot;)" list="false" nullReplacement="No Status" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="StartTime" disabled="false" hasAll="false" allCaption="All StartTime" allDisplayName="StartTime" sourceProperty="StartTime" sourceExpression="$ZDTH(%source.StartTime,3)" type="time" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="false">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="StartTime Year" disabled="false" timeFunction="Year" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="StartTime MonthYear" disabled="false" timeFunction="MonthYear" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="StartTime DMY" disabled="false" timeFunction="DayMonthYear" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
    <hierarchy name="H2" disabled="false" hidden="false">
      <level name="StartTime Hour" disabled="false" timeFunction="HourNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
    <hierarchy name="H3" disabled="false" hidden="false">
      <level name="StartTime Minute" disabled="false" timeFunction="MinuteNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="StartDateTime" disabled="true" hasAll="false" allCaption="All StartTime1" allDisplayName="StartTime1" sourceProperty="StartTime" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="StartDateTime" disabled="false" sourceProperty="StartTime" timeFunction="Year" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="FinishTime" disabled="true" hasAll="false" allCaption="All FinishTime" allDisplayName="FinishTime" sourceExpression="$ZDTH(source.FinishTime,3)" type="time" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="FinishTime MonthYear" disabled="false" timeFunction="MonthYear" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="FinishTime DMY" disabled="false" timeFunction="DayMonthYear" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
    <hierarchy name="H2" disabled="false" hidden="false">
      <level name="FinishTime Hour" disabled="false" timeFunction="HourNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="FinishDateTime" disabled="true" hasAll="false" allCaption="All FinishTime1" allDisplayName="FinishTime1" sourceProperty="FinishTime" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="FinishDateTime" disabled="false" sourceProperty="FinishTime" list="false" useDisplayValue="true" sort="asc" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="UpdateFrequency" displayName="Update Frequency" disabled="false" hasAll="false" allCaption="All BuildFrequency" allDisplayName="BuildFrequency" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="Build" disabled="false" hidden="false">
      <level name="BuildFrequency" displayName="Build Frequency" disabled="false" sourceExpression="%source.BuildFrequency _ &quot; &quot; _ %source.BuildTimeUnit" list="false" nullReplacement="No Build" useDisplayValue="false" useAsFilter="true" hidden="false">
        <property name="BuildSortValue" disabled="false" sourceExpression="$Case(%source.BuildTimeUnit,&quot;Month&quot;:&quot;1.&quot;,&quot;Week&quot;:&quot;2.&quot;,&quot;Day&quot;:&quot;3.&quot;,:&quot;&quot;) _ %source.BuildFrequency" hidden="false" sort="asc numeric" isName="false" isDescription="false" isReference="false" useDisplayValue="false">
        </property>
      </level>
    </hierarchy>
    <hierarchy name="Synchronize" disabled="false" hidden="false">
      <level name="SynchFrequency" displayName="Synch Frequency" disabled="false" sourceExpression="%source.SynchFrequency _ &quot; &quot; _ %source.SynchTimeUnit" list="false" nullReplacement="No Synch" useDisplayValue="false" useAsFilter="true" hidden="false">
        <property name="SynchSortValue" disabled="false" sourceExpression="$Case(%source.SynchTimeUnit,&quot;Day&quot;:&quot;1.&quot;,&quot;Hour&quot;:&quot;2.&quot;,&quot;Minute&quot;:&quot;3.&quot;,:&quot;&quot;) _ %source.SynchFrequency" hidden="false" sort="asc numeric" isName="false" isDescription="false" isReference="false" useDisplayValue="false">
        </property>
      </level>
    </hierarchy>
  </dimension>
  <dimension name="FactsUpdated" disabled="false" hasAll="false" allCaption="All FactsUpdated" allDisplayName="FactsUpdated" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="Synchronize" disabled="false" hidden="false">
      <level name="FactsUpdatedSync" disabled="false" sourceExpression="$S(%source.CubeEvent=&quot;synch&quot;:%source.FactsUpdated,1:-1)" list="false" rangeExpression="(-1,-1):None;[,1):0;[1,10]:1-10;(10,30]:11-30;(30,100):31-99;[100,]:100+;" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
    <hierarchy name="Build" disabled="false" hidden="false">
      <level name="FactsUpdatedBuild" disabled="false" sourceExpression="$S(((%source.CubeEvent=&quot;build&quot;)||(%source.CubeEvent=&quot;repair&quot;)):%source.FactsUpdated,1:-1)" list="false" rangeExpression="(-1,-1):None;[0,1):0;[1,100]:1-100;(100,10000]:100-10^4;(10000,1000000]:10^4-10^6;(1000000,]:&gt;10^6;" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="NCores" disabled="false" hasAll="false" allCaption="All NCores" allDisplayName="NCores" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="NCores" disabled="false" sourceProperty="NCores" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="UserName" disabled="false" hasAll="false" allCaption="All UserName" allDisplayName="UserName" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="UserName" disabled="false" sourceProperty="UserName" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="AsynchUpdate" disabled="false" hasAll="false" allCaption="All AsynchUpdate" allDisplayName="AsynchUpdate" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="AsynchUpdate" disabled="false" sourceProperty="AsynchUpdate" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="AgentCount" disabled="false" hasAll="false" allCaption="All AgentCount" allDisplayName="AgentCount" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="AgentCount" disabled="false" sourceProperty="AgentCount" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="RegistryGroup" disabled="false" hasAll="false" allCaption="All RegistryGroup" allDisplayName="RegistryGroup" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="RegistryGroup" disabled="false" sourceProperty="MgmtGroup" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <measure name="Fact Count" disabled="false" sourceProperty="CubeSize" aggregate="AVG" type="number" hidden="false" searchable="false">
  </measure>
  <measure name="Facts Updated" displayName="Facts Updated" disabled="false" sourceProperty="FactsUpdated" aggregate="AVG" type="number" hidden="false" searchable="false">
  </measure>
  <measure name="Error Count" displayName="Error Count" disabled="false" sourceProperty="ErrorCount" aggregate="SUM" type="number" hidden="false" searchable="false">
  </measure>
  <measure name="Missing References" disabled="false" sourceProperty="MissingRefs" aggregate="SUM" type="number" hidden="false" searchable="false">
  </measure>
  <measure name="Total Time" displayName="Total Time" disabled="false" sourceProperty="TotalTime" aggregate="AVG" type="number" scale="5" hidden="false" searchable="true" iKnowSource="string">
  </measure>
  <measure name="iKnow Time" displayName="iKnow Time" disabled="false" sourceProperty="iKnowTime" aggregate="AVG" type="number" scale="2" hidden="false" searchable="false" iKnowSource="string">
  </measure>
  <measure name="Expression Time" displayName="Expression Time" disabled="false" sourceProperty="ExprTime" aggregate="AVG" type="number" scale="2" hidden="false" searchable="false">
  </measure>
  <measure name="AVGOtherTime" displayName="Average Other Processing Time" disabled="true" sourceExpression="%source.TotalTime*%source.NCores - (%source.iKnowTime + %source.ExprTime)" aggregate="AVG" type="number" hidden="false" searchable="false">
  </measure>
  <measure name="Cube Key" disabled="true" sourceProperty="CubeKey" aggregate="COUNT" type="string" hidden="false" searchable="false">
  </measure>
  <measure name="AgentCount" disabled="true" sourceProperty="AgentCount" aggregate="AVG" type="number" hidden="false" searchable="false">
  </measure>
  <measure name="Last StartTime" disabled="false" sourceExpression="$ZDH(%source.StartTime,3)" factName="MxLastStartTime" aggregate="MAX" type="date" hidden="false" searchable="true" listingFilterOperator="MAX">
  </measure>
  <calculatedMember name="LastEventCubeSize" disabled="true" dimension="Measures" valueExpression="%KPI()" hidden="false">
  </calculatedMember>
  <listing name="Cube Event Details" disabled="false" listingType="table" fieldList="ID, CubeKey AS &quot;CubeName&quot;, StartTime, FinishTime, CubeEvent, EventStatus, CubeSize AS &quot;FactCount&quot;, ErrorCount, TotalTime, FactsUpdated, MissingRefs, ExprTime, MgmtGroup AS &quot;RegistryGroup&quot;, AsynchUpdate, AgentCount">
  </listing>
</cube>
}

ClassMethod PostBuild() As %Status
{
	// find the start time of the most recent completed build or repair event for the CUBEEVENTS cube
	set query = "SELECT TOP 1 ID, StartTime FROM %DeepSee_CubeManager.CubeEvent WHERE FinishTime <> '' AND CubeKey = 'CUBEEVENTS' AND (CubeEvent = 'build' OR CubeEvent = 'repair') ORDER BY StartTime DESC"
	set statement = ##class(%SQL.Statement).%New()
	set sc = statement.%Prepare(query)
	if (sc'=1) {
		return sc
	}
	set rs = statement.%Execute()
	
	// set the LastCubeEventsUpdate global node to the above start time, so that UpdateCubeEvents can begin from that timestamp
	if (rs.%Next()) {
		set ^CubeEventMonitor.LastCEUpdate = rs.StartTime
	}
	return $$$OK
}

Parameter DOMAIN;

}
