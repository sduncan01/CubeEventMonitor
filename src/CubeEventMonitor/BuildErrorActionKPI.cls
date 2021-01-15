Class CubeEventMonitor.BuildErrorActionKPI Extends %DeepSee.KPI
{

/// This XData definition defines the KPI.
XData KPI [ XMLNamespace = "http://www.intersystems.com/deepsee/kpi" ]
{
<kpi
xmlns="http://www.intersystems.com/deepsee/kpi"
 name="BuildErrorKPI">

<property name="LastBuildTime" columnNo="1"/>
<property name="LastElapsedBuildTime" columnNo="2"/>
<action name="FixBuildErrors"/>
<action name="RebuildBuildErrorsCube"/>
</kpi>
}

/// This callback is invoked from a dashboard when an action defined by this dashboard is invoked.
ClassMethod %OnDashboardAction(pAction As %String, pContext As %ZEN.proxyObject) As %Status [ ZenMethod ]
{
 Set sc = $$$OK
 Try {
     if (pAction = "FixBuildErrors") {
         set filterSpec = pContext.currFilterSpec
         set memberName = $p($p(filterSpec,"%FILTER [CubeName].[H1].[CubeName].&[",2),"]",1)
         set conf = 0
         &js<alert("Running %FixBuildErrors for the selected cube.\n\nThe output of %FixBuildErrors can be found at <install-dir>/mgr/<namespace-default-globals-database>/FixBuildErrors_<timestamp>.txt.\n\nTo view the most recent build error data, run the Update Build Error Data action from the lower-left widget.")>
	     job ##class(CubeEventMonitor.Utils).FixBuildErrors(memberName,1)
     } elseif (pAction = "RebuildBuildErrorsCube") {
	     set conf = 0
	     &js<alert("Rebuilding the Build Error data.")>
	     job ##class(%DeepSee.Utils).%BuildCube("BUILDERRORSCUBE")
     } 
 }
 Catch(ex) {
     Set sc = ex.AsStatus()
 }
 Quit sc
}

Method %OnLoadKPI() As %Status
{
	for n = 1:1:..%seriesCount {
        Set tValue = $get(^CubeEventMonitor.BERebuildTime,"No build time found")
        Set ..%data(n,"LastBuildTime") = tValue
        set tValue = $get(^CubeEventMonitor.BEElapsed,"No elapsed build time found")
        set ..%data(n,"LastElapsedBuildTime") = tValue
    }
    quit $$$OK
}

}
