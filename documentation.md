# Cube Event Monitor

The Cube Event Monitor tool provides dashboards to allow you to monitor events (such as building and synchronizing cubes) run from the Cube Registry on your system, as well as to monitor and fix build errors in your cubes.

## Setup

Import all classes and DFI files into the namespace where you want to use the Cube Event Monitor. Compile (at least) CubeEventMonitor.CubeEventCube.cls, then open the Terminal and run

write ##class(CubeEventMonitor.Utils).Setup(\<compileFlags>,\<buildCubes>,\<updateInterval>,\<folderItemResource>)

in this namespace, where \<compileFlags> is a string of any compile flags you want to use, \<buildCubes> is either "true" (the default) or "false", \<updateInterval> is the frequency in minutes with which you want to update data in the CubeEvents cube, and \<folderItemResource> is the name of an existing resource that you want applied to the folder items (pivots and dashboards) that you have imported as part of the Cube Event Monitor. 

The default \<updateInterval> is 60 minutes; the minimum and maximum allowed values are 5 minutes and 720 minutes (12 hours). The default \<folderItemResource> is %DeepSee_Admin; if you specify a different resource, it will be used instead.

If \<buildCubes> is "true", the CubeEventCube and BuildErrors cube will both be built immediately. If there are already a large number of cube events or build errors in this namespace, this may consume significant system resources for several minutes or more. The Setup() method also adds these two cubes to the Cube Registry in this namespace (creating a new registry class called DeepSee.CubeManager.CubeRegistryDefinition if none is active). By default, these cubes will be rebuilt once per day. This setting can be changed from the Cube Registry interface in the Management Portal after running this method.

## Security

The CubeEventCube and BuildErrors cube are both secured with the %DeepSee_Admin resource. If you prefer to use a different resource, you can edit this for each cube from the Architect after running CubeEventMonitor.Utils:Setup(). If you edit a cube's resource, you should recompile it, but it is not necessary to rebuild it.

The CubeEvents and BuildErrors folders are secured with the resource you specified when running CubeEventMonitor.Utils:Setup() - see the Setup section above. The default resource for these folders is %DeepSee_Admin. A resource applied to a folder applies to all pivots and dashboards in that folder.

## Dashboards

Once you have run the Setup() method, you can view the CubeManagerDashboard and BuildErrorsDashboard from the User Portal in the namespace where you have set up this tool. The default web application for this namespace must be Analytics-enabled in order to view the User Portal.

### The Cube Manager Dashboard

The Cube Manager Dashboard allows you to view information about events, such building and synchronizing cubes, that have been run from the Cube Registry. The dashboard has the following widgets:

#### Controls

This widget contains controls and links to related dashboards.

"Generate Cube Event Log" will generate a text file with information the most recent build and synchronize event run by the Cube Registry for each cube in this namespace. The log file is located on the server, in the directory that stores the default globals database for the current namespace, and is named RecentCubeEvents.txt. For example, it may be located at C:\InterSystems\<INSTANCE>\mgr\<DATABASE>\RecentCubeEvents.txt, depending on where you have chosen to locate this database.

The "Cube" filter applies to the Average Facts Updated By Date and Average Fact Count By Date widgets. The data displayed in those widgets will be limited to records associated with the cube(s) selected in this filter. Each time you load the dashboard, this filter's value defaults to the name of the cube with the most recent "Build" event in the Cube Event table. You can change this default by editing this widget in the Navigator panel, selecting the "Cube" filter control, and modifying the Default Value setting.

#### Last Data Update

This widget displays the data and time at which the CubeEventCube data was last updated. Data shown in the other widgets on this dashboard is expected to be up to date through the time shown.

#### Average Facts Updated by Date

For cube registry events on a given cube (selected in the "Cube" filter on the Controls widget) that have a given event type (selected in the "Cube Event" filter on this widget), this widget displays the mean number of facts updated per event on each day in the last 60 days that had one or more such events. If the selected event type is "Build", the chart will show the average number of facts built per build event on each day; if the selected event type is "Synch", the chart will show the average number of facts updated per synchronize event on each day.

#### Average Fact Count by Date

For cube registry events on a given cube (selected in the "Cube" filter on the Controls widget), this widget displays the mean fact count reported by events on each day in the last 60 days that had one or more such events. The fact count reported by each cube event is the total number of facts in the cube at the end of the event. 

For build events, the fact count and number of facts updated should match, as all facts will be updated during a cube build. For synchronize events, only a subset of facts may be updated by each event, and these two values may therefore be different.

#### Average Total Time by Date

For cube registry events on a given cube (selected in the "Cube" filter on the Controls widget) that have a given event type (selected in the "Cube Event" filter on this widget), this widget displays the mean total time per event on each day in the last 60 days that had one or more such events.

