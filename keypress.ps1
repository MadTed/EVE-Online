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
$ErrorActionPreference = "SilentlyContinue"

<#
.SYNOPSIS
Send a sequence of keys to an application window

.DESCRIPTION
This Send-Keys script send a sequence of keys to an application window.
To have more information about the key representation look at http://msdn.microsoft.com/en-us/library/System.Windows.Forms.SendKeys(v=vs.100).aspx
(C)2013 Massimo A. Santin - Use it at your own risk.

.PARAMETER ApplicationTitle
The title of the application window

.PARAMETER Keys
The sequence of keys to send

.PARAMETER WaitTime
An optional number of seconds to wait after the sending of the keys

.EXAMPLE
Send-Keys "foobar - Notepad" "Hello world"

Send the sequence of keys "Hello world" to the application titled "foobar - Notepad".

.EXAMPLE
Send-Keys "foobar - Notepad" "Hello world" -WaitTime 5

Send the sequence of keys "Hello world" to the application titled "foobar - Notepad" 
and wait 5 seconds.

.EXAMPLE 
    New-Item foobar.txt -ItemType File; notepad foobar.txt ; Send-Keys "foobar - Notepad" "Hello world{ENTER}Ciao mondo{ENTER}" -WaitTime 1; Send-Keys "foobar - Notepad" "^s"

This command sequence creates a new text file called foobar.txt, opens the file using a notepad,
writes some text and saves the file using notepad.

.LINK
http://msdn.microsoft.com/en-us/library/System.Windows.Forms.SendKeys(v=vs.100).aspx
#>

<# param (
    [Parameter(Mandatory=$True,Position=1)]
    [string]
    $ApplicationTitle,

    [Parameter(Mandatory=$True,Position=2)]
    [string]
    $Keys,

    [Parameter(Mandatory=$false)]
    [int] $WaitTime
    ) #>

# Eve-Online Window
$ApplicationTitle = "EVE - Lizzy6"
# what key to push
$Keys = " " # D-SCAN
# how long to wait in [s]
$wait = 6



# load assembly cotaining class System.Windows.Forms.SendKeys
[void] [Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
#Add-Type -AssemblyName System.Windows.Forms

# add a C# class to access the WIN32 API SetForegroundWindow
Add-Type @"
    using System;
    using System.Runtime.InteropServices;
    public class StartActivateProgramClass {
        [DllImport("user32.dll")]
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool SetForegroundWindow(IntPtr hWnd);
    }
"@

do {

	Write "========================================"
	Write-Host -NoNewline "simulating key press at "(Get-Date).ToString("HH:mm:ss") 
	Write " "
	Write "is the EVE window open?"
	
	# get the applications with the specified title
	$p = Get-Process | Where-Object { $_.MainWindowTitle -eq $ApplicationTitle }
	if ($p) 
	{
		# get the window handle of the first application
		$h = $p[0].MainWindowHandle
		# set the application to foreground
		[void] [StartActivateProgramClass]::SetForegroundWindow($h)

		# send the keys sequence
		# more info on MSDN at http://msdn.microsoft.com/en-us/library/System.Windows.Forms.SendKeys(v=vs.100).aspx
		
		Write "now pressing key [$Keys] ..."
		[System.Windows.Forms.SendKeys]::SendWait($Keys)
		Write "."
	}
	
	Start-Sleep $wait

} while (1) # endlos-schleife
	



