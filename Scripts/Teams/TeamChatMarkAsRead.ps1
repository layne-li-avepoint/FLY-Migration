<# /********************************************************************
 *
 *  PROPRIETARY and CONFIDENTIAL
 *
 *  This file is licensed from, and is a trade secret of:
 *
 *                   AvePoint, Inc.
 *                   525 Washington Blvd, Suite 1400
 *                   Jersey City, NJ 07310
 *                   United States of America
 *                   Telephone: +1-201-793-1111
 *                   WWW: www.avepoint.com
 *
 *  Refer to your License Agreement for restrictions on use,
 *  duplication, or disclosure.
 *
 *  RESTRICTED RIGHTS LEGEND
 *
 *  Use, duplication, or disclosure by the Government is
 *  subject to restrictions as set forth in subdivision
 *  (c)(1)(ii) of the Rights in Technical Data and Computer
 *  Software clause at DFARS 252.227-7013 (Oct. 1988) and
 *  FAR 52.227-19 (C) (June 1987).
 *
 *  Copyright © 2017-2025 AvePoint® Inc. All Rights Reserved.
 *
 *  Unpublished - All rights reserved under the copyright laws of the United States.
 */ #>
#Install-Module Microsoft.Graph -Scope CurrentUser
<# function area #>
$debug = 'debug'
$warning = 'warning'
$info = 'info'
$green = "Green"
$red = "Red"
$definition = Split-Path -Parent $MyInvocation.MyCommand.Definition
$LogFile = -join ($definition, "\log\shell.log")
$date = Get-Date -Format "yy_MM_dd_HH_mm"
$ReportFile = -join ($definition,"\Report$date.csv")
$setLevel = $info;
function OutputMessage {
    param (
        [string]$level,
        [string]$colour
    )
    switch -wildcard ($colour)
    {
        'Green'{Write-Host $Message -ForegroundColor Green}
        default {
            switch -wildcard ($level)
            {
                'warning'{Write-Host $Message -ForegroundColor Yellow}
                'error' {Write-Host $Message -ForegroundColor Red}
                default {Write-Host $Message}
            }
        }
    }
    Write-Output "[$level] : $(Get-Date) ---- $Message" | Out-File -FilePath $LogFile -Append
}

function RecordReport{
    param (
        $reportChatId, 
        $reportChatTopic,
        $reportResult,
        $reportComment
    )
    if (-not (Test-Path $ReportFile)) {
        $ReportFile = New-Item $ReportFile -ItemType File
        Set-Content $ReportFile 'Chat ID,Chat Topic,Result,Comment'
    }
    Add-Content $ReportFile "$reportChatId,$reportChatTopic,$reportResult,$reportComment"
}

