
[CmdletBinding()]
param (
    [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [string]$WorkspaceId,

    [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [string]$ApiToken
)

begin {
    $url = "https://app.terraform.io/api/v2/workspaces/$WorkspaceId/current-state-version-outputs"

    $headers = @{
        "Authorization" = "Bearer $ApiToken"
        "Content-Type"  = "application/vnd.api+json"
    }

}

process {
    try {
        $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers
        Write-Output $response.data
    }
    catch {
        Write-Error "Failed to retrieve workspace outputs: $_"
    }
}
