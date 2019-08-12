# Must have MIcrosft RAT tools installed on device your running script from..
# This script was created out of pure lazyness so... yeaah... cool....
# The author of this script will not take responsibility for any malicious use of this script




function userLookup {
    cls
    Write-Host "User Lookup"  
    Write-Host ""                                                                               
    $usr = Read-Host "[+] Enter User Name"
    Get-ADUser $usr -Properties Name,SamAccountName,mail,targetAddress,Manager,LockedOut,Enabled,telephoneNumber,Title,extensionAttribute14,SID,Created | Format-List Name,SamAccountName,mail,targetAddress,Manager,LockedOut,Enabled,telephoneNumber,Title,extensionAttribute14,SID,Created
    Write-Host "*** extensionAttribute14 = Users home office ***" -ForegroundColor White -BackgroundColor Red


}

function lastpassReset {
    cls
    Write-Host "User Last Password Reset Lookup"
    Write-Host ""
    $usr = Read-Host "[+] Enter User Name"
    Get-ADUser $usr -properties Name,passwordlastset,LastLogonDate,BadLogonCount,LockedOut,AccountLockoutTime,Enabled,passwordneverexpires | Format-List Name, passwordlastset, LastLogonDate, BadLogonCount, LockedOut, AccountLockoutTime, Enabled, Passwordneverexpires
    

}

function groupMembership {
    cls
    Write-Host "User Group Membership"
    Write-Host ""
    $usr = Read-Host "[+] Enter User Name"
    Get-ADPrincipalGroupMembership -Identity $usr | Format-Table -Property name
    

}

function hostnameLookup {
     cls
     Write-Host ""
     Write-Host "Hostname Lookup [SCCM]"
     $SQLServer = "SCCM Server"    #  <----------- Change  SCCM Server to the name of your SCCM DB

$SQLDBName = "SQL_DB"      # <--------- Change SQL_DB to the name of your SCCM DB

$usr = Read-Host "[+] Enter User Name"

$SqlQuery = "SELECT

    Distinct

    s.Name0

    [MachineID]

    ,UMR.UniqueUserName

    ,ccb.CNLastOnlineTime

    ,CCB.LastActiveTime

  FROM [SQL_DB].[dbo].[System_DATA] AS s   #  <----------- Change  SQL_DB to the name of your SCCM DB

    INNER JOIN [SQL_DB].[dbo].[UserMachineRelation] AS UMR  #  <----------- Change SQL_DB to the name of your SCCM DB

    ON s.MachineID = UMR.MachineResourceId

    INNER JOIN v_CollectionMemberClientBaselineStatus AS CCB

    ON s.MachineID = CCB.MachineID 

  Where UMR.UniqueUserName = 'Smurfdomain\$usr'   # <-------- Change Smurfdomain to your company domain

  Order By CCB.LastActiveTime;"

$SqlConnection = New-Object System.Data.SqlClient.SqlConnection

$SqlConnection.ConnectionString = "Server = $SQLServer; Database = $SQLDBName; Integrated Security = True; User ID = $uid;"

$SqlCmd = New-Object System.Data.SqlClient.SqlCommand

$SqlCmd.CommandText = $SqlQuery

$SqlCmd.Connection = $SqlConnection

$SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter

$SqlAdapter.SelectCommand = $SqlCmd

$DataSet = New-Object System.Data.DataSet

$format = @{Expression={$_.MachineID};width=10};@{Expression={$_.UniqueUserName};width=10};@{Expression={$_.CNLastOnlineTime};width=10};@{Expression={$_.LastActiveTime}; width=10}

$SqlAdapter.Fill($DataSet)

$DataSet.tables[0] # | Out-GridView



}

function lastknownIP {
    cls
    Write-Host "Device Last Known IP [SCCM]"
    $SQLServer = "SCCM Server"    #  <----------- Change SCCM server to your name the name of your SCCM

$SQLDBName = "SQL_DB"   #  <----------- Change  SQL_DB to the name of your SCCM DB


$usr = Read-Host "[+] Enter User Name"

$SqlQuery = "SELECT
    
  NetData.DNSHostName00,
  NetData.MACAddress00,
  NetData.IPAddress00,
  
  UserMachRelate.UniqueUserName

 

  FROM [SQL_DB].[dbo].[Network_DATA] AS NetData INNER JOIN [SQL_DB].dbo.UserMachineRelation AS UserMachRelate     
#  <----------- Change  SQL_DB [2] to the name of your SCCM DB
 

  ON NetData.MachineID = UserMachRelate.MachineResourceID

 

  Where UserMachRelate.UniqueUserName = 'Domain\$usr' AND NetData.IPAddress00 != 'NULL';"   #  <----------- Change  Domain to the name of your Domain

$SqlConnection = New-Object System.Data.SqlClient.SqlConnection

$SqlConnection.ConnectionString = "Server = $SQLServer; Database = $SQLDBName; Integrated Security = True; User ID = $uid;"

$SqlCmd = New-Object System.Data.SqlClient.SqlCommand

$SqlCmd.CommandText = $SqlQuery

$SqlCmd.Connection = $SqlConnection

$SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter

$SqlAdapter.SelectCommand = $SqlCmd

$DataSet = New-Object System.Data.DataSet

$SqlAdapter.Fill($DataSet)


$DataSet.Tables[0]



}

