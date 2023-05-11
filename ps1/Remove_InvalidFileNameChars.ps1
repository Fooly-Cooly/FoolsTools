﻿<#PSScriptInfo

.VERSION 1.4

.GUID fb77c199-25b8-4a26-ad12-300aa633d9ee

.AUTHOR Chris Carter

.COMPANYNAME 

.COPYRIGHT 2016 Chris Carter

.TAGS RegularExpression StringFormatting InvalidFileNameCharacters

.LICENSEURI http://creativecommons.org/licenses/by-sa/4.0/

.PROJECTURI https://gallery.technet.microsoft.com/Remove-Invalid-Characters-39fa17b1

.ICONURI 

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS 

.EXTERNALSCRIPTDEPENDENCIES 

.RELEASENOTES 


#>

<#
.SYNOPSIS
Removes characters from a string that are not valid in Windows file names.

.DESCRIPTION
Remove-InvalidFileNameChars accepts a string and removes characters that are invalid in Windows file names.  It then outputs the cleaned string.  By default the space character is ignored, but can be included using the RemoveSpace parameter.

The Replacement parameter will replace the invalid characters with the specified string.

The Name parameter can also clean file paths. If the string begins with "\\" or a drive like "C:\", it will then treat the string as a file path and clean the strings between "\".  This has the side effect of removing the ability to actually remove the "\" character from strings since it will then be considered a divider.
.PARAMETER Name
Specifies the file name to strip of invalid characters.

.PARAMETER Replacement
Specifies the string to use as a replacement for the invalid characters.

.PARAMETER RemoveSpace
The RemoveSpace parameter will include the space character (U+0032) in the removal process.

.INPUTS
System.String
Remove-InvalidFileNameChars accepts System.String objects in the pipeline.

Remove-InvalidFileNameChars accepts System.String objects in a property Name from objects in the pipeline.

.OUTPUTS
System.String

.EXAMPLE
PS C:\> Remove-InvalidFileNameChars -Name "<This /name \is* an :illegal ?filename>.txt"
Output: This name is an illegal filename.txt

This command will strip the invalid characters from the string and output a clean string.
.EXAMPLE
PS C:\> Remove-InvalidFileNameChars -Name "<This /name \is* an :illegal ?filename>.txt" -RemoveSpace
Output: Thisnameisanillegalfilename.txt

This command will strip the invalid characters from the string and output a clean string, removing the space character (U+0032) as well.
.EXAMPLE
PS C:\> Remove-InvalidFileNameChars -Name '\\Path/:|?*<\With:*?>\:Illegal /Characters>?*.txt"'
Output: \\Path\With\Illegal Characters.txt

This command will strip the invalid characters from the path and output a valid path. Note: it would not be able to remove the "\" character.
.EXAMPLE
PS C:\> Remove-InvalidFileNameChars -Name '\\Path/:|?*<\With:*?>\:Illegal /Characters>?*.txt"' -RemoveSpace
Output: \\Path\With\IllegalCharacters.txt

This command will strip the invalid characters from the path and output a valid path, also removing the space character (U+0032) as well. Note: it would not be able to remove the "\" character.
.EXAMPLE
PS C:\> Remove-InvalidFileNameChars -Name "<This /name \is* an :illegal ?filename>.txt" -Replacement +
Output: +This +name +is+ an +illegal +filename+.txt

This command will strip the invalid characters from the string, replacing them with a "+", and outputting the result string.
.NOTES
Author:  Chris Carter
Version: 1.3
Last Updated: January 6, 2016

.Link
System.RegEx
.Link
about_Join
.Link
about_Operators
#>

#Requires -Version 2.0
[CmdletBinding(HelpURI='https://gallery.technet.microsoft.com/scriptcenter/Remove-Invalid-Characters-39fa17b1')]

Param(
    [Parameter(Mandatory=$true,Position=0,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
        [String[]]$Name,

    [Parameter(Position=1)]
        [String]$Replacement='',

    [switch]$RemoveSpace
)

Begin {
    #Get an array of invalid characters
    $arrInvalidChars = [System.IO.Path]::GetInvalidFileNameChars()

    #Cast into a string. This will include the space character
    $invalidCharsWithSpace = [RegEx]::Escape([String]$arrInvalidChars)

    #Join into a string. This will not include the space character
    $invalidCharsNoSpace = [RegEx]::Escape(-join $arrInvalidChars)

    #Check that the Replacement does not have invalid characters itself
    if ($RemoveSpace) {
        if ($Replacement -match "[$invalidCharsWithSpace]") {
            Write-Error "The replacement string also contains invalid filename characters."; exit
        }
    }
    else {
        if ($Replacement -match "[$invalidCharsNoSpace]") {
            Write-Error "The replacement string also contains invalid filename characters."; exit
        }
    }

    Function Remove-Chars($String) {
        #Replace the invalid characters with a blank string(removal) or the replacement value
        #Perform replacement based on whether spaces are desired or not
        if ($RemoveSpace) {
            [RegEx]::Replace($String, "[$invalidCharsWithSpace]", $Replacement)
        }
        else {
            [RegEx]::Replace($String, "[$invalidCharsNoSpace]", $Replacement)
        }
    }        
}

Process {
    foreach ($n in $Name) {
        #Check if the string matches a valid path
        if ($n -match '(?<start>^[a-zA-z]:\\|^\\\\)(?<path>(?:[^\\]+\\)+)(?<file>[^\\]+)$') {
            #Split the path into separate directories
            $path = $Matches.path -split '\\'

            #This will remove any empty elements after the split, eg. double slashes "\\"
            $path = $path | Where-Object {$_}
            #Add the filename to the array
            $path += $Matches.file

            #Send each part of the path, except the start, to the removal function
            $cleanPaths = foreach ($p in $path) {
                              Remove-Chars -String $p
                          }
            #Remove any blank elements left after removal.
            $cleanPaths = $cleanPaths | Where-Object {$_}
            
            #Combine the path together again
            $Matches.start + ($cleanPaths -join '\')
        }
        else {
            #String is not a path, so send immediately to the removal function
            Remove-Chars -String $Name
        }
    }
}
