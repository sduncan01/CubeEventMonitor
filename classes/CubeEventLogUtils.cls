Class CubeEventMonitor.CubeEventLogUtils Extends %RegisteredObject
{

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

ClassMethod WriteRecentErrors() As %Status
{
	set lastweek = $zdt(((+$h)-7)_",0",3)
	set fieldList = "ID, CubeKey AS ""CubeName"", StartTime, FinishTime, CubeEvent, CubeEventMonitor.CubeEventLogUtils_getEventStatusText(EventStatus) AS ""CubeEventStatus"", CubeSize AS ""FactCount"", ErrorCount, TotalTime, FactsUpdated, MissingRefs, ExprTime, MgmtGroup AS ""RegistryGroup"", AsynchUpdate, AgentCount"
	set cubeQuery = "SELECT "_fieldList_" FROM %DeepSee_CubeManager.CubeEvent WHERE EventStatus %STARTSWITH '0' AND FinishTime >= '"_lastweek_"' ORDER BY FinishTime DESC"
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
		do rs.%DisplayFormatted("HTML")
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

}
