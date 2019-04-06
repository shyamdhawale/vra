<#
.SYNOPSIS
    Create vRealize Automation Endpoint User Role on vCenter. 
.DESCRIPTION
    Create a new role on the vCenter with required privileges.
       
.NOTES
    Additional Notes, eg
    File Name  : add-vra-user.psa
    Author     : Radhesham Dhawale / shyam.dhawale@gmail.com
    
.LINK
    A hyper link, eg
        
.EXAMPLE
   
#>
param (
	[Parameter(Mandatory=$true)]
	$vCenterServer
	)
#Create vRealize Automation Endpoint User Role on vCenter. 
#Tested on vRA 7.5

$rolename = "vRealize Automation"
$vCenterServer = Read-Host -Prompt "Enter the vCenter Server :"
$vra_user = Read-Host -Prompt "Enter the name of the VRA User (<domain>\<user>)"

$vRA_PrivilegesList = @(
	"Datastore.AllocateSpace", 
	"Datastore.Browse",
	"StoragePod.Config",
	"Folder.Create",
	"Folder.Delete",
	"Global.ManageCustomFields",
	"Global.SetCustomField",
	"Network.Assign",
	"Authorization.ModifyPermissions",
	"Resource.AssignVMToPool",
	"Resource.HotMigrate",
	"Resource.ColdMigrate",
	"VirtualMachine.Inventory.CreateFromExisting",
	"VirtualMachine.Inventory.Create",
	"VirtualMachine.Inventory.Delete",
	"VirtualMachine.Inventory.Move",
	"VirtualMachine.Interact.SetCDMedia",
	"VirtualMachine.Interact.PowerOn",
	"VirtualMachine.Interact.PowerOff",
	"VirtualMachine.Interact.ConsoleInteract",
	"VirtualMachine.Interact.Suspend",
	"VirtualMachine.Interact.Reset",
	"VirtualMachine.Interact.PowerOn",
	"VirtualMachine.Interact.ToolsInstall",
	"VirtualMachine.Interact.DeviceConnection", 
	"VirtualMachine.Config.AddExistingDisk",
	"VirtualMachine.Config.AddNewDisk",
	"VirtualMachine.Config.AddRemoveDevice",
	"VirtualMachine.Config.RemoveDisk",
	"VirtualMachine.Config.AdvancedConfig",
	"VirtualMachine.Config.CPUCount",
	"VirtualMachine.Config.Resource",
	"VirtualMachine.Config.DiskExtend",
	"VirtualMachine.Config.ChangeTracking",
	"VirtualMachine.Config.Memory",
	"VirtualMachine.Config.EditDevice",
	"VirtualMachine.Config.Rename",
	"VirtualMachine.Config.Annotation",
	"VirtualMachine.Config.Settings",
	"VirtualMachine.Config.SwapPlacement",
	"VirtualMachine.Provisioning.Customize",
	"VirtualMachine.Provisioning.CloneTemplate",
	"VirtualMachine.Provisioning.Clone",
	"VirtualMachine.Provisioning.DeployTemplate",
	"VirtualMachine.Provisioning.ReadCustSpecs",
	"VirtualMachine.State.CreateSnapshot",
	"VirtualMachine.State.RevertToSnapshot",
	"VirtualMachine.State.RemoveSnapshot"
	)
#Connect to vCenter
Connect-VIserver -server $vCenterServer -Credential (Get-Credential -Message "Enter vCenter Admin Credentials! ")
if ($global:DefaultVIServer.Name -eq $vCenterServer){
	Write-Host "Successfully connected to vCenter: $($vCenterServer)"
	#Configue the permission
  	New-VIRole -Server $vCenterServer -Name $rolename -Privilege (Get-VIPrivilege -id $vRA_Privilegeslist) | Out-Null
	
	Write-Host "Set Permissions for $vRA_User using the new $Rolename Role" -ForeGroundColor Yellow
	$rootFolder = Get-Folder -NoRecursion
	New-VIPermission -entity $rootFolder -Principal $vra_user -Role $rolename -Propagate:$true | Out-Null
 	Disconnect-VIServer-server $vCenterServer -Confirm:$false
}
