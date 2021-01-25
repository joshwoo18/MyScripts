

$users = Get-ADUser -Filter {enabled -eq $false} | FT samaccountname, name, userprincipalname 

#|  export-csv "C:\Temp\DisabledUsers.csv" -notypeinformation
foreach ($user in $users)

{
	write-output $user | Out-File "C:\Temp\DisabledUsers.csv" -Append
}