/// DSII.MaxFactPlugin
/// 
/// This DeepSee Plugin returns the value of a specified field from one source record.
/// The returned value is from the source record with the largest value for the specified CompareField. 
/// Examples: the following will return the ID of the source record with the highest TestScore
/// %KPI("MaxFactPlugin","MaxValue",1,"OutputField","%ID","CompareField","TestScore","%CONTEXT")
/// 
/// This plugin class is modified from an earlier version written by Alessandro Marin.
Class DSII.MaxFactPlugin Extends %DeepSee.KPIPlugIn
{

/// This plugin should be useable with all cubes
Parameter BASECUBE = "*";

/// SourceTable
Parameter LISTINGSOURCE = "SourceTable";

Parameter PLUGINTYPE = "Pivot";

XData KPI [ XMLNamespace = "http://www.intersystems.com/deepsee/kpi" ]
{
<kpi name="MaxFactPlugin" displayName="MaxValue" caption="MaxValue" >
<filter name="%cube" displayName="Subject Area"/>
<filter name="%OutputField" displayName="OutputField" description="Field from source record to be returned as output"/>
<filter name="%CompareField" displayName="CompareField"  description="Field from source record to maximize (%ID by default). The OutputField from the source record with the maximum CompareField value will be returned. The record with the highest %ID is used in case of a tie"/>
<property name="MaxValue" displayName="MaxValue" description="" />

</kpi>
}

/// Get the base query for this plug-in.
Method %OnGetMDX(ByRef pMDX As %String) As %Status
{
	set tBaseCube = ""
	// Use %cube filter to find the base cube
	if $IsObject(..%filterValues) {
		if (..%filterValues.%cube'="") {
			set tBaseCube = ..%filterValues.%cube
		}
	}
	if (tBaseCube'="") {
		set pMDX = "SELECT FROM "_tBaseCube
	}
	quit $$$OK
}

/// Returns the field list (RETURN clause) of the listing used to supply data for this plug-in.
/// In this case, determine which field in the source table we need.
Method %OnGetListingFields() As %String
{
	set tListingFields = "'ERROR: No OutputField' OutputField"
	if $IsObject(..%filterValues) {
		if (..%filterValues.%data("OutputField")'="") {		
			set tOutputField = ..%filterValues.%data("OutputField")
			set tListingFields = tOutputField_" OutputField"
		}
 		set tCompareField = "%ID"
		if $D(..%filterValues.%data("CompareField"))'=0 {
			set tCompareField = ..%filterValues.%data("CompareField")
		} 
		set tListingFields = tListingFields_","_tCompareField_" CompareField"
	
	}
	quit tListingFields_",%ID ID"  // Also pass the ID in case you want to use it in %OnCompute
}

/// Compute the value for the last record using the result set.
Method %OnCompute(pSQLRS As %SQL.StatementResult, pFactCount As %Integer) As %Status
{
	set tSC = $$$OK
	try {
		set tValue = ""
		set tErrMsg = ""
		set highest = ""  // negative number
		set n = 0
		while (pSQLRS.%Next(.tSC)) { 
			if $$$ISERR(tSC) {
				set tErrMsg = $System.Status.GetErrorText(tSC)
				quit
			}
			// Get the the highest value for the CompareField. Breaking ties: the corresponding record is the one with the highest %ID
   			if (pSQLRS.CompareField >= highest) {
     			set tValue = pSQLRS.OutputField
     			set highest = pSQLRS.CompareField  	
  			}
			if ($ZSTRIP($P(tValue,":"),"<>W")="ERROR") {
				set tErrMsg = $P(tValue,":",2)
				quit
			}
			// update percent complete
			set n = n + 1
			if (n#100 = 0) {
				Do ..%SetPercentComplete(100*(n/pFactCount))
			}
		}
		// place answer in KPI output
		set ..%seriesCount = 1
		set ..%seriesNames(1) = "MaxValue"
		if (tErrMsg'="") {
			set ..%data(1,"MaxValue") = tErrMsg
		} else {
			set ..%data(1,"MaxValue") = tValue
		}
	}
	catch(ex) {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

}
