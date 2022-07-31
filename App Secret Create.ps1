#check time now
$timeNow = Get-Date -Format "yyyy/MM/dd HH:mm:ss"  # Format to be used "dddd MM/dd/yyyy HH:mm K"

#check secreats that are valid and create if not

#Select-MgProfile -Name "beta"

#Select-MgProfile -Name "v1.0"

#seems permission Application.ReadWrite.OwnedBy does not exits in Ms Graph
Connect-MgGraph -Scopes 'User.Read.All', 'User.ReadWrite.All', 'Application.ReadWrite.All'  #'Application.ReadWrite.OwnedBy'

#Connect-MgGraph -Scopes '.default' #How to use default scope with PS

$appId = "app id"
$tenantId = "tenant id" 
$certThumbPrint = "cert thumb"

Connect-MgGraph -ClientID $appId -TenantId $tenantId -CertificateThumbprint $certThumbPrint #-Scopes 'User.Read.All Group.Read.All'


#Get secret
#https://graph.microsoft.com/beta/applications/<"app id">/passwordCredentials
#this need to change if going throw many apps, needs a loop here

$app = Get-MgApplication -Applicationid 'app id target'
$appCreds = $app.PasswordCredentials

foreach($aC in $appCreds){
    #Write-Host $aC.EndDateTime

    if($aC.EndDateTime -lt $timeNow)
    {
        #Debug value
        Write-Host "Expired $($aC.DisplayName): $($aC.EndDateTime)" #Needs the brackets to get props or only obj will be displayed
        Write-Host "================"
        Write-Host $timeNow
        #Delete secret?
        
        #Create secret
        $params = @{
	        PasswordCredential = @{
		        DisplayName = "SuperSec 3"
	        }
        }

        Add-MgApplicationPassword -ApplicationId 'app id targer' -BodyParameter $params 
      
    }
}

#permission
#Application.ReadWrite.OwnedBy, Application.ReadWrite.All

#prop == passwordCredentials[]
# inner endDateTime


#create new secret
#https://graph.microsoft.com/v1.0/myorganization/applications/23a3c1d8-c1f0-4384-aa54-baa30f0603cd/addPassword


Disconnect-MgGraph