Function Write-Log {
    [cmdletbinding()]

    Param(
        [Parameter(Position = 0)]
        [string]$Message,
        [string]$colour,
        [string]$level = "info"
    )

    if (-not (Test-Path $LogFile)) {
        $null = New-Item $LogFile -Force
    }
 
    switch -wildcard ($setLevel) {
        'info' {
            switch -wildcard ($level) {
                'info' { OutputMessage $level -colour $colour }
                'warning' { OutputMessage $level }
                'error' { OutputMessage $level }
                'debug' { Write-Output "[$level] : $(Get-Date) ---- $Message" | Out-File -FilePath $LogFile -Append}
                default {}
            }
        }

        'debug' {
            switch -wildcard ($level) {
                'info' { OutputMessage $level -colour $colour }
                'warning' { OutputMessage $level }
                'error' { OutputMessage $level }
                'debug' { OutputMessage $level }
                default {}
            }
        }
 
        'warning' {
            switch -wildcard ($level) {
                'info' {Write-Output "[$level] : $(Get-Date) ---- $Message" | Out-File -FilePath $LogFile -Append}
                'warning' { OutputMessage $level }
                'error' { OutputMessage $level }
                'debug' {Write-Output "[$level] : $(Get-Date) ---- $Message" | Out-File -FilePath $LogFile -Append}
                default {}
            }
        }

        'error' {
            switch ($level) {
                'info' {Write-Output "[$level] : $(Get-Date) ---- $Message" | Out-File -FilePath $LogFile -Append}
                'warning' {Write-Output "[$level] : $(Get-Date) ---- $Message" | Out-File -FilePath $LogFile -Append}
                'error' { OutputMessage $level }
                'debug' {Write-Output "[$level] : $(Get-Date) ---- $Message" | Out-File -FilePath $LogFile -Append}
                default {}
            }
        }
    }
} 
Function GetChats($nextLink, $allData)
{
   $nextChats=(Invoke-MgGraphRequest -uri $nextLink -Method Get) 
   $value = ConvertTo-Json $nextChats."value"
   $conf = ConvertFrom-Json $value
   $count = ConvertTo-Json $nextChats."@odata.count"
   Write-Output "[info] : $(Get-Date) ---- getchats--otherLink" | Out-File -FilePath $LogFile -Append
   if($count -gt 0)
   {
      $allData = ConvertFrom-Json $allData
      Write-Output "[info] : $(Get-Date) ---- getchats-nextchats-convert alldata" | Out-File -FilePath $LogFile -Append
      foreach($json in $conf)
      {
        $allData += $json
      }
      $allData = ConvertTo-Json $allData
   }
   if([String]::IsNullOrEmpty($nextChats))
   {
     Write-Output "[info] : $(Get-Date) ---- getchats-nextchats-return data" | Out-File -FilePath $LogFile -Append
     return $allData
   }
   else
   {  
      $linkData = ConvertTo-Json $nextChats."@odata.nextLink"
      if([String]::IsNullOrEmpty($linkData))
      {
         Write-Output "[info] : $(Get-Date) ---- getchats--return data" | Out-File -FilePath $LogFile -Append
         return $allData
      }
      else
      {  
         $linkItem = $linkData -replace '"',''
         $nextToken = $linkItem.split(@("skiptoken"),[System.StringSplitOptions]::RemoveEmptyEntries) | select -Last 1
         $linkData = "https://graph.microsoft.com/v1.0/chats?&skiptoken$nextToken"
         Write-Output "[info] : $(Get-Date) ---- getchats--nextLink data" | Out-File -FilePath $LogFile -Append
         GetChats $linkData $allData
      }

   }
}
<# function area #>
# Connect graph api
Write-Log -message "###### Start to connect graph  ######" -colour $green
Connect-MgGraph -Scopes "User.Read", "Chat.ReadWrite" 
$myProfile = Invoke-MgGraphRequest -Method get -Uri "https://graph.microsoft.com/v1.0/me"
$userId = $myProfile.id
$user = Get-MgContext
$UserEmail = $myProfile.mail
$tenantId= $user.TenantId
$allChats=(Invoke-MgGraphRequest -uri "https://graph.microsoft.com/v1.0/chats" -Method Get) 
Write-Output "[info] : $(Get-Date) ---- selete chats and nextlink" | Out-File -FilePath $LogFile -Append
$data = ConvertTo-Json $allChats."value"
$otherLink = ConvertTo-Json $allChats."@odata.nextLink"
Write-Log -message "###### Mark as read - start ######" -colour $green
if($otherLink)
{
  $link = $otherLink -split "skiptoken"
  $otherLink = $link[1]
  $link = $link -replace '"',''
  $links = $link[1]
  Write-Output "[info] : $(Get-Date) ---- nextlink data" | Out-File -FilePath $LogFile -Append
  $linkq = "https://graph.microsoft.com/v1.0/chats?&skiptoken$links"
  $chats = GetChats $linkq $data
  if($chats)
  {
   $item = ConvertFrom-Json $chats
   $chatsCount = $item.count
   Write-Log -message "###### all of chat count: $chatsCount ######"-colour $green
   foreach($data in $item)
   {
     $hasMessage = ""
     $id = $data.id
     $chatType = $data.chatType
     $topic = $data.topic
     Write-Log -message "###### Start to process chat: $id ######"-colour $green
     $params = @{
	  user = @{
		   id = $userId
	           tenantId = $tenantId
	          }
                }
     $jsondata = ConvertTo-Json $params
     $nextDataUri = "https://graph.microsoft.com/v1.0/chats/$id/markChatReadForUser"
     try
     {
         Invoke-MgGraphRequest -Uri $nextDataUri -Body $jsondata -ContentType 'application/json' -Method Post
     }
     catch

     {
          $message = $_.Exception.Message 
          Write-Log -message "###### Message: $message ######" -level "error"
          $hasMessage = $message
     }
     if($topic)
     {
       if($hasMessage)
       {
            $hasMessage = -join('"',"$hasMessage",'"')
		    $topic = $topic -replace '"','""'
            $topic = -join('"',"$topic",'"')
            RecordReport -reportChatId $id -reportChatTopic $topic -reportResult "Failed" -reportComment $hasMessage
	   }
       else
       {
            $topic = $topic -replace '"','""'
            $topic = -join('"',"$topic",'"')
            RecordReport -reportChatId $id -reportChatTopic $topic -reportResult "Successful" -reportComment "" 
       }
     }
     else
     {
        if($chatType -eq "oneOnOne")
        {
           Write-Output "[info] : $(Get-Date) ---- Mark As Read chat Type oneOnOne" | Out-File -FilePath $LogFile -Append
           $memberUri = "https://graph.microsoft.com/beta/chats/$id/members"
           $memberList = Invoke-MgGraphRequest -Uri $memberUri -Method Get
           $memberListValue = ConvertTo-Json $memberList."value"
           $memberData  = ConvertFrom-Json $memberListValue 
           $oneOnOneTopic = ""
           foreach($member in $memberData)
           {
	      $memberEmail = $member.email
              if($memberEmail -ne $UserEmail)
              {
		$oneOnOneTopic = $member.displayName
              }
              
           }
		   $oneOnOneTopic = $oneOnOneTopic -replace '"','""'
           $oneOnOneTopic = -join('"',"$oneOnOneTopic",'"')
           if($hasMessage)
           {
                $hasMessage = -join('"',"$hasMessage",'"')
                RecordReport -reportChatId $id -reportChatTopic $oneOnOneTopic -reportResult "Failed" -reportComment $hasMessage
	   }
           else
           {
                RecordReport -reportChatId $id -reportChatTopic $oneOnOneTopic -reportResult "Successful" -reportComment ""
	   }
        }
        else
        {
           Write-Output "[info] : $(Get-Date) ---- Mark As Read chat Type other" | Out-File -FilePath $LogFile -Append
           $memberUri = "https://graph.microsoft.com/beta/chats/$id/members"
           $memberList = Invoke-MgGraphRequest -Uri $memberUri -Method Get
           $memberListValue = ConvertTo-Json $memberList."value"
           $memberData  = ConvertFrom-Json $memberListValue
           $otherTypeTopic = @()
           foreach($member in $memberData)
           {
	      $memberEmail = $member.email
              if($memberEmail -ne $UserEmail)
              {
                $displayName = $member.displayName
		      $otherTypeTopic += $displayName
              }
           }
           $otherTypeTopic = $otherTypeTopic | sort
           $otherTypeTopic = $otherTypeTopic -join ","  
		   $otherTypeTopic = $otherTypeTopic -replace '"','""'		   
           $reportTopic = -join('"',"$otherTypeTopic",'"')
           if($hasMessage)
           {
            $hasMessage = -join('"',"$hasMessage",'"')
		RecordReport -reportChatId $id -reportChatTopic $reportTopic -reportResult "Failed" -reportComment $hasMessage
	   }
           else
           {
                RecordReport -reportChatId $id -reportChatTopic $reportTopic -reportResult "Successful" -reportComment ""
	   }
	}
     }
   }
   Write-Log -message "###### Mark as read - end ######" -colour $green
  }
}
else
{
   Write-Log -message "###### else data ######" -colour $green
   $data  = ConvertFrom-Json $data
   $count = $data.count
   Write-Log -message "###### all of chat count: $count ######"-colour $green
   foreach($notNextData in $data)
   {
     $hasMessage = ""
     $notNextId = $notNextData.id
     $topic = $notNextData.topic
     $chatType = $notNextData.chatType
     Write-Log -message "###### Start to process chat: $notNextId ######"-colour $green
     $params = @{
	  user = @{
		   id = $userId
	           tenantId = $tenantId
	          }
                }
     $json = ConvertTo-Json $params
     $nextDataUri = "https://graph.microsoft.com/v1.0/chats/$notNextId/markChatReadForUser"
     try
     {
         Invoke-MgGraphRequest -Uri $nextDataUri -Body $json -ContentType 'application/json' -Method Post
     }
     catch
     {
          $message = $_.Exception.Message 
          Write-Log -message "###### Message: $message ######" -level "error"
	  $hasMessage = $message
     }
      if($topic)
     {
           if($hasMessage)
           {
                $hasMessage = -join('"',"$hasMessage",'"')
				$topic = $topic -replace '"','""'
                $topic = -join('"',"$topic",'"')
                RecordReport -reportChatId $notNextId -reportChatTopic $topic -reportResult "Failed" -reportComment $hasMessage
	   }
           else
           {
                $topic = $topic -replace '"','""'
                $topic = -join('"',"$topic",'"')
                RecordReport -reportChatId $notNextId -reportChatTopic $topic -reportResult "Successful" -reportComment ""
	   }
     }
     else
     {
        if($chatType -eq "oneOnOne")
        {
           Write-Output "[info] : $(Get-Date) ---- Mark As Read chat Type oneOnOne" | Out-File -FilePath $LogFile -Append
           $memberUri = "https://graph.microsoft.com/beta/chats/$notNextId/members"
           $memberList = Invoke-MgGraphRequest -Uri $memberUri -Method Get
           $memberListValue = ConvertTo-Json $memberList."value"
           $memberData  = ConvertFrom-Json $memberListValue
           $oneOnOneTopic = ""
           foreach($member in $memberData)
           {
	      $memberEmail = $member.email
              if($memberEmail -ne $UserEmail)
              {
		$oneOnOneTopic = $member.displayName
              }
              
           }
		   $oneOnOneTopic = $oneOnOneTopic -replace '"','""'
           $oneOnOneTopic = -join('"',"$oneOnOneTopic",'"')
           if($hasMessage)
           {
            $hasMessage = -join('"',"$hasMessage",'"')
		RecordReport -reportChatId $notNextId -reportChatTopic $oneOnOneTopic -reportResult "Failed" -reportComment $hasMessage
	   }
           else
           {
                RecordReport -reportChatId $notNextId -reportChatTopic $oneOnOneTopic -reportResult "Successful" -reportComment "" 
	   }
        }
        else
        {
           Write-Output "[info] : $(Get-Date) ---- Mark As Read chat Type other" | Out-File -FilePath $LogFile -Append
           $memberUri = "https://graph.microsoft.com/beta/chats/$notNextId/members"
           $memberList = Invoke-MgGraphRequest -Uri $memberUri -Method Get
           $memberListValue = ConvertTo-Json $memberList."value"
           $memberData  = ConvertFrom-Json $memberListValue
           $otherTypeTopic = @()
           foreach($member in $memberData)
           {
	      $memberEmail = $member.email
              if($memberEmail -ne $UserEmail)
              {
                $displayName = $member.displayName
		$otherTypeTopic += $displayName
              }
           }
           $otherTypeTopic = $otherTypeTopic | sort
           $otherTypeTopic = $otherTypeTopic -join ","   
		   $otherTypeTopic = $otherTypeTopic -replace '"','""'		   
           $reportTopic = -join('"',"$otherTypeTopic",'"')
           if($hasMessage)
           {
                $hasMessage = -join('"',"$hasMessage",'"')
		        RecordReport -reportChatId $notNextId -reportChatTopic $reportTopic -reportResult "Failed" -reportComment $hasMessage
	       }
           else
           {
                RecordReport -reportChatId $notNextId -reportChatTopic $reportTopic -reportResult "Successful" -reportComment "" 
	       }
	}
     }
   }
   Write-Log -message "###### Mark as read - end ######" -colour $green
}
Disconnect-MgGraph
Write-Log -message "Success!" -colour $green
Write-Log -message "###### end to disconnect graph  ######" -colour $green
Write-Log -message "Log file path: $LogFile" -colour $green
Write-Log -message "Report file path: $ReportFile" -colour $green
Read-Host "Enter to Exit"


