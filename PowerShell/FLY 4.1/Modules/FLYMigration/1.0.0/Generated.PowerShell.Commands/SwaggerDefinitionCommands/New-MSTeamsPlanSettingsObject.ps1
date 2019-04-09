<#
Code generated by Microsoft (R) PSSwagger 0.3.0
Changes may cause incorrect behavior and will be lost if the code is regenerated.
#>

<#
.SYNOPSIS
    

.DESCRIPTION
    

.PARAMETER DurationUnit
    the duration unit to migrate conversations within a specific period, default value is 'Day'

.PARAMETER PolicyId
    the id of migration policy

.PARAMETER MigrateConversations
    Whether to migrate Teams conversations

.PARAMETER Schedule
    the schedule for the migration

.PARAMETER OnlyMigrateDocumentsLibrary
    Whether to migrate only document libraries for the source team in the migration

.PARAMETER NameLabel
    Large migration projects are often phased over several waves, each containing multiple plans. 
To easily generate migration reports for each project or wave, we recommend the Example name format Business Unit_Wave_Plan

.PARAMETER DatabaseId
    the id of migration database

.PARAMETER Duration
    Migrate conversations within the last [x] days or months, default value is 12

#>
function New-MSTeamsPlanSettingsObject
{
    param(    
        [Parameter(Mandatory = $false)]
        [ValidateSet('Day', 'Month')]
        [string]
        $DurationUnit,
    
        [Parameter(Mandatory = $false)]
        [string]
        $PolicyId,
    
        [Parameter(Mandatory = $false)]
        [switch]
        $MigrateConversations,
    
        [Parameter(Mandatory = $false)]
        [AvePoint.PowerShell.FLYMigration.Models.ScheduleModel]
        $Schedule,
    
        [Parameter(Mandatory = $false)]
        [switch]
        $OnlyMigrateDocumentsLibrary,
    
        [Parameter(Mandatory = $true)]
        [AvePoint.PowerShell.FLYMigration.Models.PlanNameLabel]
        $NameLabel,
    
        [Parameter(Mandatory = $false)]
        [string]
        $DatabaseId,
    
        [Parameter(Mandatory = $false)]
        [int32]
        $Duration
    )
    
    $Object = New-Object -TypeName AvePoint.PowerShell.FLYMigration.Models.MSTeamsPlanSettingsModel

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
