# windows power shell script um alle 5s eine Taste zu drücken
# 
# quick and dirty # mad666ted @ 12/2018
# open source: use this in any way you want, just mention mad666ted
#####################################################################

Write "=============================="
Write "."
Write-Host -NoNewline "start [keypress.ps1] at "(Get-Date).ToString("HH:mm:ss") 
Write " "
Write "."

# Fehler- und Warnhinweise nicht anzeigen; zum Debuggen ausschalten
# $ErrorActionPreference = "SilentlyContinue"

# endlos schleife
do {

	Write-Host -NoNewline (Get-Date).ToString("HH:mm:ss") 
	Write " "
	Write "now pressing [v]"
	[System.Windows.Forms.SendKeys]::SendWait("y")
	Write "."
	Start-Sleep 5
	
} while (1) # dauerschleife

# just to be clean
exit


