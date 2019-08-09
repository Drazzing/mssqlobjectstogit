<#
.SYNOPSIS
    The following function will script up SQL objects based on the filters passed in
.DESCRIPTION
    A detailed description of the function or script. This keyword can be
    used only once in each topic.
.NOTES
    File Name      : SqlScriptObjects.ps1
    Author         : Shawn Rosewarne
    Prerequisite   : PowerShell V3 and Microsoft.SqlServer.SMO.
    MIT License 2019 - Shawn Rosewarne
.LINK
    uthini.com   
.EXAMPLE
    Sql_Script_Objects "LHPDR001" @("Tables", "StoredProcedures", "Views", "UserDefinedFunctions") @("sys", "Information_Schema","dbo") @("Testndb","LH_DR_TEST")

#>
function Sql_Script_Objects
{
    Param
    (
         [Parameter(Mandatory=$true, Position=0)]
         [string] $Instance,
         [Parameter(Mandatory=$true, Position=1)]
         [string[]] $Databases,
         [Parameter(Mandatory=$true, Position=2)]
         [string[]] $IncludeTypes,
         [Parameter(Mandatory=$true, Position=3)]
         [string[]] $ExcludeSchemas
        
    )


    [System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SMO')

    $serverInstance = New-Object ('Microsoft.SqlServer.Management.Smo.Server') $Instance
    $path =$PSScriptRoot + "\" + $Instance + "\"
    
    
    $so = new-object ('Microsoft.SqlServer.Management.Smo.ScriptingOptions')
    $so.IncludeIfNotExists = $false
    $so.SchemaQualify = $true
    $so.AllowSystemObjects = $false
    $so.ScriptDrops = $false #Script Drop Objects
     
    $dbs = $serverInstance.Databases
    foreach ($db in $dbs)
    {
        $dbname = "$db".replace("[", "").replace("]", "")
        if($Databases -contains $dbname)
        {
            $dbpath = "$path" + "$dbname" + "\"
            if (!(Test-Path $dbpath))
            { $null = new-item -type directory -name "$dbname" -path "$path" }
        
                foreach ($Type in $IncludeTypes)
                {
                    $objpath = "$dbpath" + "$Type" + "\"
                    if (!(Test-Path $objpath))
                    { $null = new-item -type directory -name "$Type" -path "$dbpath" }
                    foreach ($objs in $db.$Type)
                    {
                        If ($ExcludeSchemas -notcontains $objs.Schema)
                        {
                            $ObjName = "$objs".replace("[", "").replace("]", "")
                            $OutFile = "$objpath" + "$ObjName" + ".sql"
                            $scriptedObject = $objs.Script($so)
                            if($scriptedObject){
                                $scriptedObject + "GO" | out-File $OutFile #-Append
                            }
                            
                        }
                    }
                }
           
        }       
    }

}

