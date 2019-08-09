<#
.SYNOPSIS
    Factory for Scripting and Versioning SQL Objects
.DESCRIPTION
    The following script is a facotry to generate sql objects to files and commit them to git repo and reporting on trace events for each changed file
.NOTES
    File Name      : SqlScriptObjects.ps1
    Author         : Shawn Rosewarne
    Prerequisite   : PowerShell V3 and Microsoft.SqlServer.SMO.
                        SqlScriptObjects.ps1
                        SqlTraceEvents.ps1
                        GitCommit.ps1

    MIT License 2019 - Shawn Rosewarne
.LINK
    uthini.com
.EXAMPLE
    Sql_Script_And_Version  "INSTANCENAME" @("DATABASE","DATABASE_TEST") @("Tables", "StoredProcedures", "Views", "UserDefinedFunctions") @("sys", "Information_Schema") "INSTANCENAME - (DATABASE, DATABASE_TEST)" "INSTANCENAME/"

#>
function Sql_Script_And_Version
{
    Param
    (
         [Parameter(Mandatory=$true, Position=0)]
         [string] $Instance,
         [Parameter(Mandatory=$true, Position=1)]
         [string[]] $Databases,
         [Parameter(Mandatory=$true, Position=2)]
         [string[]] $SqlObjects,
         [Parameter(Mandatory=$true, Position=3)]
         [string[]] $SqlSchemeExclude,
         [Parameter(Mandatory=$true, Position=4)]
         [string] $CommitMsg,
         [Parameter(Mandatory=$true, Position=5)]
         [string] $CommitDir
    )

    Sql_Script_Objects  $Instance $Databases $SqlObjects $SqlSchemeExclude
    Sql_Trace_Events $Instance $Databases 
    Commit_Repo_Master $CommitMsg $CommitDir
}