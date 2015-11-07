param (
    [string]$part
    [switch]$help=$false
)
$fzp = [ xml] (Get-Content part\$part.fzp)
$views = $fzp.module.views
$icon_path = $views.iconView.layers.GetAttribute("image")
$breadboard_path = $views.breadboardView.layers.GetAttribute("image")
$schematic_path = $views.schematicView.layers.GetAttribute("image")
$pcb_path = $views.pcbView.layers.GetAttribute("image")
If (Test-Path $part) {Remove-Item $part -Recurse}
If (Test-Path "$part.fzpz") {Remove-Item "$part.fzpz"}
New-Item $part -type directory
$icon = Get-Item svg\$icon_path
$breadboard = Get-Item svg\$breadboard_path
$schematic = Get-Item svg\$schematic_path
$pcb = Get-Item svg\$pcb_path
Copy-Item part\$part.fzp -Destination $part\part.$part.fzp
Copy-Item $icon -Destination $part\svg.icon.$($icon.BaseName).svg
Copy-Item $breadboard -Destination $part\svg.breadboard.$($breadboard.BaseName).svg
Copy-Item $schematic -Destination $part\svg.schematic.$($schematic.BaseName).svg
Copy-Item $pcb -Destination $part\svg.pcb.$($pcb.BaseName).svg
Add-Type -assembly "system.io.compression.filesystem"
[io.compression.zipfile]::CreateFromDirectory("$pwd\$part", "$pwd\$part.fzpz")
Remove-Item $part -Recurse