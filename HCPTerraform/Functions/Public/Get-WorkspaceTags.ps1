
[CmdletBinding()]
param (

    [Parameter(Mandatory = $true)]
    [string]$WorkspaceId,

    [Parameter(Mandatory = $true)]
    [string]$Token

)

begin {
    # Initialize any variables or state needed for the function
    $url = "https://app.terraform.io/api/v2/workspaces/$WorkspaceId/relationships/tags"
    $headers = @{
        "Authorization" = "Bearer $Token"
        "Content-Type"  = "application/vnd.api+json"
    }
}

process {

    $data = @()
    
    # Build the data array of tags
    foreach ($t in $Tag) {
        $data += [ordered]@{
            type = "tags"
            attributes    = [ordered]@{
                name      = $t
            }
        }
    }
    
    # Construct the JSON payload
    $payload = [ordered]@{
        data = $data
    }

    $jsonPayload = $payload | ConvertTo-Json -Depth 10

    # Send the POST request
    try {
        $response = Invoke-RestMethod -Uri $url -Method Get -Body $jsonPayload -ContentType "application/vnd.api+json" -Headers $headers
        
        Write-Output $response.data
        
    }
    catch {
        Write-Error "Failed to add team access for team $TeamId to workspace $workspaceID : $_"
    }
}

end {
    # Future Post Cleanups or Processes
}
