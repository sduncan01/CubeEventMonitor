/// Cube Monitor Alerts task - adapted from Peter Steiwer's Data Driven Alerts project, available under the MIT License at https://github.com/psteiwer/DataDrivenAlerts
Class DSII.CubeMonitorAlerts Extends %SYS.Task.Definition
{

Parameter TaskName = "Cube Monitor Alerts";

/// Method is called when task is run. This task will find all alert conditions that need to be checked and the task will take action if necessary
Method OnTask() As %Status
{
	Set sc=$$$OK
	Try {
		set startTime = $zdt($h,3)			

		// run the CubeEventErrors alert
		set alertName = "CubeEventErrors"		
		set sc = ..RunAlert(alertName,startTime)
		return:(sc '= 1) sc
	
		// run the BuildErrors alert
		set alertName = "BuildErrors"
		set sc = ..RunAlert(alertName,startTime)
		return:(sc '= 1) sc
	} Catch ex {
		Set sc = ex.AsStatus()
	} 
	
	Quit sc
}

/// Run a single alert with a specified query
ClassMethod RunAlert(alertName As %String, startTime As %DateTime) As %Status
{
	// search for errors since the last alert, or in the last week if no LastAlertTime is logged
	set lastAlertTime = $g(^DSII.LastAlertTime(alertName),$zdt(((+$h)-7)_",0",3))
	
	set alertQuery = $case(alertName,
							"CubeEventErrors":"SELECT COUNT(*) FROM %DeepSee_CubeManager.CubeEvent WHERE EventStatus %STARTSWITH '0' AND (FinishTime >= '"_lastAlertTime_"' OR (FinishTime IS NULL AND StartTime >= '"_lastAlertTime_"'))",
							"BuildErrors":"SELECT COUNT(*) FROM (SELECT TOP 1 ID FROM DSII.BuildErrors)", // just see if there are any build errors, we can count them more efficiently later
							:"Invalid alert")
	if (alertQuery = "Invalid alert") {
		throw ##class(%Exception.General).%New("Invalid alert name "_alertName)
	}
	
	set statement = ##class(%SQL.Statement).%New()
	set sc = statement.%Prepare(alertQuery)
	if (sc'=1) {
		return sc
	}
	set rs = statement.%Execute()
		
	if (rs.%Next()) {
		set alertCount = rs.%GetData(1)
	} else {
		throw ##class(%Exception.General).%New("No alert query result set")
	}
		
	if (alertCount > 0) {
		set sc = ..SendAlert(alertName,alertCount)
	}
		
	set sc = ##class(DSII.CubeMonitorAlertLog).LogTask(alertName,alertCount,(alertCount > 0),sc,alertQuery)
	set ^DSII.LastAlertTime(alertName) = startTime

	quit sc
}

/// The SendAlert will be triggered when the alert condition has been met. This method handles sending the email alert
ClassMethod SendAlert(alertName As %String, pValue As %Numeric) As %Status
{
	Set tSC=$$$OK
	try {
		Set tMail=##class(%Net.MailMessage).%New()
		Do tMail.To.Insert($g(^DSII.CubeAlertRecipient,""))
	 	Set tMail.From="CubeMonitorAlerts@intersystems.com"
	 	Set tSMTP=##class(%Net.SMTP).%New()
	 	set tSMTP.port = ##class(%SYS.Task.Config).GetData("Port")
	 	Set tMailServer=##class(%SYS.Task.Config).GetData("MailServer")
		If tMailServer'="" {
			Set tSMTP.smtpserver=tMailServer
			Set tMail.IsHTML=1
			
			// Add Message to Email
			if (alertName = "CubeEventErrors") {
				set tMail.Subject = "Alert condition for CubeEventErrors alert (value: "_pValue_") has been met"
				do tMail.TextData.WriteLine("This message is to inform you that the alert condition of the Cube Event Errors alert has been met. There have been "_pValue_" Cube Registry events with errors in this namespace since the last alert.</br></br>To view recent events with errors, please open the RecentCubeEventErrors dashboard in the CubeEvents folder from the User Portal.")
			} elseif (alertName = "BuildErrors") {
				set tMail.Subject = "Alert condition of BuildErrors alert has been met"
				do tMail.TextData.WriteLine("This message is to inform you that the alert condition of the Build Errors alert has been met. The build error count for cubes in this namespace is:</br>")
				set totalErrCount = 0
				set cubeName = $order(^DeepSee.BuildErrors(""))
				while (cubeName '= "") {
					set currErrCount = ^DeepSee.BuildErrors(cubeName)
					set totalErrCount = totalErrCount + currErrCount
					do tMail.TextData.WriteLine("<br/>"_cubeName_": "_currErrCount_" errors")
					set cubeName = $order(^DeepSee.BuildErrors(cubeName))
				}
				do tMail.TextData.WriteLine("<br/><br/>TOTAL ERROR COUNT: "_totalErrCount)
				
			}
			do tMail.TextData.WriteLine("<br/><br/>Server: "_$p($system,":",1)_"<br/>Instance: "_$p($system,":",2)_"<br/>Namespace: "_$namespace)

	 		Set tSC=tSMTP.Send(tMail)
		} Else {
			Set tSC=$$$ERROR($$$GeneralError,"Mail server not configured")
		}
	} catch ex {
		Set tSC=ex.AsStatus()
	}

	Quit tSC
}

}
