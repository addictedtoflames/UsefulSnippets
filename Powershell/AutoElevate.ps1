# Test to see if script is running as admin and automatically elevate. Will show a prompt if UAC enabled. Will preserve any arguments and parameters


if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
	if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
		# Construct string of bound parameters
		$MyInvocation.BoundParameters.Keys | ForEach-Object {
			$paramString = $paramString + " -" + $_ + " " + $MyInvocation.BoundParameters.$_
		}
		# Construct full command line
		$CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $paramString + $MyInvocation.UnboundArguments
		Start-Process -FilePath PowerShell.exe -Verb RunAs -ArgumentList $CommandLine
		Exit
	}
}