# SIG # Begin signature block
# MIIoGAYJKoZIhvcNAQcCoIIoCTCCKAUCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCBRX1Ar4057ruYZ
# GeuZoSVIhfRJpyj4blYP2eltIFOKd6CCDZowggawMIIEmKADAgECAhAIrUCyYNKc
# TJ9ezam9k67ZMA0GCSqGSIb3DQEBDAUAMGIxCzAJBgNVBAYTAlVTMRUwEwYDVQQK
# EwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xITAfBgNV
# BAMTGERpZ2lDZXJ0IFRydXN0ZWQgUm9vdCBHNDAeFw0yMTA0MjkwMDAwMDBaFw0z
# NjA0MjgyMzU5NTlaMGkxCzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwg
# SW5jLjFBMD8GA1UEAxM4RGlnaUNlcnQgVHJ1c3RlZCBHNCBDb2RlIFNpZ25pbmcg
# UlNBNDA5NiBTSEEzODQgMjAyMSBDQTEwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAw
# ggIKAoICAQDVtC9C0CiteLdd1TlZG7GIQvUzjOs9gZdwxbvEhSYwn6SOaNhc9es0
# JAfhS0/TeEP0F9ce2vnS1WcaUk8OoVf8iJnBkcyBAz5NcCRks43iCH00fUyAVxJr
# Q5qZ8sU7H/Lvy0daE6ZMswEgJfMQ04uy+wjwiuCdCcBlp/qYgEk1hz1RGeiQIXhF
# LqGfLOEYwhrMxe6TSXBCMo/7xuoc82VokaJNTIIRSFJo3hC9FFdd6BgTZcV/sk+F
# LEikVoQ11vkunKoAFdE3/hoGlMJ8yOobMubKwvSnowMOdKWvObarYBLj6Na59zHh
# 3K3kGKDYwSNHR7OhD26jq22YBoMbt2pnLdK9RBqSEIGPsDsJ18ebMlrC/2pgVItJ
# wZPt4bRc4G/rJvmM1bL5OBDm6s6R9b7T+2+TYTRcvJNFKIM2KmYoX7BzzosmJQay
# g9Rc9hUZTO1i4F4z8ujo7AqnsAMrkbI2eb73rQgedaZlzLvjSFDzd5Ea/ttQokbI
# YViY9XwCFjyDKK05huzUtw1T0PhH5nUwjewwk3YUpltLXXRhTT8SkXbev1jLchAp
# QfDVxW0mdmgRQRNYmtwmKwH0iU1Z23jPgUo+QEdfyYFQc4UQIyFZYIpkVMHMIRro
# OBl8ZhzNeDhFMJlP/2NPTLuqDQhTQXxYPUez+rbsjDIJAsxsPAxWEQIDAQABo4IB
# WTCCAVUwEgYDVR0TAQH/BAgwBgEB/wIBADAdBgNVHQ4EFgQUaDfg67Y7+F8Rhvv+
# YXsIiGX0TkIwHwYDVR0jBBgwFoAU7NfjgtJxXWRM3y5nP+e6mK4cD08wDgYDVR0P
# AQH/BAQDAgGGMBMGA1UdJQQMMAoGCCsGAQUFBwMDMHcGCCsGAQUFBwEBBGswaTAk
# BggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29tMEEGCCsGAQUFBzAC
# hjVodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRUcnVzdGVkUm9v
# dEc0LmNydDBDBgNVHR8EPDA6MDigNqA0hjJodHRwOi8vY3JsMy5kaWdpY2VydC5j
# b20vRGlnaUNlcnRUcnVzdGVkUm9vdEc0LmNybDAcBgNVHSAEFTATMAcGBWeBDAED
# MAgGBmeBDAEEATANBgkqhkiG9w0BAQwFAAOCAgEAOiNEPY0Idu6PvDqZ01bgAhql
# +Eg08yy25nRm95RysQDKr2wwJxMSnpBEn0v9nqN8JtU3vDpdSG2V1T9J9Ce7FoFF
# UP2cvbaF4HZ+N3HLIvdaqpDP9ZNq4+sg0dVQeYiaiorBtr2hSBh+3NiAGhEZGM1h
# mYFW9snjdufE5BtfQ/g+lP92OT2e1JnPSt0o618moZVYSNUa/tcnP/2Q0XaG3Ryw
# YFzzDaju4ImhvTnhOE7abrs2nfvlIVNaw8rpavGiPttDuDPITzgUkpn13c5Ubdld
# AhQfQDN8A+KVssIhdXNSy0bYxDQcoqVLjc1vdjcshT8azibpGL6QB7BDf5WIIIJw
# 8MzK7/0pNVwfiThV9zeKiwmhywvpMRr/LhlcOXHhvpynCgbWJme3kuZOX956rEnP
# LqR0kq3bPKSchh/jwVYbKyP/j7XqiHtwa+aguv06P0WmxOgWkVKLQcBIhEuWTatE
# QOON8BUozu3xGFYHKi8QxAwIZDwzj64ojDzLj4gLDb879M4ee47vtevLt/B3E+bn
# KD+sEq6lLyJsQfmCXBVmzGwOysWGw/YmMwwHS6DTBwJqakAwSEs0qFEgu60bhQji
# WQ1tygVQK+pKHJ6l/aCnHwZ05/LWUpD9r4VIIflXO7ScA+2GRfS0YW6/aOImYIbq
# yK+p/pQd52MbOoZWeE4wggbiMIIEyqADAgECAhAPc9sqd/BkUUsWn0FQMB0UMA0G
# CSqGSIb3DQEBCwUAMGkxCzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwg
# SW5jLjFBMD8GA1UEAxM4RGlnaUNlcnQgVHJ1c3RlZCBHNCBDb2RlIFNpZ25pbmcg
# UlNBNDA5NiBTSEEzODQgMjAyMSBDQTEwHhcNMjMxMTAzMDAwMDAwWhcNMjYxMTE0
# MjM1OTU5WjBqMQswCQYDVQQGEwJVUzETMBEGA1UECBMKTmV3IEplcnNleTEUMBIG
# A1UEBxMLSmVyc2V5IENpdHkxFzAVBgNVBAoTDkF2ZVBvaW50LCBJbmMuMRcwFQYD
# VQQDEw5BdmVQb2ludCwgSW5jLjCCAaIwDQYJKoZIhvcNAQEBBQADggGPADCCAYoC
# ggGBAOEW7Ii2pvR9/732eojqygVHkWY2HMdaefS7g4Z4EOt6ABrXYcTFvIMax1DN
# 7ZCbfarSe6B0jsXnrNbhTZKJiphzbLAIs4NOi4EMxdWzDbc8oZqByMX77NxSiaR3
# PhqFGI99Utr9NUIBsruS6AccQ6CkP2nNejixv6BrsGJbUDrgz6A66x7V4WhYa6df
# qmMU8EucSyjcZB2A4h21H+jURe95N1SZThOw6vfFKn5JPnKvGTCuH0u19xi8d90j
# ZItOntrR92wzFG2jSd4Z3DeKyvIDWxGGqaDqloA7thXNGN/URNqTZfeXdsF6uUU2
# IojpWh8gYBTnu9i8cM9PVDOB420h5JaV+1XLO8m10LtnYBSWZWgUHpcTq7Suwbah
# 0/yiur0ltzR13dQ0wk2Xe1i/G8PlKw4IlyqESqizT3YxUGlqwcojIAYwaGBtATTf
# kCKq32rornXSmCqfrQICoA8dR7pry8hl/JloSD/+riT62F8r8mQTlLUw5xNiqBqE
# kIQvuQIDAQABo4ICAzCCAf8wHwYDVR0jBBgwFoAUaDfg67Y7+F8Rhvv+YXsIiGX0
# TkIwHQYDVR0OBBYEFJxiV1oIFotUW4UTNkwFNyJScORPMD4GA1UdIAQ3MDUwMwYG
# Z4EMAQQBMCkwJwYIKwYBBQUHAgEWG2h0dHA6Ly93d3cuZGlnaWNlcnQuY29tL0NQ
# UzAOBgNVHQ8BAf8EBAMCB4AwEwYDVR0lBAwwCgYIKwYBBQUHAwMwgbUGA1UdHwSB
# rTCBqjBToFGgT4ZNaHR0cDovL2NybDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0VHJ1
# c3RlZEc0Q29kZVNpZ25pbmdSU0E0MDk2U0hBMzg0MjAyMUNBMS5jcmwwU6BRoE+G
# TWh0dHA6Ly9jcmw0LmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydFRydXN0ZWRHNENvZGVT
# aWduaW5nUlNBNDA5NlNIQTM4NDIwMjFDQTEuY3JsMIGUBggrBgEFBQcBAQSBhzCB
# hDAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29tMFwGCCsGAQUF
# BzAChlBodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRUcnVzdGVk
# RzRDb2RlU2lnbmluZ1JTQTQwOTZTSEEzODQyMDIxQ0ExLmNydDAJBgNVHRMEAjAA
# MA0GCSqGSIb3DQEBCwUAA4ICAQDE9SZRwvtvpHrw4OjJ1AKL0aabKlOUkxidOjEC
# wrWr4yFKJdHWHpouUFTye7M8gQS4FQDQqD4ys7a1joCQVd+WEiQIyy0TzJXxT7US
# tkhg8lD41cT7i857dgnSrX7Prp0Es/xFBhEKR0fMs3Sj20+qcnJNTB4TA9CPnUd4
# UL1Ve/bqsr5lVZgoPp6wbs0lXjsTEfzrio++T4ssc42eTxfv6YZgTmdrPEQNqLUa
# hQuQ0x5j8lVBBtt5PrC7TikkVB/GBZ+01EJrUQvcX3arZky1tviINBQ3EXRhyGkx
# zSz6Vk9NxwJVkdavIUkdDuUuqNVqp2a3Zsv2L3mwlr0UnKMgpBiPnxgC9u6e5tjR
# +plDe3fmD20XQTt/p61FueC7w92HC6YizDrynRX58h6KuRv2j/u2yZU3nipaiGlz
# 8jURf2ySxZXI2QG228Nfsg4y1Z61tPfYb4kcqTfVcaxh7azpP6BU33dkIyC7dmv4
# q3PueRcSyweKjqlQqeswnTeBS3+met1BbjkMdJJzqbIu5WONTBIHHH1RGsQYPn8i
# ms3pE0GhGl9c1r1BpufehQwSjCZRc/vHrHUOQyNimVKoOtls5UAxU5FXO3PKaHPO
# M6dFS1b+EF6drXV0M9/KdJVyyP4EK6CJQVt7RrQBRSSdQCKCYJ63VUF5amRuzY0s
# EqLoRTGCGdQwghnQAgEBMH0waTELMAkGA1UEBhMCVVMxFzAVBgNVBAoTDkRpZ2lD
# ZXJ0LCBJbmMuMUEwPwYDVQQDEzhEaWdpQ2VydCBUcnVzdGVkIEc0IENvZGUgU2ln
# bmluZyBSU0E0MDk2IFNIQTM4NCAyMDIxIENBMQIQD3PbKnfwZFFLFp9BUDAdFDAN
# BglghkgBZQMEAgEFAKB8MBAGCisGAQQBgjcCAQwxAjAAMBkGCSqGSIb3DQEJAzEM
# BgorBgEEAYI3AgEEMBwGCisGAQQBgjcCAQsxDjAMBgorBgEEAYI3AgEVMC8GCSqG
# SIb3DQEJBDEiBCDsOUW0ShiZZj2PtMkkpm8khYwS5GnmJ2sSwN+6kaC6nTANBgkq
# hkiG9w0BAQEFAASCAYDLh3SeMkh3z9UHgb9O7Z2h/qy3Jaxj0j+9jvAy9ytDdXIZ
# NuWLyKHV+A2gwbYkHbZlV0sj81Y5ThBYYq3cCwzEOrRRff7cVgmf+QT2JH2OKb0c
# vmotJ1WhQlBSSu98hK0rxm4GluiOWkkwXwlVs2Y2+JmVkrSnxpPbKR1kpj/Xjde4
# Se1Dbfli0o4Ntmf5LXs/E90tJThi3BalonzBQT/9jzYcgzfbOeDcp7qaAHaj9KSc
# UFuru3YPqmXOucRSQQqhKTGfQwb8oI27Ym9g7OHOy5/ztWCyjjTemSd8pcW4rkRM
# pgaTt/TwF+bsKwwjqgzofV8Gh7FvikvFcRtcKtax5oyZDFvsI5XlvHVR++63w0A5
# rrYYc4JZzGWnmMg6DMVj8YpzsuR6Y8vMVnhpJdIiFdic7QTb270cBPbk1nUEkiF8
# L+1eV0ypYX9iaOGJ71NQ68+AqBG8RzbmVPk61xlMmb6uWR9y95lQMJgVXJPxoFqU
# XPAWyEX4tVjlm+tTlH6hghcqMIIXJgYKKwYBBAGCNwMDATGCFxYwghcSBgkqhkiG
# 9w0BBwKgghcDMIIW/wIBAzEPMA0GCWCGSAFlAwQCAQUAMGgGCyqGSIb3DQEJEAEE
# oFkEVzBVAgEBBglghkgBhv1sBwEwITAJBgUrDgMCGgUABBRO4mdpDDkIRPtIHfle
# Ky+M8Y5WNAIRAJKPX8rtvj4dZMhFZJYffVMYDzIwMjUwMjI0MDYzMTE4WqCCEwMw
# gga8MIIEpKADAgECAhALrma8Wrp/lYfG+ekE4zMEMA0GCSqGSIb3DQEBCwUAMGMx
# CzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwgSW5jLjE7MDkGA1UEAxMy
# RGlnaUNlcnQgVHJ1c3RlZCBHNCBSU0E0MDk2IFNIQTI1NiBUaW1lU3RhbXBpbmcg
# Q0EwHhcNMjQwOTI2MDAwMDAwWhcNMzUxMTI1MjM1OTU5WjBCMQswCQYDVQQGEwJV
# UzERMA8GA1UEChMIRGlnaUNlcnQxIDAeBgNVBAMTF0RpZ2lDZXJ0IFRpbWVzdGFt
# cCAyMDI0MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAvmpzn/aVIauW
# MLpbbeZZo7Xo/ZEfGMSIO2qZ46XB/QowIEMSvgjEdEZ3v4vrrTHleW1JWGErrjOL
# 0J4L0HqVR1czSzvUQ5xF7z4IQmn7dHY7yijvoQ7ujm0u6yXF2v1CrzZopykD07/9
# fpAT4BxpT9vJoJqAsP8YuhRvflJ9YeHjes4fduksTHulntq9WelRWY++TFPxzZrb
# ILRYynyEy7rS1lHQKFpXvo2GePfsMRhNf1F41nyEg5h7iOXv+vjX0K8RhUisfqw3
# TTLHj1uhS66YX2LZPxS4oaf33rp9HlfqSBePejlYeEdU740GKQM7SaVSH3TbBL8R
# 6HwX9QVpGnXPlKdE4fBIn5BBFnV+KwPxRNUNK6lYk2y1WSKour4hJN0SMkoaNV8h
# yyADiX1xuTxKaXN12HgR+8WulU2d6zhzXomJ2PleI9V2yfmfXSPGYanGgxzqI+Sh
# oOGLomMd3mJt92nm7Mheng/TBeSA2z4I78JpwGpTRHiT7yHqBiV2ngUIyCtd0pZ8
# zg3S7bk4QC4RrcnKJ3FbjyPAGogmoiZ33c1HG93Vp6lJ415ERcC7bFQMRbxqrMVA
# Niav1k425zYyFMyLNyE1QulQSgDpW9rtvVcIH7WvG9sqYup9j8z9J1XqbBZPJ5XL
# ln8mS8wWmdDLnBHXgYly/p1DhoQo5fkCAwEAAaOCAYswggGHMA4GA1UdDwEB/wQE
# AwIHgDAMBgNVHRMBAf8EAjAAMBYGA1UdJQEB/wQMMAoGCCsGAQUFBwMIMCAGA1Ud
# IAQZMBcwCAYGZ4EMAQQCMAsGCWCGSAGG/WwHATAfBgNVHSMEGDAWgBS6FtltTYUv
# cyl2mi91jGogj57IbzAdBgNVHQ4EFgQUn1csA3cOKBWQZqVjXu5Pkh92oFswWgYD
# VR0fBFMwUTBPoE2gS4ZJaHR0cDovL2NybDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0
# VHJ1c3RlZEc0UlNBNDA5NlNIQTI1NlRpbWVTdGFtcGluZ0NBLmNybDCBkAYIKwYB
# BQUHAQEEgYMwgYAwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmRpZ2ljZXJ0LmNv
# bTBYBggrBgEFBQcwAoZMaHR0cDovL2NhY2VydHMuZGlnaWNlcnQuY29tL0RpZ2lD
# ZXJ0VHJ1c3RlZEc0UlNBNDA5NlNIQTI1NlRpbWVTdGFtcGluZ0NBLmNydDANBgkq
# hkiG9w0BAQsFAAOCAgEAPa0eH3aZW+M4hBJH2UOR9hHbm04IHdEoT8/T3HuBSyZe
# q3jSi5GXeWP7xCKhVireKCnCs+8GZl2uVYFvQe+pPTScVJeCZSsMo1JCoZN2mMew
# /L4tpqVNbSpWO9QGFwfMEy60HofN6V51sMLMXNTLfhVqs+e8haupWiArSozyAmGH
# /6oMQAh078qRh6wvJNU6gnh5OruCP1QUAvVSu4kqVOcJVozZR5RRb/zPd++PGE3q
# F1P3xWvYViUJLsxtvge/mzA75oBfFZSbdakHJe2BVDGIGVNVjOp8sNt70+kEoMF+
# T6tptMUNlehSR7vM+C13v9+9ZOUKzfRUAYSyyEmYtsnpltD/GWX8eM70ls1V6QG/
# ZOB6b6Yum1HvIiulqJ1Elesj5TMHq8CWT/xrW7twipXTJ5/i5pkU5E16RSBAdOp1
# 2aw8IQhhA/vEbFkEiF2abhuFixUDobZaA0VhqAsMHOmaT3XThZDNi5U2zHKhUs5u
# HHdG6BoQau75KiNbh0c+hatSF+02kULkftARjsyEpHKsF7u5zKRbt5oK5YGwFvgc
# 4pEVUNytmB3BpIiowOIIuDgP5M9WArHYSAR16gc0dP2XdkMEP5eBsX7bf/MGN4K3
# HP50v/01ZHo/Z5lGLvNwQ7XHBx1yomzLP8lx4Q1zZKDyHcp4VQJLu2kWTsKsOqQw
# ggauMIIElqADAgECAhAHNje3JFR82Ees/ShmKl5bMA0GCSqGSIb3DQEBCwUAMGIx
# CzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3
# dy5kaWdpY2VydC5jb20xITAfBgNVBAMTGERpZ2lDZXJ0IFRydXN0ZWQgUm9vdCBH
# NDAeFw0yMjAzMjMwMDAwMDBaFw0zNzAzMjIyMzU5NTlaMGMxCzAJBgNVBAYTAlVT
# MRcwFQYDVQQKEw5EaWdpQ2VydCwgSW5jLjE7MDkGA1UEAxMyRGlnaUNlcnQgVHJ1
# c3RlZCBHNCBSU0E0MDk2IFNIQTI1NiBUaW1lU3RhbXBpbmcgQ0EwggIiMA0GCSqG
# SIb3DQEBAQUAA4ICDwAwggIKAoICAQDGhjUGSbPBPXJJUVXHJQPE8pE3qZdRodbS
# g9GeTKJtoLDMg/la9hGhRBVCX6SI82j6ffOciQt/nR+eDzMfUBMLJnOWbfhXqAJ9
# /UO0hNoR8XOxs+4rgISKIhjf69o9xBd/qxkrPkLcZ47qUT3w1lbU5ygt69OxtXXn
# HwZljZQp09nsad/ZkIdGAHvbREGJ3HxqV3rwN3mfXazL6IRktFLydkf3YYMZ3V+0
# VAshaG43IbtArF+y3kp9zvU5EmfvDqVjbOSmxR3NNg1c1eYbqMFkdECnwHLFuk4f
# sbVYTXn+149zk6wsOeKlSNbwsDETqVcplicu9Yemj052FVUmcJgmf6AaRyBD40Nj
# gHt1biclkJg6OBGz9vae5jtb7IHeIhTZgirHkr+g3uM+onP65x9abJTyUpURK1h0
# QCirc0PO30qhHGs4xSnzyqqWc0Jon7ZGs506o9UD4L/wojzKQtwYSH8UNM/STKvv
# mz3+DrhkKvp1KCRB7UK/BZxmSVJQ9FHzNklNiyDSLFc1eSuo80VgvCONWPfcYd6T
# /jnA+bIwpUzX6ZhKWD7TA4j+s4/TXkt2ElGTyYwMO1uKIqjBJgj5FBASA31fI7tk
# 42PgpuE+9sJ0sj8eCXbsq11GdeJgo1gJASgADoRU7s7pXcheMBK9Rp6103a50g5r
# mQzSM7TNsQIDAQABo4IBXTCCAVkwEgYDVR0TAQH/BAgwBgEB/wIBADAdBgNVHQ4E
# FgQUuhbZbU2FL3MpdpovdYxqII+eyG8wHwYDVR0jBBgwFoAU7NfjgtJxXWRM3y5n
# P+e6mK4cD08wDgYDVR0PAQH/BAQDAgGGMBMGA1UdJQQMMAoGCCsGAQUFBwMIMHcG
# CCsGAQUFBwEBBGswaTAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQu
# Y29tMEEGCCsGAQUFBzAChjVodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGln
# aUNlcnRUcnVzdGVkUm9vdEc0LmNydDBDBgNVHR8EPDA6MDigNqA0hjJodHRwOi8v
# Y3JsMy5kaWdpY2VydC5jb20vRGlnaUNlcnRUcnVzdGVkUm9vdEc0LmNybDAgBgNV
# HSAEGTAXMAgGBmeBDAEEAjALBglghkgBhv1sBwEwDQYJKoZIhvcNAQELBQADggIB
# AH1ZjsCTtm+YqUQiAX5m1tghQuGwGC4QTRPPMFPOvxj7x1Bd4ksp+3CKDaopafxp
# wc8dB+k+YMjYC+VcW9dth/qEICU0MWfNthKWb8RQTGIdDAiCqBa9qVbPFXONASIl
# zpVpP0d3+3J0FNf/q0+KLHqrhc1DX+1gtqpPkWaeLJ7giqzl/Yy8ZCaHbJK9nXzQ
# cAp876i8dU+6WvepELJd6f8oVInw1YpxdmXazPByoyP6wCeCRK6ZJxurJB4mwbfe
# Kuv2nrF5mYGjVoarCkXJ38SNoOeY+/umnXKvxMfBwWpx2cYTgAnEtp/Nh4cku0+j
# Sbl3ZpHxcpzpSwJSpzd+k1OsOx0ISQ+UzTl63f8lY5knLD0/a6fxZsNBzU+2QJsh
# IUDQtxMkzdwdeDrknq3lNHGS1yZr5Dhzq6YBT70/O3itTK37xJV77QpfMzmHQXh6
# OOmc4d0j/R0o08f56PGYX/sr2H7yRp11LB4nLCbbbxV7HhmLNriT1ObyF5lZynDw
# N7+YAN8gFk8n+2BnFqFmut1VwDophrCYoCvtlUG3OtUVmDG0YgkPCr2B2RP+v6TR
# 81fZvAT6gt4y3wSJ8ADNXcL50CN/AAvkdgIm2fBldkKmKYcJRyvmfxqkhQ/8mJb2
# VVQrH4D6wPIOK+XW+6kvRBVK5xMOHds3OBqhK/bt1nz8MIIFjTCCBHWgAwIBAgIQ
# DpsYjvnQLefv21DiCEAYWjANBgkqhkiG9w0BAQwFADBlMQswCQYDVQQGEwJVUzEV
# MBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29t
# MSQwIgYDVQQDExtEaWdpQ2VydCBBc3N1cmVkIElEIFJvb3QgQ0EwHhcNMjIwODAx
# MDAwMDAwWhcNMzExMTA5MjM1OTU5WjBiMQswCQYDVQQGEwJVUzEVMBMGA1UEChMM
# RGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29tMSEwHwYDVQQD
# ExhEaWdpQ2VydCBUcnVzdGVkIFJvb3QgRzQwggIiMA0GCSqGSIb3DQEBAQUAA4IC
# DwAwggIKAoICAQC/5pBzaN675F1KPDAiMGkz7MKnJS7JIT3yithZwuEppz1Yq3aa
# za57G4QNxDAf8xukOBbrVsaXbR2rsnnyyhHS5F/WBTxSD1Ifxp4VpX6+n6lXFllV
# cq9ok3DCsrp1mWpzMpTREEQQLt+C8weE5nQ7bXHiLQwb7iDVySAdYyktzuxeTsiT
# +CFhmzTrBcZe7FsavOvJz82sNEBfsXpm7nfISKhmV1efVFiODCu3T6cw2Vbuyntd
# 463JT17lNecxy9qTXtyOj4DatpGYQJB5w3jHtrHEtWoYOAMQjdjUN6QuBX2I9YI+
# EJFwq1WCQTLX2wRzKm6RAXwhTNS8rhsDdV14Ztk6MUSaM0C/CNdaSaTC5qmgZ92k
# J7yhTzm1EVgX9yRcRo9k98FpiHaYdj1ZXUJ2h4mXaXpI8OCiEhtmmnTK3kse5w5j
# rubU75KSOp493ADkRSWJtppEGSt+wJS00mFt6zPZxd9LBADMfRyVw4/3IbKyEbe7
# f/LVjHAsQWCqsWMYRJUadmJ+9oCw++hkpjPRiQfhvbfmQ6QYuKZ3AeEPlAwhHbJU
# KSWJbOUOUlFHdL4mrLZBdd56rF+NP8m800ERElvlEFDrMcXKchYiCd98THU/Y+wh
# X8QgUWtvsauGi0/C1kVfnSD8oR7FwI+isX4KJpn15GkvmB0t9dmpsh3lGwIDAQAB
# o4IBOjCCATYwDwYDVR0TAQH/BAUwAwEB/zAdBgNVHQ4EFgQU7NfjgtJxXWRM3y5n
# P+e6mK4cD08wHwYDVR0jBBgwFoAUReuir/SSy4IxLVGLp6chnfNtyA8wDgYDVR0P
# AQH/BAQDAgGGMHkGCCsGAQUFBwEBBG0wazAkBggrBgEFBQcwAYYYaHR0cDovL29j
# c3AuZGlnaWNlcnQuY29tMEMGCCsGAQUFBzAChjdodHRwOi8vY2FjZXJ0cy5kaWdp
# Y2VydC5jb20vRGlnaUNlcnRBc3N1cmVkSURSb290Q0EuY3J0MEUGA1UdHwQ+MDww
# OqA4oDaGNGh0dHA6Ly9jcmwzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJ
# RFJvb3RDQS5jcmwwEQYDVR0gBAowCDAGBgRVHSAAMA0GCSqGSIb3DQEBDAUAA4IB
# AQBwoL9DXFXnOF+go3QbPbYW1/e/Vwe9mqyhhyzshV6pGrsi+IcaaVQi7aSId229
# GhT0E0p6Ly23OO/0/4C5+KH38nLeJLxSA8hO0Cre+i1Wz/n096wwepqLsl7Uz9FD
# RJtDIeuWcqFItJnLnU+nBgMTdydE1Od/6Fmo8L8vC6bp8jQ87PcDx4eo0kxAGTVG
# amlUsLihVo7spNU96LHc/RzY9HdaXFSMb++hUD38dglohJ9vytsgjTVgHAIDyyCw
# rFigDkBjxZgiwbJZ9VVrzyerbHbObyMt9H5xaiNrIv8SuFQtJ37YOtnwtoeW/VvR
# XKwYw02fc7cBqZ9Xql4o4rmUMYIDdjCCA3ICAQEwdzBjMQswCQYDVQQGEwJVUzEX
# MBUGA1UEChMORGlnaUNlcnQsIEluYy4xOzA5BgNVBAMTMkRpZ2lDZXJ0IFRydXN0
# ZWQgRzQgUlNBNDA5NiBTSEEyNTYgVGltZVN0YW1waW5nIENBAhALrma8Wrp/lYfG
# +ekE4zMEMA0GCWCGSAFlAwQCAQUAoIHRMBoGCSqGSIb3DQEJAzENBgsqhkiG9w0B
# CRABBDAcBgkqhkiG9w0BCQUxDxcNMjUwMjI0MDYzMTE4WjArBgsqhkiG9w0BCRAC
# DDEcMBowGDAWBBTb04XuYtvSPnvk9nFIUIck1YZbRTAvBgkqhkiG9w0BCQQxIgQg
# HiT3/QCzpxrYBMPAbY9ykpLHSsnUvyScyJvnUy5A/wQwNwYLKoZIhvcNAQkQAi8x
# KDAmMCQwIgQgdnafqPJjLx9DCzojMK7WVnX+13PbBdZluQWTmEOPmtswDQYJKoZI
# hvcNAQEBBQAEggIAZ2dXDYrw33INNup6LFLS4DaejL8xSD+hI6S3a61ZpmX3rXPO
# n6yA/fGKoBJNfNBLROJOBHXC1UeLhxmZKyCqZxE1WJ44Ob2BX/LRR6YIDvS56pW2
# 8njYfkU3/MYjC02DdzcIIgAisgX0Kk141l4m4gwkMaq/mrDPGQH8zztZXYa+NF42
# u0D7kfhMRVFmhFLZtLdCYErFW9p+92YPlKe1nhLZsDCnWBpy61cB2LAL/ABWwbZD
# K6WNa5qTMd95E2/cOjuqyOO5DIWgPzP/9JGe5F3Fy9IMlMOQuR9OdIHPn+0ZrTtq
# KhJ1V/gXnpXA9SCisOM0CbgXPkKp9bxm6A8nkHq8BRsGFr3HAbsxfUrVThN/rBpV
# svNkocg8FoIYC/ny14GUbLTphw3K/c0bkc9KdXvdP+e5aiXs8OiVX6DooZUdVYYc
# SKlCPBTkrynThFjZ0Rxmlkwmm5GGzJFZlcSmohdhRi4lbWTxDdFX3myTCxHIhIfq
# eYZNEoD4mXIwxRk+Up6acaDbLX+mp4MRXKLRYcgYZEyteTTdUJ0Swo1Zf8voIHNW
# JuFhSM/odSlN17woNEeGSmbPVSh7Aa2i7IFMj6/uu+Ud+xwThT+kOKW0oUkG/+MF
# o8XaQ7V/unHbDyS7oGZ5jxYE8jx4PTjrm9m2xSwZvD+t3UzTdIc+Af0RrdQ=
# SIG # End signature block
