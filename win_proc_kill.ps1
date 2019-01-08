# windows power shell script um ungeliebte windows prozesse zu killen
# und bei bestimmten prozessen die Priorität neu zu setzen
# quick and dirty # mad666ted @ 12/2018
# open source: use this in any way you want, just mention mad666ted
#####################################################################
Write "."
Write-Host -NoNewline "start [win_proc_kill.ps1] at "(Get-Date).ToString("HH:mm:ss") 
Write " "
Write "."
#----------------------------------------------------------
# Fehler- und Warnhinweise nicht anzeigen; zum Debuggen ausschalten
$ErrorActionPreference = "SilentlyContinue"
$pname = @()
#----------------------------------------------------------
# Funktion zum Prozess-Prio setzen
Function Set-PSPriority { 
	param( 
		[ValidateRange(-2,3)]
		[Parameter(Mandatory=$true)]
		[int]$priority,
		[int]$processID = $pid,
		[switch]$silent
	)
	
	$priorityhash=@{-2="Idle"; -1="BelowNormal"; 0="Normal"; 1="AboveNormal";
						2="High"; 3="RealTime"} 

	(Get-Process -Id $processID).priorityclass = $priorityhash[$priority]
	Start-Sleep 1 # einfach mal 'ne sekunde warten ...
	
	if (! $silent) {
		Write-Host -NoNewline "Process ID [$processID] is now set to ["(Get-Process -Id $processID).priorityclass"]"
		Write " "
		Write "------------------"
	} 
} 

#----------------------------------------------------------
# endlos schleife
do {

Write "===================================================================="
Write-Host -NoNewline "next round at "(Get-Date).ToString("HH:mm:ss") 
Write " "
Write "."

# erstmal prozess prioritäten setzen
Write "adjusting processes prio's ..."
Write "."
#----------------------------------------------------------
$pname = @()
# -1="BelowNormal"
# Liste der Prozess-Namen (wie im Task-Manager unter Details, ohne ".exe")
# "waterfox", "Keepass", 
$pname = @("SearchUI", "spoolsv", "Taskmgr", "TeraCopyService", "VeraCrypt", "thunderbird", 
			"CCleaner64", "smartscreen", "unsecapp", "Windows10FirewallControl",
			"RtkNGUI64", "Discord", "ts3client_win64", "evelauncher", "LogLite", "bitcoin-qt", 
			"litecoin-qt", "monerod", "parity", "wmplayer", "Windows10FirewallService", 
			"ApplicationFrameHost", "nxt", "qtum-qt", "MyDefrag")
			
Get-Process -Name $pname | ForEach-Object -Process {
			Write "trying to set process [$_] to prio [BelowNormal]:"
			Set-PSPriority -priority -1 -process $_.ID 
	}
#----------------------------------------------------------
$pname = @()
# 2="High"
# Liste der Prozess-Namen (wie im Task-Manager unter Details, ohne ".exe")
$pname = @("QtWebEngineProcess", "exefile", "obs64" )
Get-Process -Name $pname | ForEach-Object -Process {
			Write "trying to set process [$_] to prio [High]:"
			Set-PSPriority -priority 2 -process $_.ID 
	}

Write "."
Write-Host -NoNewline  "done at "(Get-Date).ToString("HH:mm:ss")
Write " "
Write "."	

# only for testing
# exit
#----------------------------------------------------------
# ungeliebte prozesse killen
Write "."
Write "now killing unwanted proc's"
Write "."
Write "getting processes ..."
Write "."
$pname = @()
# Liste der Prozess-Namen (wie im Task-Manager unter Details, ohne ".exe")
$pname = @("GoogleCrashHandler", "GoogleCrashHandler64", "neubotw", "YouCamService6", 
			"armsvc", "Video.UI", "ShellExperienceHost", "MSASCuiL", "BtwRSupportService",
			"DAVSRV", "googledrivesync", "GoogleUpdate", "LockApp", 
			"WindowsInternal.ComposableShell.Experiences.TextInput.InputApp" )

Get-Process -Name $pname | ForEach-Object -Process {
			Write "now killing process [$_]"
			Write "-------------------"
			Stop-Process -Id $_.ID -force
	}
#----------------------------------------------------------
Write "."
Write-Host -NoNewline  "done at "(Get-Date).ToString("HH:mm:ss")
Write " "
Write "now waiting for 666 s to start again ..."
Start-Sleep 666 # alle 666s
Write "."
Write "===================================================================="
Write " "
Write " "

} while (1) # dauerschleife
#----------------------------------------------------------
# just to be clean
exit


