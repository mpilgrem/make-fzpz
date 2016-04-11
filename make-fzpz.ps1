# make-fzpz
# Author: Mike Pilgrem

# Comment-based help

<#
.SYNOPSIS
 Creates a bundle (*.fzpz file) for a single Fritzing part.

.DESCRIPTION
 Creates a bundle (*.fzpz file) for a single Fritzing part. It assumes that the
 part's metadata (*.fzp file) is located in directory \part and the part's *.svg
 files are located in subdirectories of folder \svg. 

.PARAMETER part
 The name of the metadata (*.fzp) file for the part (excluding the extension).

.EXAMPLE
 make-fzpz bulb_holder
 Creates bulb_holder.fzpz from bulb_holder.fzp and the *.svg files it specifies.
#>

#Requires -Version 4

[CmdletBinding()]
param (
    [Parameter(Mandatory=$True, Position=1)]
    [string]$part
)

# Helper function for Yes-No choices
Function yesNo($title, $message, $yesMessage, $noMessage, [bool]$yesDefault) {
    $yes = New-Object System.Management.Automation.Host.ChoiceDescription `
        "&Yes", $yesMessage
    $no =  New-Object System.Management.Automation.Host.ChoiceDescription `
        "&No", $noMessage
    $options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, `
        $no)
    If ($yesDefault) {
        $host.ui.PromptForChoice($title, $message, $options, 0)
    }
    Else {
        $host.ui.PromptForChoice($title, $message, $options, 1)
    }  
}

# Arrays for four views and associated *.svg files
[string[]]$views = "icon", "breadboard", "schematic", "pcb"
$files = @()

# Check *.fzp exists in \part directory
[bool]$isError = $false
[string]$fzp = "part\$part.fzp"
If (Test-Path $fzp) {
    $xml = [xml](Get-Content $fzp)
    # Process XML. Note: The XML file content is assumed to be valid.
    $xmlViews = $xml.module.views
    ForEach ($view In $views) {
        If (!$isError) {
            $path = "svg\"+$xmlViews."$($view)View".layers.GetAttribute("image")        
            If (Test-Path $path) {
                $files += Get-Item $path
            }
            Else {
                Write-Host ("File $path was expected but does not exist." + `
                    " Terminating.") -ForegroundColor Red
                $isError = $true
            }
        }   
    }
}
Else {
    Write-Host "File $fzp was expected but does not exist. Terminating." `
        -ForegroundColor Red
    $isError = $true
}

# Check all is in order
ForEach ($path In $paths) {
    If (!$isError) {
        If (Test-Path $path) {
            $files += Get-Item $path
        }
        Else {
            Write-Host ("File $path was expected but does not exist." + `
                " Terminating.") -ForegroundColor Red
            $isError = $true
        }
    }
}

# Check *.fzpz does not already exist
[string]$fzpz = "$part.fzpz"
If (!$isError -and (Test-Path $fzpz)) {
    Switch (yesNo -title "Warning!" -message ("File $fzpz already exists. " + `
        "If you continue, it will be deleted. Do you want to continue?") `
        -yesMessage "make-fzpz will continue, deleting file $fzpz." -noMessage `
        "make-fzpz will terminate." -yesDefault $false)
    {
        0 {Remove-Item $fzpz}
        1 {
            $isError=$true
            Write-Host "Terminating." -ForegroundColor Red
          }
    }
}

# Check directory $part does not already exist
If (!$isError -and (Test-Path $part)) {
    If (1 -eq (yesNo -title "Warning!" -message ("Directory $part already " + `
        "exists. If you continue, it will be deleted. Do you want to " + `
        "continue?") -yesMessage ("make-fzpz will continue, deleting " + `
        "directory $part.") -noMessage "make-fzpz will terminate." -yesDefault `
        $false))
    {
        $isError=$true
        Write-Host "Terminating." -ForegroundColor Red
    }
}

If (!$isError) {
    # Create directory, overriding any existing $part, silently
    [void](New-Item $part -ItemType directory -Force)
    
    Copy-Item part\$part.fzp -Destination $part\part.$part.fzp
    For($i=0; $i -lt 4; $i++) {
        Copy-Item $files[$i] -Destination $part\svg.$($views[$i]).$($files[$i].BaseName).svg
    }
    Add-Type -assembly "system.io.compression.filesystem"
    [io.compression.zipfile]::CreateFromDirectory("$pwd\$part", "$pwd\$fzpz")
    Remove-Item $part\*.*
    Remove-Item $part
    Get-ChildItem $fzpz
}

<# -----------------------------------------------------------------------------
   Copyright (c) 2015, Mike Pilgrem
   All rights reserved.

   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions are met:

   1. Redistributions of source code must retain the above copyright notice,
      this list of conditions and the following disclaimer.

   2. Redistributions in binary form must reproduce the above copyright notice,
      this list of conditions and the following disclaimer in the documentation
      and/or other materials provided with the distribution.

   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
   AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
   IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
   ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
   LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
   CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
   SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
   INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
   CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
   ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   POSSIBILITY OF SUCH DAMAGE.
----------------------------------------------------------------------------- #>