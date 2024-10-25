
[CmdletBinding()]
param (
    [Parameter(Mandatory = $false)]
    [string]$ModuleId,

    [Parameter(Mandatory = $true)]
    [string]$WorkspaceName,

    [Parameter(Mandatory = $true)]
    [string]$Description,

    [Parameter(Mandatory = $false)]
    [string]$ProjectId,

    [Parameter(Mandatory = $true)]
    [array]$Vars,

    [array]$Tags,

    [Parameter(Mandatory = $true)]
    [string]$Token,

    [Parameter(Mandatory = $true)]
    [bool]$autoApply
)

begin {
    # Initialize any variables or state needed for the function
    $url = "https://app.terraform.io/api/v2/no-code-modules/$ModuleId/workspaces"
    $headers = @{
        "Authorization" = "Bearer $Token"
        "Content-Type"  = "application/vnd.api+json"
    }
}

process {
    # Construct the JSON payload
    $payload = [ordered]@{
        data = [ordered]@{
            type          = "workspaces"
            attributes    = [ordered]@{
                name        = $WorkspaceName
                description = $Description
                auto_apply  = $autoApply
            }
            relationships = [ordered]@{
                project = [ordered]@{
                    data = [ordered]@{
                        id   = $ProjectId
                        type = "project"
                    }
                }
                vars    = [ordered]@{
                    data = $Vars
                }
            }
        }
    }

    $jsonPayload = $payload | ConvertTo-Json -Depth 10

    Write-Host "`n`nJSONPayload: $jsonPayload`n`n"

    # Send the POST request
    try {
        $response = Invoke-RestMethod -Uri $url -Method Post -Body $jsonPayload -ContentType "application/vnd.api+json" -Headers $headers
        Write-Host "Workspace created successfully: $($response.data.id)`nView In Terraform Cloud: https://app.terraform.io$($response.data.links.'self-html')`n`n"
        
        Write-Output $response.data
        
    }
    catch {
        Write-Error "Failed to create workspace: $_"
    }
}

end {
    # Future Post Cleanups or Processes
}
