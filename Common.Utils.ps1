<#
.SYNOPSIS
    Commom Utils
.DESCRIPTION
    A place to hold common utils
.NOTES
    File Name      : Common.Utils.ps1
    Author         : Shawn Rosewarne
    Prerequisite   : PowerShell
    MIT License 2019 - Shawn Rosewarne
.LINK
    uthini.com
.EXAMPLE
    LogWrite  $LogfileLocation "-------------Starting Scripts--------------"

#>

Function LogWrite
{
   Param ([string]$logLocation,
		   [string]$logstring)
		   
	if (!(Test-Path $logLocation))
	{
        if(!(Test-Path (Split-Path -Path $logLocation)))
        {
            $null = new-item -type directory -path (Split-Path -Path $logLocation)
        }
        $null = new-item -type file -path $logLocation
    }
   	Add-content $logLocation -value   ((get-date -Format "yyyy-MM-dd HH:mm:ss") + " - " + $logstring) 
}