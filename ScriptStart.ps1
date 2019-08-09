<#
.SYNOPSIS
    Initialisation point for scripting and version controlling SCRIPTS
.DESCRIPTION
    You can put multiple database instances into the start script. 
.NOTES
    File Name      : ScriptStart.ps1
    Author         : Shawn Rosewarne
    Prerequisite   : PowerShell and Git
    Included File  : SqlScriptObjects.ps1
                     SqlTraceEvents.ps1
                     GitCommit.ps1
                     Common.Utils.ps1
                     SqlScriptAndVersion.ps1
    MIT License 2019 
.LINK
    uthini.com
.EXAMPLE
    Sql_Script_And_Version  "INSTANCENAME" @("DATABASENAME", "DATABASENAME_Test") @("Tables", "StoredProcedures", "Views", "UserDefinedFunctions") @("sys", "Information_Schema")  "INSTANCENAME - (DATABASENAME, DATABASENAME_Test)" "COMMIT DIR/"
#>

. .\SqlScriptObjects.ps1
. .\SqlTraceEvents.ps1
. .\GitCommit.ps1
. .\Common.Utils.ps1
. .\SqlScriptAndVersion.ps1

$LogfileLocation = $PSScriptRoot + "\Logs\SQL Script Objects {0}.log" -f (get-date -Format "yyyy-MM-dd")

LogWrite  $LogfileLocation "-------------Starting Scripts--------------"

try {
    LogWrite  $LogfileLocation "Starting INSTANCENAME - (DATABASENAME, DATABASENAME_Test) Object Scripts"
    #REPLACE WITH YOUR VARIABLES
    #Sql_Script_And_Version  "INSTANCENAME" @("DATABASENAME", "DATABASENAME_Test") @("Tables", "StoredProcedures", "Views", "UserDefinedFunctions") @("sys", "Information_Schema")  "INSTANCENAME - (DATABASENAME, DATABASENAME_Test)" "COMMIT DIR/"
    LogWrite  $LogfileLocation "Ended INSTANCENAME - (DATABASENAME, DATABASENAME_Test) Object Scripts"
}
catch {
    LogWrite  $LogfileLocation $_.Exception
}

LogWrite  $LogfileLocation "-------------Ended Scripts--------------"