#### Cube Events by Date and Status

For cube registry events on a given cube (selected in the "Cube" filter on the Controls widget), this widget displays the number of events with a success status (with green markers) and the number of events with a failure status (with red markers) on each day in the last 60 days that had one or more such events. You may optionally filter this widget by the cube event type.

### The Recent Cube Events Dashboard

The Recent Cube Events Dashboard displays details about recent cube events in this namespace. It has the following widgets:

#### Controls

This widget displays links to related dashboards, as well as a filter control that can be used to filter the Latest Build Events and Latest Synch Events widgets by cube name.

#### Recent Cube Event Errors

If there have been any cube event errors in the past seven days, this widget will display the message 'Click "View Recent Cube Event Errors" for details'. If there have not been any cube event errors in the past seven days, this widget will display the message 'No Cube Manager event errors in the last week'.

#### Last Data Update

This widget displays the data and time at which the CubeEventCube data was last updated. Data shown in the other widgets on this dashboard is expected to be up to date through the time shown.

#### Latest Build Events

For each cube in the namespace, this widget displays information (currently, the build start time and the number of build errors) from the most recent time that the cube was built via the Cube Registry. Keep in mind that this widget uses the CubeEvents cube as its data source; therefore, it only displays events that had occurred the last time the data in the CubeEvents cube was updated. 

#### Latest Synch Events

For each cube in the namespace, this widget displays information (currently, the synch start time and the number of build errors) from the most recent time that the cube was synchronized via the Cube Registry. Keep in mind that this widget uses the CubeEvents cube as its data source; therefore, it only displays events that had occurred the last time the data in the CubeEvents cube was updated.

### The Recent Cube Event Errors Dashboard

This dashboard displays details of all cube registry events in the last seven days that exited with an error status. This may indicate that there were build errors, or that the cube event failed with a different error. The widget in this dashboard queries the %DeepSee_CubeManager.CubeEvent SQL table directly as its data source, so the data is expected to be up to date as of the time the dashboard was loaded.

### The Build Errors Dashboard

The Build Errors dashboard allows you to view information about errors that have occurred when processing individual records while building or synchronizing a DeepSee cube. There is documentation on build errors [here](https://cedocs.intersystems.com/latest/csp/docbook/DocBook.UI.Page.cls?KEY=D2MODEL_cube_build_errors). The dashboard has the following widgets:

#### Build Errors by Cube

This widget displays a table showing the number of build errors that currently exist for each cube (for cubes that have any build errors). You can select a row and click "Fix Build Errors"; this will run a custom action to call %DeepSee.Utils:%FixBuildErrors() for that cube. 

The output of %FixBuildErrors will be logged in a text file at \<databaseDirectory>/FixBuildErrors_\<startTimestamp>.txt, where \<databaseDirectory> is the directory containing the default database used for globals in this namespace. (This directory is often a subdirectory of \<install-dir>/mgr/, but may be in any location that was specified when creating or editing the database.) The text file will be readable any time after %FixBuildErrors() has started, with information on errors that have been processed so far. When %FixBuildErrors() has completed, a message at the end of the text file will read "%FixBuildErrors() finished at \<finishTimestamp>". After %FixBuildErrors() has completed, you can see whether the number of build errors for the cube was reduced by running the "Update Build Error Data" action described below. 

This widget also has controls to view a detail listing on one or more selected cells, which will show the full build error text for the first 1,000 errors in the selected cells; and to navigate to other related dashboards.

#### Last Data Update

This widget shows the last time that the data displayed in this dashboard was updated. You can click on "Update Build Error Data" to update this data by rebuilding the Build Errors Cube. Once the rebuild completes, the dashboard should auto-refresh with the new data, including the updated time at which the data was updated. If the Build Errors Cube is large, the other widgets on the dashboard may be temporarily unavailable while the cube is rebuilt.

#### Build Errors by Date

This widget shows a chart of current build errors in this namespace. If the time at which the build errors occurred has been logged (which is the case in InterSystems IRIS 2019.1.1 and later versions, or Caché or Ensemble 2018.1.3 and later versions), each column on the chart corresponds to a single day's build errors; within each column, the different cubes with build errors are shown in different colors. These colors and the cubes they correspond to are shown in the legend, but each cube is not guaranteed to be associated with the same color each time you load this dashboard. You can select a cube's build errors in a given column and view a detail listing on them. If there is no date information, a single column will be shown with all the current build errors.

#### Build Errors by Type

This widget shows a table that groups build errors in each cube by the beginning of their error text. You can select one or more cells and view a listing to see the full error text for the first 1,000 errors in the selected cells.
