<#
Code generated by Microsoft (R) PSSwagger 0.3.0
Changes may cause incorrect behavior and will be lost if the code is regenerated.
#>

<#
.SYNOPSIS
    

.DESCRIPTION
    

.PARAMETER Destination
    

.PARAMETER Source
    

#>
function New-Office365GroupMappingContentObject
{
    param(    
        [Parameter(Mandatory = $true)]
        [AvePoint.PowerShell.FLYMigration.Models.Office365GroupModel]
        $Destination,
    
        [Parameter(Mandatory = $true)]
        [AvePoint.PowerShell.FLYMigration.Models.Office365GroupModel]
        $Source
    )
    
    $Object = New-Object -TypeName AvePoint.PowerShell.FLYMigration.Models.Office365GroupMappingContentModel

    $PSBoundParameters.GetEnumerator() | ForEach-Object { 
        if(Get-Member -InputObject $Object -Name $_.Key -MemberType Property)
        {
            $Object.$($_.Key) = $_.Value
        }
    }

    if(Get-Member -InputObject $Object -Name Validate -MemberType Method)
    {
        $Object.Validate()
    }

    return $Object
}
