#Input params for the script
param(
	[Parameter(Mandatory=$true)]
	[string]$name
)

#Global vars that can be shared across functions
$global:templatePath = ""
$global:destinationPath = ""

#Function definitions
#Create a copy of the folder and files within it
function CopyTemplate()
{	
	$currentDir = (Get-Item -Path ".\" -Verbose).FullName
	$global:templatePath = $currentDir + "\template\www"	
	$global:destinationPath = $currentDir + "\newtemplate"	

	

	$checkDest = Test-Path -PathType Container $global:destinationPath
	if ($checkDest -eq $false) {
		Write-Host "Folder structure not found. Creating one"
		md $global:destinationPath	
		
		Copy-Item $global:templatePath $global:destinationPath -recurse
	}
	else
	{
		Write-Host "Folder structure found."
	}
}

#Replaces the token {{Date}} with Today's date
function UpdateFile()
{
	#2000
	$todayDate = Get-Date
	$todayFormattedDate = $todayDate.ToShortDateString()
	$pathToIndex = $global:destinationPath + "\www\index.html"
	
	(gc $pathToIndex) -replace '{{Date}}', $todayFormattedDate | Out-File $pathToIndex
	(gc $pathToIndex) -replace '{{Name}}', $name | Out-File $pathToIndex
}


#Main execution
#Step 1 - Make a copy of the template folder
CopyTemplate

#Step 2 - Open Index.html and replace tokens
UpdateFile
	