$ErrorActionPreference = 'Stop'

$comfyRoot = Split-Path -Parent $PSScriptRoot
$managerConfigDir = Join-Path $comfyRoot 'ComfyUI/user/__manager'
$managerConfigPath = Join-Path $managerConfigDir 'config.ini'

New-Item -ItemType Directory -Path $managerConfigDir -Force | Out-Null

function Get-IniContent($filePath) {
    $ini = @{}
    $section = $null

    switch -regex -file $filePath {
        '^\[(.+)\]' {
            $section = $matches[1]
            if (-not $ini.ContainsKey($section)) {
                $ini[$section] = @{}
            }
        }
        '^(;.*)$' {
            if ($null -ne $section) {
                $ini[$section][';comment'] = $matches[1]
            }
        }
        '(.+?)\s*=(.*)' {
            if ($null -ne $section) {
                $name, $value = $matches[1..2]
                $ini[$section][$name.Trim()] = $value.Trim()
            }
        }
    }

    return $ini
}

function Write-IniContent($filePath, $ini) {
    $lines = New-Object System.Collections.Generic.List[string]

    foreach ($sectionName in $ini.Keys) {
        $lines.Add("[$sectionName]")

        foreach ($key in $ini[$sectionName].Keys) {
            if ($key -like ';*') { continue }
            $lines.Add("$key = $($ini[$sectionName][$key])")
        }

        $lines.Add('')
    }

    if ($lines.Count -gt 0) {
        $lines.RemoveAt($lines.Count - 1)
    }

    $lines | Set-Content -Path $filePath -Encoding UTF8
}

$iniContent = if (Test-Path $managerConfigPath) { Get-IniContent -filePath $managerConfigPath } else { @{} }

if (-not $iniContent.ContainsKey('default')) {
    $iniContent['default'] = @{}
}

$iniContent['default']['security_level'] = 'normal'
Write-IniContent -filePath $managerConfigPath -ini $iniContent

$iniContent['default']['allow_git_url_install'] = 'true'
Write-IniContent -filePath $managerConfigPath -ini $iniContent

Write-Host "Updated $managerConfigPath"
Write-Host "Security level set to normal"