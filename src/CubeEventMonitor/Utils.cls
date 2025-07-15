Class CubeEventMonitor.Utils Extends %RegisteredObject
{

/// Run this method to set up the CubeManagerMonitor in this namespace.
/// The BuildErrorsCube and CubeEvents cubes will be added to the existing active cube registry, if there is one -
/// if there is not, one will be created at DeepSee.CubeManager.CubeRegistryDefinition. If <var>buildCubes</var>
/// is "true" (the default), these two cubes will be built - if there are already a large
/// number of cube events or build errors in this namespace, this may consume significant system resources
/// for several minutes or more. By default, these cubes will be rebuilt nightly. This setting can be changed
/// from the Cube Registry interface in the Management Portal after running this method.
ClassMethod Setup(compileFlags As %String = "", buildCubes As %Boolean = "true", updateInterval As %Integer = 60, folderItemResource As %String = "%DeepSee_Admin", alertRecipient As %String = "") As %Status
{
	do $System.OBJ.Compile("CubeEventMonitor.BuildErrors,CubeEventMonitor.BuildErrorActionKPI,CubeEventMonitor.BuildErrorsCube,CubeEventMonitor.CubeManagerActionKPI,CubeEventMonitor.CubeEventCube,CubeEventMonitor.Utils,CubeEventMonitor.RecentErrorsPortlet",compileFlags)
	
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
		set sc = ##class(%DeepSee.Utils).%SaveCubeDefinition("CubeEventMonitor.BuildErrorsCube",,buildErrorsModel.description,buildErrorsModel)
		return:(sc '= 1) sc

		set cubeEventModel = ##class(CubeEventMonitor.CubeEventCube).%GetModel()
		set cubeEventModel.resource = folderItemResource
		set sc = ##class(%DeepSee.Utils).%SaveCubeDefinition("CubeEventMonitor.CubeEventCube",,cubeEventModel.description,cubeEventModel)
		return:(sc '= 1) sc		
	
		do $System.OBJ.Compile("CubeEventMonitor.BuildErrorsCube,CubeEventMonitor.CubeEventCube",compileFlags)
	}
	
	// set up a runtime variable for use in the CubeManagerDashboard
	set ^DeepSee.User.Settings("FirstCube","value") = "##class(CubeEventMonitor.Utils).GetDefaultCube()"
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

ClassMethod WriteLogFile() As %Status
{
		// get an array of the cubes that could be built
		set sc = ##class(%DeepSee.Utils).%GetCubeList(.cubeList,"cubes",1)
		quit:(sc'=1) sc
		
        set dir=##class(%SYSTEM.Process).CurrentDirectory()
        set file = dir_"RecentCubeEvents.txt"
        open file:("NRW"):1
        use file
        write "Recent cube events checked at ",$zdt($h),!

		if ('($d(cubeList))) {
			write "No cubes found",!
			close file
			quit $$$OK
		}
		
		set currCube = $order(cubeList(""))
		while (currCube '= "") {
			set fieldList = "ID, CubeKey AS ""CubeName"", StartTime, FinishTime, CubeEvent, EventStatus, CubeSize AS ""FactCount"", ErrorCount, TotalTime, FactsUpdated, MissingRefs, ExprTime, MgmtGroup AS ""RegistryGroup"", AsynchUpdate, AgentCount"
			set cubeQuery = "SELECT TOP 1 "_fieldList_" FROM %DeepSee_CubeManager.CubeEvent WHERE CubeKey = ? AND CubeEvent = 'Build' ORDER BY FinishTime DESC UNION %PARALLEL SELECT TOP 1 "_fieldList_" FROM %DeepSee_CubeManager.CubeEvent WHERE CubeKey = ? AND CubeEvent = 'Synch' ORDER BY FinishTime DESC ORDER BY FinishTime DESC" 
				// just build and synch for now, can add other events if necessary
			set statement = ##class(%SQL.Statement).%New()
			set sc = statement.%Prepare(cubeQuery)
			if (sc'=1) {
				close file
				return sc
			}
			set rs = statement.%Execute(currCube,currCube)
			
			if (rs.%SQLCODE '= 0) {
				write !,"SQL error for ",currCube,": ",rs.%SQLCODE
			} elseif (rs.%Next()) {
				write !,"Most recent build and synch events for ",currCube,":"
				
				for i = 1:1:15 {
					// set nodes of l1 to the values for the first line
					set l1(i) = rs.%GetData(i)
					if ((i = 6) && (l1(i) '= 1)) set l1(i) = $System.Status.GetErrorText(l1(i)) // if there is an error status, get the text
				}
				if (rs.%Next()) {
					for i = 1:1:15 {
						// set nodes of l2 to the values for the second line, if any
						set l2(i) = rs.%GetData(i)
						if ((i = 6) && (l2(i) '= 1)) set l2(i) = $System.Status.GetErrorText(l2(i)) // if there is an error status, get the text

					}
				} else {
					for i = 1:1:15 {
						set l2(i) = ""
					}
				}
					
				// calculate spacing for each column		
				set idL = ..maxL(l1(1),l2(1),"ID") + 4
				set cubeNameL = ..maxL(l1(2),l2(2),"CubeName") + idL + 4
				set startTimeL = ..maxL(l1(3),l2(3),"StartTime") + cubeNameL + 4
				set finishTimeL = ..maxL(l1(4),l2(4),"FinishTime") + startTimeL + 4
				set cubeEventL = ..maxL(l1(5),l2(5),"CubeEvent") + finishTimeL + 4
				set eventStatusL = ..maxL(l1(6),l2(6),"EventStatus") + cubeEventL + 4
				if (..maxL(l1(6),l2(6),"EventStatus") > 40) set eventStatusL = cubeEventL + 44 // only display first 40 characters of error message
				set factCountL = ..maxL(l1(7),l2(7),"FactCount") + eventStatusL + 4
				set errorCountL = ..maxL(l1(8),l2(8),"ErrorCount") + factCountL + 4
				set totalTimeL = ..maxL(l1(9),l2(9),"TotalTime") + errorCountL + 4
				set factsUpdatedL = ..maxL(l1(10),l2(10),"FactsUpdated") + totalTimeL + 4
				set missingRefsL = ..maxL(l1(11),l2(11),"MissingRefs") + factsUpdatedL + 4
				set exprTimeL = ..maxL(l1(12),l2(12),"ExprTime") + missingRefsL + 4
				set registryGroupL = ..maxL(l1(13),l2(13),"RegistryGroup") + exprTimeL + 4
				set asynchUpdateL = ..maxL(l1(14),l2(14),"AsynchUpdate") + registryGroupL + 4
			
				// print a header row
				write !,"ID",?idL,"CubeName",?cubeNameL,"StartTime",?startTimeL,"FinishTime",?finishTimeL,"CubeEvent",?cubeEventL,"EventStatus",?eventStatusL,"FactCount",?factCountL
				write "ErrorCount",?errorCountL,"TotalTime",?totalTimeL,"FactsUpdated",?factsUpdatedL,"MissingRefs",?missingRefsL,"ExprTime",?exprTimeL,"RegistryGroup",?registryGroupL
				write "AsynchUpdate",?asynchUpdateL,"AgentCount"

				// print the first line
				write !,l1(1),?idL,l1(2),?cubeNameL,l1(3),?startTimeL,l1(4),?finishTimeL,l1(5),?cubeEventL,$extract(l1(6),1,40),?eventStatusL,l1(7),?factCountL,l1(8),?errorCountL
				write l1(9),?totalTimeL,l1(10),?factsUpdatedL,l1(11),?missingRefsL,l1(12),?exprTimeL,l1(13),?registryGroupL,l1(14),?asynchUpdateL,l1(15)
				
				// print the second line, if any
				if (l2(1) '= "") {
					write !,l2(1),?idL,l2(2),?cubeNameL,l2(3),?startTimeL,l2(4),?finishTimeL,l2(5),?cubeEventL,$extract(l2(6),1,40),?eventStatusL,l2(7),?factCountL,l2(8),?errorCountL
					write l2(9),?totalTimeL,l2(10),?factsUpdatedL,l2(11),?missingRefsL,l2(12),?exprTimeL,l2(13),?registryGroupL,l2(14),?asynchUpdateL,l2(15)
				}

				write !
			} else {
				write !,"No Cube Registry build or synch events for ",currCube,!
			}

			set currCube = $order(cubeList(currCube))
		}
		
		close file
		quit $$$OK
}

ClassMethod WriteRecentErrors(file As %String = "RecentCubeEventErrors") As %Status
{
	set lastweek = $zdt(((+$h)-7)_",0",3)
	set fieldList = "ID, CubeKey AS ""CubeName"", StartTime, FinishTime, CubeEvent, CubeEventMonitor.Utils_getEventStatusText(EventStatus) AS ""CubeEventStatus"", CubeSize AS ""FactCount"", ErrorCount, TotalTime, FactsUpdated, MissingRefs, ExprTime, MgmtGroup AS ""RegistryGroup"", AsynchUpdate, AgentCount"
	set cubeQuery = "SELECT "_fieldList_" FROM %DeepSee_CubeManager.CubeEvent WHERE EventStatus %STARTSWITH '0' AND (FinishTime >= '"_lastweek_"' OR (FinishTime IS NULL AND StartTime >= '"_lastweek_"')) ORDER BY FinishTime DESC"
	set statement = ##class(%SQL.Statement).%New()
	set sc = statement.%Prepare(cubeQuery)
	if (sc'=1) {
		return sc
	}
	set rs = statement.%Execute()
	
	if (rs.%SQLCODE = 100) {
		return $System.Status.Error(5001,"No recent errors to display")
	} elseif (rs.%SQLCODE '= 0) {
		return $System.Status.Error(5521,rs.%SQLCODE,rs.%Message) 
	} else { 
		do rs.%DisplayFormatted("HTML",file)
	}
	
	quit $$$OK
}

ClassMethod getEventStatusText(origVal As %String) As %String [ SqlProc ]
{
	quit $System.Status.GetErrorText(origVal)
}

ClassMethod maxL(a As %String = "", b As %String = "", c As %String = "") As %Integer [ Internal ]
{
	set la = $length(a)
	set lb = $length(b)
	set lc = $length(c)
	
	if (la > lb) {
		if (la > lc) {
			quit la
		} else {
			quit lc
		}
	} elseif (lb > lc) {
		quit lb
	} else {
		quit lc
	}
}

/// This method gets the default value for the Cube filter on the Cube Manager dashboard each time the dashboard is loaded.
/// If there are any "Build" events in the Cube Events table, it will return the cube with the most recent such event. Otherwise,
/// it will return the first cube it finds in the ^DeepSee.Cubes global. This value will be returned as a key for the cube's member
/// in the CubeName dimension in the Cube Events cube.
ClassMethod GetDefaultCube() As %String [ Internal ]
{
	// if there are any build events, get the cube with the most recent one
	&sql(SELECT TOP 1 CubeKey INTO :defaultCube FROM %DeepSee_CubeManager.CubeEvent WHERE CubeEvent = 'Build' ORDER BY FinishTime DESC)
	// otherwise, use the first cube found in the ^DeepSee.Cubes global
	set:('$data(defaultCube)) defaultCube = $order(^DeepSee.Cubes("cubes",""))
	
	quit "&["_defaultCube_"]"
}

/// wrapper for %DeepSee.Utils:%FixBuildErrors(), called by FixBuildErrors custom action in CubeEventMonitor.BuildErrorActionKPI:%OnDashboardAction()
ClassMethod FixBuildErrors(cubeName As %String, verbose As %Boolean)
{
	set startTime = $zdt($h,3)
	set filenameTime = $translate(startTime,":","-")
	set filenameTime = $translate(filenameTime," ","_")
	
	set dir=##class(%SYSTEM.Process).CurrentDirectory()
    set file = dir_"FixBuildErrors_"_filenameTime_".txt"
    open file:("NRW"):1
    use file
    
    write "Starting %FixBuildErrors() at ",startTime," for cube ",$$$UPPER(cubeName),!
    
    set sc = ##class(%DeepSee.Utils).%FixBuildErrors(cubeName,verbose)
    write:(sc '= 1) "Error: ",sc,!
    write:(sc = 1) "%FixBuildErrors() finished at ",$zdt($h,3),!
    
    close file
    quit
}

}