function disableAcct {
    cls
    Write-Host ""
    Write-Host "Disable AD Account"
    Write-Host ""
    $usr = Read-Host "[+] Enter User Name"
    Disable-ADAccount -Identity $usr
    Write-Host "Current Status of $usr"
    Get-ADUser $usr -Properties Name, Enabled,LockedOut | Format-List Name, Enabled, LockedOut
    


}
function unlockAcct { 
    cls
    Write-Host "Unlock User Account"  
    Write-Host ""                                                                               
    $usr = Read-Host "[+] Enter User Name"
    Unlock-ADAccount -Identity $usr 
    Write-Host ""
    Write-Host "Current Status of $usr"
    Get-ADUser $usr -Properties Name, Enabled | Format-List Name, Enabled
   

}
function orientationCheck {
    cls
    Write-Host ""
    Write-Host "New Hire Orientation Password Reset Check"
    Write-Host ""
    Write-Host "Who's gonna be the first liar that claims they changed the default password..."
    sleep 2
    Write-Host ""
    Write-Host "Spin the..."
    sleep 2
    Write-Host ""
    Write-Host "WHEEL!!" 
    sleep 2
    Write-Host ""
    $startdate = Read-Host "[+] Enter Orientation Start Date (ex. 1/1/2019)" 
    $time = "12:00:00 AM"   # Change to system set time for account creation if you have one
    $orientation = "$startdate $time"
    Get-ADUser -Filter   # *** set to extention attribute with users start date and time *** {(extensionAttribute -like $orientation)} -Properties Name,passwordlastset,Created | Ft Name, passwordlastset,Created
    Write-Host ""
    $again = Read-Host "[+] Do you want to run another check? [Y/N]"
    Write-Host ""
    if ($again -eq "y"){orientationCheck}
    elseif ($again -eq "n"){menu}
    elseif ($again -ne "y" -or $again -ne "n"){exit}
}


function again {
    Write-Host ""
	$again = Read-Host "[+] Back to Main Menu? [Y/N]"
    Write-Host ""
	if ($again -eq "y"){Menu}
	elseif ($again -eq "n"){Write-Host "Smurf that playa!"; exit}
	elseif ($again -ne "y" -or $again -ne "n"){exit}

}


function Menu
{
    param (
    [string]$Title = 'Smurf Finder'
    )
    cls
    Write-Host "======================= $Title =========================="
    write-Host ""
    Write-Host "        Up the smurfin creek without a paddle..."
    Write-Host ""
    Write-Host "========================== v-1.07? ============================"
    Write-Host ""
    Write-Host "1: User Lookup"
    Write-Host "2: User Last Password Reset Lookup"
    Write-Host "3: User Group Membership"
    Write-Host "4: Hostname Lookup [SCCM]"
    Write-Host "5: Device Last Known IP [SCCM]"
    Write-Host "6: Disable AD Account"
    Write-Host "7: Unlock AD Account"
    Write-Host "8: New Hire Orientation Password Reset Check"
    Write-Host "Q: Quit"
    Write-Host "" 
    Write-Host ""
    $input = Read-Host "[+] Enter a Smurfin Number"
    Write-Host ""
    if($input -eq 0){Write-Host "Smurf'd that up..." -ForegroundColor White -BackgroundColor Red;sleep 2; exit}
    elseif($input -eq "1"){userLookup;again}
    elseif($input -eq "2"){lastpassReset;again}
    elseif($input -eq "3"){groupMembership;again}
    elseif($input -eq "4"){hostnameLookup;again}
    elseif($input -eq "5"){lastknownIP;again}
    elseif($input -eq "6"){disableAcct;again}
    elseif($input -eq "7"){unlockAcct;again}
    elseif($input -eq "8"){orientationCheck;again}
    elseif($input -eq "q") {exit}
    elseif($input -eq 1..8){Write-Host ""}
    elseif($input -ne 1..8){Write-Host "Well that was fun...you feel like putting a number from the menu in?"}
    }


Menu

again
