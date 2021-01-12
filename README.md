# Cube Event Monitor

The Cube Event Monitor tool provides dashboards to allow you to monitor events (such as building and synchronizing cubes) run from the Cube Registry on your system, as well as to monitor and fix build errors in your cubes.

## Setup:

1. Import all classes and DFI files into the namespace where you want to use the Cube Event Monitor

2. Compile CubeEventMonitor.CubeEventCube.cls

3. In Terminal, go to the namespace where you imported the classes and run
	
	write ##class(CubeEventMonitor.CubeEventCube).Setup(\<compileFlags>,\<buildCubes>,\<updateInterval>,\<folderItemResource>,\<alertRecipient>)

4. If you specified an alertRecipient in the Setup() method, go to System Administration -> Configuration -> Additional Settings -> Task Manager Email in the Management Portal and ensure that the SMTP Server, Port, and Sender settings are configured

In step 3, the parameters you can set are as follows:

- compileFlags As %String = "": flags to be used when compiling the CubeEventMonitor package

- buildCubes As %Boolean = "true": whether to build the CubeEvents and BuildErrors cubes. It is recommended to use the default on initial setup, but keep in mind that if there are already a large number of build errors or Cube Registry events in the namespace, this may increase the time needed for the setup method to complete by several minutes or more, and may consume significant system resources during that time

- updateInterval As %Integer = 60: interval in minutes on which to update the data in the CubeEvents cube (minimum 5, maximum 720)

- folderItemResource As %String = "%DeepSee_Admin": resource to be applied to the pivots and dashboards imported as part of this tool. If you specify a custom resource, please ensure that it exists and is granted to the appropriate roles

- alertRecipient As %String = "": email address (of the form "recipient@example.com") to which this tool will send alerts. If an email address is specified, a task will be set up to send an alert at 6 am every day if there have been cube events with errors since the task was last run, or if any build errors have ever been logged for any cube in the namespace and not yet fixed

Additional notes on setup:

- The BuildErrorsCube and CubeEvents cubes will be added to the existing active cube registry, if there is one - if there is not, one will be created at DeepSee.CubeManager.CubeRegistryDefinition

- By default, these cubes will be rebuilt nightly. This setting can be changed from the Cube Registry interface in the Management Portal after the Setup() method completes

- If you specify %Development as the folderItemResource when running the Setup() method, it will also be used as the resource for the cubes. Otherwise, %DeepSee_Admin will be used as the cube resource. When installing this application via ZPM, %Development will be used as the resource, to allow the application to be used with the predefined %Developer role 

## Security:

The CubeEventCube and BuildErrors cube are both secured with the %DeepSee_Admin resource (or with the %Development resource if you specified it as the folderItemResource - see note above). If you prefer to use a different resource, you can edit this for each cube from the Architect after running CubeEventMonitor.CubeEventCube:Setup(). If you edit a cube's resource, you should recompile it, but it is not necessary to rebuild it.

The CubeEvents and BuildErrors folders are secured with the resource you specified when running CubeEventMonitor.CubeEventCube:Setup() - see the Setup section above. The default resource for these folders is %DeepSee_Admin. A resource applied to a folder applies to all pivots and dashboards in that folder.

## Dashboards:

Once you have run the Setup() method, you can view the dashboards imported as part of this tool from the User Portal in the namespace where you imported them. The default web application for this namespace must be Analytics-enabled in order to view the User Portal. There are four dashboards:

- BuildErrors/BuildErrorsDashboard, which displays information about errors that occurred when processing individual records while building or synchronizing a cube, and allows you to try re-processing the affected records

- CubeEvents/CubeManagerDashboard, which displays aggregate informtion about events that have been run from the Cube Registry, such as cube builds or synchronization

- CubeEvents/Recent Cube Events, which displays details about the most recent build and synchronize event run from the Cube Registry for each cube in this namespace

- CubeEvents/Recent Cube Event Errors, which displays details about any events run from the Cube Registry in the past seven days that encountered errors
	
Detailed documentation on each dashboard is available in documentation.md.
