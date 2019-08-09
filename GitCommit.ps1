<#
.SYNOPSIS
    Commits the created or updated objects to git
.DESCRIPTION
    Allows any changes to the SQL objects to get commited into the GIT master
.NOTES
    File Name      : GitCommit.ps1
    Author         : Shawn Rosewarne
    Prerequisite   : PowerShell V3 and Git Installed.
    MIT License 2019 - Shawn Rosewarne
.LINK
    uthini.com
.EXAMPLE
    Commit_Repo_Master "Commit Message" "Directory In GIT/"

#>
function Commit_Repo_Master
{
    Param
    (
        [Parameter(Mandatory=$false, Position=0)]
        [string] $CommitMessage,
        [Parameter(Mandatory=$false, Position=1)]
        [string] $TargetDir
    )

    git pull
    
    if(git status --porcelain |Where {$_ -match '^\?\?' -notmatch '^\?\?'}){
        $commitMsg ="Automated Commit Date:" + (Get-Date -Format "yyyyMMdd HH:mm")

        if($CommitMessage){ 
            $commitMsg = $CommitMessage + " - " + $commitMsg
        }

        if ($TargetDir) {
            git add ($TargetDir + "*.*")
        } else  {
            git add *.*
        }
        git commit -m $commitMsg
        git push
    } 
    else {
        Write-Host "tree is clean"
    }
}



