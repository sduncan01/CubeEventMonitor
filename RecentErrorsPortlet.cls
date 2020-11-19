Class DSII.RecentErrorsPortlet Extends %DeepSee.Component.Portlet.abstractPortlet
{

/// Static HTML display method: draw the BODY of this component as HTML.
Method %DrawHTML()
{
	set sc = ##class(DSII.CubeEventLogUtils).WriteRecentErrors()
	
	if ($System.Status.GetErrorText(sc) = "ERROR #5001: No recent errors to display") {
		&html<<div class="portletDiv">#("There are no Cube Manager events with errors in the last week.")#</div>>
	} elseif (sc '= 1) {
		set errorText = $System.Status.GetErrorText(sc)
		&html<<div class="portletDiv">#(errorText)#</div>>	
	} else {
		set dir=##class(%SYSTEM.Process).CurrentDirectory()
        set file = dir_"RecentCubeEventErrors.html"
		open file:("R"):1
		use file
		
		read line:1
		set i = 1
		while (line '= "</html>") {
			set table(i) = line
						
			read line:1
			set i = i+1
		}
		
		close file
		
		set j = $order(table(""))
		while (j '= "") {
			if ($e(table(j),1,5) = "<head")  set headpos = j
			if (table(j) = "</head>")  set endheadpos = j
			if ($e(table(j),1,5) = "<body")  set bodypos = j
			if (table(j) = "</body>")  set endbodypos = j
			
			set j = $order(table(j))
		}
		
		&html<<div class="portletDiv">>
		
		for k = headpos:1:endheadpos  &html<#(table(k))#>

		for l = bodypos:1:endbodypos &html<#(table(l))#>

		&html<</div>>		
	}
}

}
