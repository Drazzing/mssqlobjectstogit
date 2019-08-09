<#
.SYNOPSIS
    The following function will script a report that has trace events on SQL Object changes
.DESCRIPTION
    
.NOTES
    File Name      : SqlTraceEvents.ps1
    Author         : Shawn Rosewarne
    Prerequisite   : PowerShell V3 and Microsoft.SqlServer.SMO.
    MIT License 2019 - Shawn Rosewarne
.LINK
    uthini.com
.EXAMPLE
    Sql_Trace_Events "LHPDR001" @("Tables", "StoredProcedures", "Views", "UserDefinedFunctions")

#>
function Sql_Trace_Events
{
    Param
    (
         [Parameter(Mandatory=$true, Position=0)]
         [string] $Instance,
         [Parameter(Mandatory=$true, Position=1)]
         [string[]] $Databases
    )

    
        foreach ($Database in $Databases) {
            $connectionString = "Data Source=$Instance;Initial Catalog=$Database;Integrated Security=True" 
            $connection = New-Object System.Data.SqlClient.SqlConnection
            $connection.ConnectionString = $connectionString
            $connection.Open()
            $query = "SELECT gt.HostName,
            gt.ApplicationName, 
            gt.NTUserName, 
            gt.NTDomainName, 
            gt.LoginName, 
            gt.SPID, 
            gt.EventClass, 
            te.Name AS EventName,
            gt.EventSubClass,      
            gt.TEXTData, 
            gt.StartTime, 
            gt.EndTime, 
            gt.ObjectName, 
            gt.DatabaseName, 
            gt.FileName, 
            gt.IsSystem
            FROM [fn_trace_gettable]((SELECT SUBSTRING(path, 0, LEN(path)-CHARINDEX('\', REVERSE(path))+1) + '\Log.trc'  
            FROM sys.traces   
            WHERE is_default = 1), DEFAULT) gt 
            JOIN sys.trace_events te ON gt.EventClass = te.trace_event_id 
            WHERE 
            gt.DatabaseName = '"+ $Database + "'
            and  te.Name like 'Object:%'
			and gt.EventSubClass = 1
            ORDER BY StartTime DESC;"
            
            $command = $connection.CreateCommand()
            $command.CommandText = $query

            $SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
            $SqlAdapter.SelectCommand = $command
            $DataSet = New-Object System.Data.DataSet
            $SqlAdapter.Fill($DataSet)

            $reportPath = $PSScriptRoot + "\" + $Instance + "\" + $Database + "\TraceEvents\"
            #$reportName = (Get-Date -Format "ddMMyyyy_HHmm") +  "_"  + "Trace_Events_" + $Database + ".csv"
            $reportName = "Trace_Events_" + $Database + ".csv"

            if (!(Test-Path $reportPath))
            { $null = new-item -type directory -path $reportPath }

            if($DataSet.Tables){
                $DataSet.Tables[0] | Export-Csv ($reportPath + $reportName) -NoTypeInformation -Encoding UTF8
            }

            $connection.Close()

    }

}