
[CmdletBinding()]
param (

    [Parameter(Mandatory = $true)]
    [string]$WorkspaceId,

    [Parameter(Mandatory = $true)]
    [string]$TeamId,

    [Parameter(Mandatory = $true)]
    [ValidateSet("read", "plan", "write", "admin", "custom")]
    [string]$Access,

    [Parameter(Mandatory = $true)]
    [string]$Token

)

begin {
    # Initialize any variables or state needed for the function
    $url = "https://app.terraform.io/api/v2/team-workspaces"
    $headers = @{
        "Authorization" = "Bearer $Token"
        "Content-Type"  = "application/vnd.api+json"
    }
}

process {
    # Construct the JSON payload
    $payload = [ordered]@{
        data = [ordered]@{
            type          = "team-workspaces"
            attributes    = [ordered]@{
                access      = $Access
            }
            relationships = [ordered]@{
                workspace = [ordered]@{
                    data = [ordered]@{
                        id   = $WorkspaceId
                        type = "workspaces"
                    }
                }
                team = [ordered]@{
                    data = [ordered]@{
                        id   = $TeamId
                        type = "teams"
                    }
                }
            }
        }
    }

    $jsonPayload = $payload | ConvertTo-Json -Depth 10

    # Send the POST request
    try {
        $response = Invoke-RestMethod -Uri $url -Method Post -Body $jsonPayload -ContentType "application/vnd.api+json" -Headers $headers
        
        Write-Output $response.data
        
    }
    catch {
        Write-Error "Failed to add team access for team $TeamId to workspace $workspaceID : $_"
    }
}

end {
    # Future Post Cleanups or Processes
}
