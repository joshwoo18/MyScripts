#Load SharePoint CSOM Assemblies
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"
  
#Function to get all files of a folder
Function Get-AllFilesFromFolder([Microsoft.SharePoint.Client.Folder]$Folder)
{
    #Get All Files of the Folder
    $Ctx =  $Folder.Context
    $Ctx.load($Folder.files)
    $Ctx.ExecuteQuery()
#test  
    #Get all files in Folder
    ForEach ($File in $Folder.files)
    {
        #Get the File Name or do something
        #Write-host -f Green $File.Name
	    write-output $File.Name |Out-File .\LibraryItems.txt -Append 
		
    }
          
    #Recursively Call the function to get files of all folders
    $Ctx.load($Folder.Folders)
    $Ctx.ExecuteQuery()
  
    #Exclude "Forms" system folder and iterate through each folder
    ForEach($SubFolder in $Folder.Folders | Where {$_.Name -ne "Forms"})
    {
        Get-AllFilesFromFolder -Folder $SubFolder
    }
}
  
#powershell list all documents in sharepoint online library
Function Get-SPODocumentLibraryFiles()
{
    param
    (
        [Parameter(Mandatory=$true)] [string] $SiteURL,
        [Parameter(Mandatory=$true)] [string] $LibraryName,
        [Parameter(Mandatory=$true)] [System.Management.Automation.PSCredential] $Credential
    )
    Try {
      
        #Setup the context
        $Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
        $Ctx.Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Cred.UserName,$Cred.Password)
  
        #Get the Library and Its Root Folder
        $Library=$Ctx.web.Lists.GetByTitle($LibraryName)
        $Ctx.Load($Library)
        $Ctx.Load($Library.RootFolder)
        $Ctx.ExecuteQuery()
  
        #Call the function to get Files of the Root Folder
        Get-AllFilesFromFolder -Folder $Library.RootFolder
     }
    Catch {
        write-host -f Red "Error:" $_.Exception.Message
    }
}
#Get Credentials to connect
$Cred = Get-Credential

#Config Parameters
$SiteURL= Read-Host -Prompt "Please enter the site URL:  "
$LibraryName= Read-Host -Prompt "Please enter Library/List Name:  "
 

#Call the function to Get All Files from a document library
Get-SPODocumentLibraryFiles -SiteURL $SiteURL -LibraryName $LibraryName -Credential $Cred

#Read more: https://www.sharepointdiary.com/2018/08/sharepoint-online-powershell-to-get-all-files-in-document-library.html#ixzz6k0Ujv1jn