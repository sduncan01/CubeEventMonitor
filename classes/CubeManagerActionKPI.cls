Class DSII.CubeManagerActionKPI Extends %DeepSee.KPI
{

/// This XData definition defines the KPI.
XData KPI [ XMLNamespace = "http://www.intersystems.com/deepsee/kpi" ]
{
<kpi
xmlns="http://www.intersystems.com/deepsee/kpi"
 name="CubeManagerKPI">

<property name="LastDataUpdate" columnNo="1"/>
<property name="ErrorStatusMessage" columnNo="2"/>
<action name="GenerateCubeEventLog"/>
</kpi>
}

/// This callback is invoked from a dashboard when an action defined by this dashboard is invoked.
ClassMethod %OnDashboardAction(pAction As %String, pContext As %ZEN.proxyObject) As %Status [ ZenMethod ]
{
 Set sc = $$$OK
 Try {
     if (pAction = "GenerateCubeEventLog") {
	     &js<alert("Generating the Cube Event Log.")>
	     job ##class(DSII.CubeEventLogUtils).WriteLogFile()
     }
 }
 Catch(ex) {
     Set sc = ex.AsStatus()
 }

 Quit sc
}

Method %OnLoadKPI() As %Status
{
	set dataUpdateTime = $get(^DSII.LastCubeEventsUpdate,"No update time found")
	
	set errorStatus = ##class(DSII.CubeEventLogUtils).WriteRecentErrors()
	if ($System.Status.GetErrorText(errorStatus) = "ERROR #5001: No recent errors to display") {
		set errorStatusMsg = "No Cube Manager event errors in the last week"
	} elseif (errorStatus '= 1) {
		set errorStatusMsg = $System.Status.GetErrorText(errorStatus)
	} else {
		set errorStatusMsg = "Click ""View Recent Cube Event Errors"" for details"
	}
	
	for n = 1:1:..%seriesCount {
        set ..%data(n,"LastDataUpdate") = dataUpdateTime
        
        set ..%data(n,"ErrorStatusMessage") = errorStatusMsg
    }
    
    quit $$$OK
}

}
