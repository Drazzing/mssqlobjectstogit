# Change Tracking of MS SQL Objects

The following scripts will help automate and track changes within your MS SQL Instances accross developement teams. It will give you a version history over time of what happen to each object.

It can be a nice starting point in getting your classic development teams using automated DevOpps practices.

The solution will answer the following two questions over time without buying expensive thirdparty tools:

- Changes to MS SQL Objects over time
- Report that shows who Added / Deleted / Changed objects over time

### Prerequisites

- [SQL Server Management Studio](https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms) - Used to script MS SQL Objects
- [GIT](https://git-scm.com/downloads) - Install GIT
- [Powershell](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell) - Make sure at least Powershell Version 3 is on the machine

## Getting Started

Install / Confirm prerequisites on the host enviroment

### Account Access

The account running the ScriptStart.ps1 needs access to the following

- Read / Write Access on the file system
- Read Access on the SQL Databases
- Commit Access to Git Repo

### Edit the ScriptStart.ps1

Sql_Script_And_Version "INSTANCENAME" @("DATABASENAME", "DATABASENAME_Test") @("Tables", "StoredProcedures", "Views", "UserDefinedFunctions") @("sys", "Information_Schema") "INSTANCENAME - (DATABASENAME, DATABASENAME_Test)" "COMMIT DIR/"

[Parameter(Mandatory=\$true, Position=0)][string] $Instance,
[Parameter(Mandatory=$true, Position=1)]
[string[]] $Databases,
[Parameter(Mandatory=$true, Position=2)]
[string[]] $SqlObjects,
[Parameter(Mandatory=$true, Position=3)]
[string[]] $SqlSchemeExclude,
[Parameter(Mandatory=$true, Position=4)]
[string] $CommitMsg,
[Parameter(Mandatory=$true, Position=5)]
[string] \$CommitDir

### Schedule the powershell to run

Schedule the [ScriptStart.ps1](ScriptStart.ps1) to run at set intervals as required.

If you want to use windows task scheduler.

- [Windows Task Scheduler](https://docs.microsoft.com/en-us/windows/win32/taskschd/task-scheduler-start-page)
- [Windows Task Scheduler - Powershell](https://social.technet.microsoft.com/wiki/contents/articles/38580.configure-to-run-a-powershell-script-into-task-scheduler.aspx)

### Logs

Logs are written to /Logs folders and not committed to git to reduce the amount of noise

## Future Enhancements

- Marry up commits to change report
- Externalise the function "Sql_Script_And_Version" in the ScriptStart file to pull information from another datasource and loop over a dataset of database instances

## Built With

- [VsCode](https://code.visualstudio.com/)

## Contributing

Please read [CONTRIBUTING.md](https://github.com/Drazzing/mssqlobjectstogit/blob/master/CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests to me.

## Authors

- **Shawn Rosewarne** - _Initial work_ - [Drazzing](https://github.com/Drazzing)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

- [PurpleBooth](https://github.com/PurpleBooth) Help with the Readme and Contribution files structure
