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

/// Run this method to set up the CubeManagerMonitor in this namespace.
/// The BuildErrorsCube and CubeEvents cubes will be added to the existing active cube registry, if there is one -
/// if there is not, one will be created at DeepSee.CubeManager.CubeRegistryDefinition. If <var>buildCubes</var>
/// is "true" (the default), these two cubes will be built - if there are already a large
/// number of cube events or build errors in this namespace, this may consume significant system resources
/// for several minutes or more. By default, these cubes will be rebuilt nightly. This setting can be changed
/// from the Cube Registry interface in the Management Portal after running this method.
ClassMethod Setup(compileFlags As %String = "", buildCubes As %Boolean = "true", updateInterval As %Integer = 60, folderItemResource As %String = "%DeepSee_Admin", alertRecipient As %String = "") As %Status
{
	do $System.OBJ.Compile("CubeEventMonitor.BuildErrors,CubeEventMonitor.BuildErrorActionKPI,CubeEventMonitor.BuildErrorsCube,CubeEventMonitor.CubeManagerActionKPI,CubeEventMonitor.CubeEventCube,CubeEventMonitor.CubeEventLogUtils,CubeEventMonitor.RecentErrorsPortlet",compileFlags)
	
	// add resources to folders containing pivots and dashboards
	set buildErrorsFolder = ##class(%DeepSee.UserLibrary.Utils).%FindFolder("BuildErrors",0,.sc)
	if (sc '= 1) {
		return sc
	} elseif (buildErrorsFolder = "") {
		return $$$ERROR($$$GeneralError,"Please import dashboards and pivots before running Setup!")
	} else {
		set buildErrorsFolder.resource = folderItemResource
		set sc = buildErrorsFolder.%Save()
		return:(sc '= 1) sc
	}
	
	set cubeEventsFolder = ##class(%DeepSee.UserLibrary.Utils).%FindFolder("CubeEvents",0,.sc)
	if (sc '= 1) {
		return sc
	} elseif (cubeEventsFolder = "") {
		return $$$ERROR($$$GeneralError,"Please import dashboards and pivots before running Setup!")
	} else {
		set cubeEventsFolder.resource = folderItemResource
		set sc = cubeEventsFolder.%Save()
		return:(sc '= 1) sc
	}
	
	// add cubes to Cube Registry
	set activeReg = ##class(%DeepSee.CubeManager.Utils).GetActiveRegistry()  
	if (activeReg = "") {
		// if no active cube registry exists in this namespace, create one
		set map = ##class(%DeepSee.CubeManager.RegistryMap).%New()
		set sc = map.SaveToClass("DeepSee.CubeManager.CubeRegistryDefinition")
		return:(sc '= 1) sc
		set sc = ##class(%DeepSee.CubeManager.Utils).SetActiveRegistry("DeepSee.CubeManager.CubeRegistryDefinition")
		return:(sc '= 1) sc
		set activeReg = "DeepSee.CubeManager.CubeRegistryDefinition"
	}
	set map = ##class(%DeepSee.CubeManager.Utils).BuildRegistryMap(,,,.lookup)
	
	set eventGroupIndex = $lg(lookup("cubes","CUBEEVENTS"),1)
	set eventCubeIndex = $lg(lookup("cubes","CUBEEVENTS"),2)
	set errorGroupIndex = $lg(lookup("cubes","BUILDERRORSCUBE"),1)
	set errorCubeIndex = $lg(lookup("cubes","BUILDERRORSCUBE"),2)
	
	// set up registry entries for CUBEEVENTS and BUILDERRORSCUBE
	
	set eventGroup = map.Groups.GetAt(eventGroupIndex)	
	set eventGroup.BuildAsynch = 1
	set eventGroup.BuildDayOfMonth = 1
	set eventGroup.BuildDayOfWeek = 1
	set eventGroup.BuildFrequency = 1
	set eventGroup.BuildTimeUnit = "Day"
	set eventGroup.Disabled = 0
	set eventGroup.GroupName = "Cube Events"
	set eventGroup.IsRegistered = 1
	set eventGroup.IsValid = 1
	set eventGroup.UpdatePlan = "Build"
	
	set eventCube = eventGroup.Cubes.GetAt(eventCubeIndex)
	set eventCube.BuildAsynch = 1
	set eventCube.BuildDayOfMonth = 1
	set eventCube.BuildDayOfWeek = 1
	set eventCube.BuildFrequency = 1
	set eventCube.BuildTimeUnit = "Day"
	set eventCube.CubeDisplayName = "Cube Events"
	set eventCube.CubeKey = "CUBEEVENTS"
	set eventCube.CustomBuildOrder = 1
	set eventCube.DependentCubes = ""
	set eventCube.Disabled = 0
	set eventCube.PostBuildCode = "do ##class(CubeEventMonitor.CubeEventCube).PostBuild()"
	set eventCube.UpdatePlan = "Build"
	
	set errorGroup = map.Groups.GetAt(errorGroupIndex)	
	set errorGroup.BuildAsynch = 1
	set errorGroup.BuildDayOfMonth = 1
	set errorGroup.BuildDayOfWeek = 1
	set errorGroup.BuildFrequency = 1
	set errorGroup.BuildTimeUnit = "Day"
	set errorGroup.Disabled = 0
	set errorGroup.GroupName = "Build Errors"
	set errorGroup.IsRegistered = 1
	set errorGroup.IsValid = 1
	set errorGroup.UpdatePlan = "Build"
	
	set errorCube = errorGroup.Cubes.GetAt(errorCubeIndex)
	set errorCube.BuildAsynch = 1
	set errorCube.BuildDayOfMonth = 1
	set errorCube.BuildDayOfWeek = 1
	set errorCube.BuildFrequency = 1
	set errorCube.BuildTimeUnit = "Day"
	set errorCube.CubeDisplayName = "BuildErrorsCube"
	set errorCube.CubeKey = "BUILDERRORSCUBE"
	set errorCube.CustomBuildOrder = 1
	set errorCube.DependentCubes = ""
	set errorCube.Disabled = 0
	set errorCube.PostBuildCode = ""
	set errorCube.UpdatePlan = "Build"

	// save the cube registry, overwriting the active registry definition
	set sc = map.SaveToClass(activeReg) 
	quit:(sc '= 1) sc
	
	if (buildCubes = "true") {
		// perform repair builds of the newly-registered cubes
		write !,"Building the CubeEvents cube",!
		set sc = eventCube.Repair(map)
		return:(sc '= 1) sc
		set sc = ##class(CubeEventMonitor.CubeEventCube).PostBuild()
		return:(sc '= 1) sc
		write !, "Building the BuildErrors cube",!
		set sc = errorCube.Repair(map)
		return:(sc '= 1) sc  
	} else {
		write !,"Skipping cube builds",!
	}

	// enable users to specify %Development resource for cubes as well as folder items (rather than %DeepSee_Admin, for demo/development purposes)
	if (folderItemResource = "%Development") {
		set buildErrorsModel = ##class(CubeEventMonitor.BuildErrorsCube).%GetModel()
		set buildErrorsModel.resource = folderItemResource
		set sc = ##class(%DeepSee.Utils).%SaveCubeDefinition("CubeEventMonitor.BuildErrorsCube",,buildErrorsModel.Description,buildErrorsModel)
		return:(sc '= 1) sc

		set cubeEventModel = ##class(CubeEventMonitor.CubeEventCube).%GetModel()
		set cubeEventModel.resource = folderItemResource
		set sc = ##class(%DeepSee.Utils).%SaveCubeDefinition("CubeEventMonitor.CubeEventCube",,cubeEventModel.Description,cubeEventModel)
		return:(sc '= 1) sc		
	
		do $System.OBJ.Compile("CubeEventMonitor.BuildErrorsCube,CubeEventMonitor.CubeEventCube",compileFlags)
	}
	
	// set up a runtime variable for use in the CubeManagerDashboard
	set ^DeepSee.User.Settings("FirstCube","value") = "##class(CubeEventMonitor.CubeEventLogUtils).GetDefaultCube()"
	set ^DeepSee.User.Settings("FirstCube","context") = "DefaultFilterValue"
	set ^DeepSee.User.Settings("FirstCube","comment") = ""
	
	// set up a termlist used for data-driven colors by a widget
	set ^DeepSee.TermList("SUCCESSFAILURECOLORS","name") = "SuccessFailureColors"
	set ^DeepSee.TermList("SUCCESSFAILURECOLORS","data","Failure","VALUE") = "Red"
	set ^DeepSee.TermList("SUCCESSFAILURECOLORS","data","Success","VALUE") = "Green"
	set ^DeepSee.TermList("SUCCESSFAILURECOLORS","modDate") = $zdt($h,3)
	
	// set up a task to update this cube - updateInterval is the number of minutes between task runs
	set updateTaskID = ##class(%SYS.Task).FindId("UpdateCubeEvents - "_$$$UPPER($namespace))
	if (updateTaskID = "") {
		set task = ##class(%SYS.Task).%New()
	} else {
		set task = ##class(%SYS.Task).%OpenId(updateTaskID,,.sc)
	}
	if ('$IsObject(task)) {
		if ($$$ISERR(sc)) {
			return sc
		} else {
			return %objlasterror
		}
	}
		
	set task.Name = "UpdateCubeEvents - "_$$$UPPER($namespace)
	set task.NameSpace = $namespace
	set task.MirrorStatus = 3
	set task.TaskClass = "CubeEventMonitor.UpdateCubeEvents"
	set task.RunAsUser = "_SYSTEM"
	set task.DailyFrequency = 1
	set task.DailyFrequencyTime = 0
	if (updateInterval < 5)  set updateInterval = 5 // update the cube a maximum of once every 5 minutes...
	if (updateInterval > 720)  set updateInterval = 720 // ...and a minimum of once every 12 hours
	set task.DailyIncrement = updateInterval
	set task.DailyStartTime = 0
	set task.DailyEndTime = 86399
	set task.Description = "Update the CubeEvents cube"
	
	set sc = task.StartDateSet($p($h,",",1))
	return:(sc '= 1) sc
	set sc = task.%Save()
	return:(sc '= 1) sc
	write !,"UpdateCubeEvents task scheduled to run every ",updateInterval," minutes",!
	set sc = task.Resume(task.%Id()) // if this task existed and was suspended, resume it
	return:(sc '= 1) sc	
	
	// set up a task to send email alerts, if an email address has been provided
	if (alertRecipient '= "") {
		kill task
		set ^CubeEventMonitor.AlertRecip = alertRecipient
		set alertTaskID = ##class(%SYS.Task).FindId("Cube Monitor Alerts - "_$$$UPPER($namespace))
		if (alertTaskID = "") {
			set task = ##class(%SYS.Task).%New()
		} else {
			set task = ##class(%SYS.Task).%OpenId(alertTaskID,,.sc)
		}
		if ('$IsObject(task)) {
			if ($$$ISERR(sc)) {
				return sc
			} else {
				return %objlasterror
			}
		}
		
		set task.Name = "Cube Monitor Alerts - "_$$$UPPER($namespace)
		set task.NameSpace = $namespace
		set task.MirrorStatus = 3
		set task.TaskClass = "CubeEventMonitor.CubeMonitorAlerts"
		set task.RunAsUser = "_SYSTEM"
		set task.DailyFrequency = 0 // send alerts once per day...
		set task.DailyStartTime = 21600 // ...at 6 am
		set task.Description = "Send Cube Monitor email alerts"
		
		// start the task today if it's before the start time; otherwise, start it tomorrow
		if ($p($h,",",2) < task.DailyStartTime) {
			set sc = task.StartDateSet($p($h,",",1))
		} else {
			set sc = task.StartDateSet($p($h,",",1) + 1)
		}
		return:(sc '= 1) sc
		set sc = task.%Save()
		return:(sc '=1) sc
		write !, "CubeMonitorAlerts task scheduled to run daily and send emails to ", alertRecipient
		write !, "Please make sure the SMTP server, port, and sender are configured in the Task Manager Email Settings!"
		set sc = task.Resume(task.%Id()) // if this task existed and was suspended, resume it
		return:(sc '= 1) sc	
	} else {
		write !, "CubeMonitorAlerts task not scheduled because no email alert recipient was specified"
	}
	
	write !
	quit $$$OK
}

ClassMethod UpdateCubeEvents(newTimestamp As %TimeStamp) As %Integer
{
	// check whether CUBEEVENTS has ever been built from the Cube Manager, and if it has, find the last time it was updated (by a build or by this method)

	if ('($d(^CubeEventMonitor.LastCEUpdate))) {
		set ^CubeEventMonitor.UpdateCEError(newTimestamp) = "The CubeEvents cube must be built from the Cube Manager before UpdateCubeEvents() can be run."
		return -1
	}
	set lastTimestamp = ^CubeEventMonitor.LastCEUpdate
	
	// get IDs for cube events that have started or finished since the last time CUBEEVENTS was updated
	set query = "SELECT ID FROM %DeepSee_CubeManager.CubeEvent WHERE StartTime >= '"_lastTimestamp_"' UNION SELECT ID FROM %DeepSee_CubeManager.CubeEvent WHERE FinishTime >= '"_lastTimestamp_"'"
	set statement = ##class(%SQL.Statement).%New()
	set sc = statement.%Prepare(query)
	if (sc'=1) {
		set ^CubeEventMonitor.UpdateCEError(newTimestamp) = sc
		return -1
	}
	set rs = statement.%Execute()
	
	// call %ProcessFact() on each ID from the result set
	set updatedCount = 0
	while rs.%Next() {
		set missingrefs = 0
		set sc = ##class(%DeepSee.Utils).%ProcessFact("CUBEEVENTS",rs.ID,,.missingrefs)
		if (missingrefs > 0) {
			// this should not happen given the current CUBEEVENTS model, which has no relationships
			set ^CubeEventMonitor.UpdateCEError(newTimestamp,rs.ID) = sc
			set ^CubeEventMonitor.UpdateCEError(newTimestamp,rs.ID,"MissingRef") = missingrefs
		}
		elseif (sc '= 1) {
			set ^CubeEventMonitor.UpdateCEError(newTimestamp,rs.ID) = sc
		}
		else {
			// count facts that are successfully processed
			set updatedCount = updatedCount + 1
		}
	}
	
	// set LastCubeEventsUpdate global node to the start time of this update
	set ^CubeEventMonitor.LastCEUpdate = newTimestamp
	return updatedCount
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
