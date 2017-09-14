
[CmdletBinding()]
Param(
    [Parameter(Mandatory=$False,Position=1)]
    [string]$mainParametersFileName = "mainParemeters.psd1",
	
    [Parameter(Mandatory=$False,Position=2)]
    [string]$azureParametersFileName = "azureParameters.psd1"
)


Get-Date
$configParameters = Import-PowershellDataFile $mainParametersFileName;
$azureParameters = Import-PowershellDataFile $azureParametersFileName;
$commonDictionary = Import-PowershellDataFile commonDictionary.psd1;

$DomainName = $configParameters.DomainName;
$shortDomainName = $DomainName.Substring( 0, $DomainName.IndexOf( "." ) );

# examining, generating and requesting credentials

    $domainAdminUserName = $configParameters.DomainAdminUserName;
    if ( $domainAdminUserName )
    {
        $securedPassword = ConvertTo-SecureString $configParameters.DomainAdminPassword -AsPlainText -Force
        $shortDomainAdminCredential = New-Object System.Management.Automation.PSCredential( "$domainAdminUserName", $securedPassword )
    } else {
        $shortDomainAdminCredential = Get-Credential -Message "Credential with domain administrator privileges";
    }

    $domainAdminUserName = $configParameters.DomainAdminUserName;
    if ( $domainAdminUserName )
    {
        $securedPassword = ConvertTo-SecureString $configParameters.DomainAdminPassword -AsPlainText -Force
        $domainAdminCredential = New-Object System.Management.Automation.PSCredential( "$shortDomainName\$domainAdminUserName", $securedPassword )
    } else {
        $domainAdminCredential = Get-Credential -Message "Credential with domain administrator privileges";
    }
    #needed?
    $configParameters.DomainAdminCredential = $domainAdminCredential;

    $DomainSafeModeAdministratorPassword = $configParameters.DomainSafeModeAdministratorPassword;
    if ( $DomainSafeModeAdministratorPassword )
    {
        $securedPassword = ConvertTo-SecureString $configParameters.DomainSafeModeAdministratorPassword -AsPlainText -Force
        $DomainSafeModeAdministratorPasswordCredential = New-Object System.Management.Automation.PSCredential( "anyidentity", $securedPassword )
    } else {
        $DomainSafeModeAdministratorPasswordCredential = Get-Credential -Message "Enter any but not empty login and safe mode password";
    }
    $configParameters.DomainSafeModeAdministratorPasswordCredential = $DomainSafeModeAdministratorPasswordCredential;

    $localAdminUserName = $azureParameters.LocalAdminUserName;
    if ( $localAdminUserName )
    {
        $securedPassword = ConvertTo-SecureString $azureParameters.LocalAdminPassword -AsPlainText -Force
        $localAdminCredential = New-Object System.Management.Automation.PSCredential( "$localAdminUserName", $securedPassword )
    } else {
        $localAdminCredential = Get-Credential -Message "Credential with local administrator privileges";
    }

    $SPInstallAccountUserName = $configParameters.SPInstallAccountUserName;
    if ( $SPInstallAccountUserName )
    {
        $securedPassword = ConvertTo-SecureString $configParameters.SPInstallAccountPassword -AsPlainText -Force
        $SPInstallAccountCredential = New-Object System.Management.Automation.PSCredential( "$shortDomainName\$SPInstallAccountUserName", $securedPassword )
    } else {
        $SPInstallAccountCredential = Get-Credential -Message "Credential for SharePoint install account";
    }
    $configParameters.SPInstallAccountCredential = $SPInstallAccountCredential;

    $SPFarmAccountUserName = $configParameters.SPFarmAccountUserName;
    if ( $SPFarmAccountUserName )
    {
        $securedPassword = ConvertTo-SecureString $configParameters.SPFarmAccountPassword -AsPlainText -Force
        $SPFarmAccountCredential = New-Object System.Management.Automation.PSCredential( "$shortDomainName\$SPFarmAccountUserName", $securedPassword )
    } else {
        $SPFarmAccountCredential = Get-Credential -Message "Credential for SharePoint farm account";
    }
    $configParameters.SPFarmAccountCredential = $SPFarmAccountCredential;

    $SPWebAppPoolAccountUserName = $configParameters.SPWebAppPoolAccountUserName;
    if ( $SPWebAppPoolAccountUserName )
    {
        $securedPassword = ConvertTo-SecureString $configParameters.SPWebAppPoolAccountPassword -AsPlainText -Force
        $SPWebAppPoolAccountCredential = New-Object System.Management.Automation.PSCredential( "$shortDomainName\$SPWebAppPoolAccountUserName", $securedPassword )
    } else {
        $SPWebAppPoolAccountCredential = Get-Credential -Message "Credential for SharePoint Web Application app pool account";
    }
    $configParameters.SPWebAppPoolAccountCredential = $SPWebAppPoolAccountCredential;

    $SPServicesAccountUserName = $configParameters.SPServicesAccountUserName;
    if ( $SPServicesAccountUserName )
    {
        $securedPassword = ConvertTo-SecureString $configParameters.SPServicesAccountPassword -AsPlainText -Force
        $SPServicesAccountCredential = New-Object System.Management.Automation.PSCredential( "$shortDomainName\$SPServicesAccountUserName", $securedPassword )
    } else {
        $SPServicesAccountCredential = Get-Credential -Message "Credential for SharePoint shared services app pool";
    }
    $configParameters.SPServicesAccountCredential = $SPServicesAccountCredential;

    $SPSearchServiceAccountUserName = $configParameters.SPSearchServiceAccountUserName;
    if ( $SPSearchServiceAccountUserName )
    {
        $securedPassword = ConvertTo-SecureString $configParameters.SPSearchServiceAccountPassword -AsPlainText -Force
        $SPSearchServiceAccountCredential = New-Object System.Management.Automation.PSCredential( "$shortDomainName\$SPSearchServiceAccountUserName", $securedPassword )
    } else {
        $SPSearchServiceAccountCredential = Get-Credential -Message "Credential for SharePoint search service account";
    }
    $configParameters.SPSearchServiceAccountCredential = $SPSearchServiceAccountCredential;

    $SPCrawlerAccountUserName = $configParameters.SPCrawlerAccountUserName;
    if ( $SPCrawlerAccountUserName )
    {
        $securedPassword = ConvertTo-SecureString $configParameters.SPCrawlerAccountPassword -AsPlainText -Force;
        $SPCrawlerAccountCredential = New-Object System.Management.Automation.PSCredential( "$shortDomainName\$SPCrawlerAccountUserName", $securedPassword );
    } else {
        $SPCrawlerAccountCredential = Get-Credential -Message "Credential for SharePoint crawler account";
    }
    $configParameters.SPCrawlerAccountCredential = $SPCrawlerAccountCredential;

    $SPTestAccountUserName = $configParameters.SPTestAccountUserName;
    if ( $SPTestAccountUserName )
    {
        $securedPassword = ConvertTo-SecureString $configParameters.SPTestAccountPassword -AsPlainText -Force;
        $SPTestAccountCredential = New-Object System.Management.Automation.PSCredential( "$shortDomainName\$SPTestAccountUserName", $securedPassword );
    } else {
        $SPTestAccountCredential = Get-Credential -Message "Credential for SharePoint test user";
    }
    $configParameters.SPTestAccountCredential = $SPTestAccountCredential;

    $SPSecondTestAccountUserName = $configParameters.SPSecondTestAccountUserName;
    if ( $SPSecondTestAccountUserName )
    {
        $securedPassword = ConvertTo-SecureString $configParameters.SPSecondTestAccountPassword -AsPlainText -Force
        $SPSecondTestAccountCredential = New-Object System.Management.Automation.PSCredential( "$shortDomainName\$SPSecondTestAccountUserName", $securedPassword );
    } else {
        $SPSecondTestAccountCredential = Get-Credential -Message "Credential for SharePoint test user";
    }
    $configParameters.SPSecondTestAccountCredential = $SPSecondTestAccountCredential;

    $SPOCAccountPass = ConvertTo-SecureString "Any3ligiblePa`$`$" -AsPlainText -Force;
    $SPOCAccountCredential = New-Object System.Management.Automation.PSCredential( "anyusername", $SPOCAccountPass );
    $configParameters.SPOCAccountCredential = $SPOCAccountCredential

    $SQLPass = $configParameters.SQLPass;
    if ( $SQLPass )
    {
        $securedPassword = ConvertTo-SecureString $SQLPass -AsPlainText -Force
        $SQLPassCredential = New-Object System.Management.Automation.PSCredential( "anyidentity", $securedPassword )
    } else {
        $SQLPassCredential = Get-Credential -Message "Enter any user name and enter SQL SA password";
    }
    $configParameters.SQLPassCredential = $SQLPassCredential;

    $SPPassPhrase = $configParameters.SPPassPhrase;
    if ( $SPPassPhrase )
    {
        $securedPassword = ConvertTo-SecureString $SPPassPhrase -AsPlainText -Force
        $SPPassphraseCredential = New-Object System.Management.Automation.PSCredential( "anyidentity", $securedPassword )
    } else {
        $SPPassphraseCredential = Get-Credential -Message "Enter any user name and enter pass phrase in password field";
    }
    $configParameters.SPPassphraseCredential = $SPPassphraseCredential;

    $MediaShareUserName = $azureParameters.MediaShareUserName;
    if ( $MediaShareUserName )
    {
        $securedPassword = ConvertTo-SecureString $azureParameters.MediaSharePassword -AsPlainText -Force
        $MediaShareCredential = New-Object System.Management.Automation.PSCredential( "$MediaShareUserName", $securedPassword );
    } else {
        $MediaShareCredential = Get-Credential -Message "Credential for media shared folder";
    }

# credentials are ready

$resourceGroupName = $azureParameters.ResourceGroupName;
$resourceGroupLocation = $azureParameters.ResourceGroupLocation;
$vnetName = ( $resourceGroupName + "VNet");

$subscription = $null;
$subscription = Get-AzureRmSubscription;
if ( !$subscription )
{
    Write-Host "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
    Write-Host "||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||"
    Write-Host "||||||||||||||||||Don't worry about this error above||||||||||||||||||"
    Login-AzureRmAccount | Out-Null;
}

if ( $azureParameters.DeleteResourceGroup )
{
    Write-Progress -Activity 'Deploying SharePoint farm in Azure' -PercentComplete 0 -id 1 -CurrentOperation "Purging existing resource group";
    $resourceGroup = Get-AzureRmResourceGroup $resourceGroupName -ErrorAction Ignore;
    if ( $resourceGroup )
    {
        Remove-AzureRmResourceGroup -Name $azureParameters.ResourceGroupName -Force | Out-Null;
    }
}

if ( $azureParameters.PrepareResourceGroup )
{
    Write-Progress -Activity 'Deploying SharePoint farm in Azure' -PercentComplete 1 -id 1 -CurrentOperation "Resource group promotion";
    $resourceGroup = Get-AzureRmResourceGroup $resourceGroupName -ErrorAction Ignore;
    if ( !$resourceGroup )
    {
        $resourceGroup = New-AzureRmResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation;
    }

    $vnet = Get-AzureRmVirtualNetwork -ResourceGroupName $resourceGroupName -Name $vnetName -ErrorAction Ignore;
    if ( !$vnet )
    {
        $SubnetIpAddress = $azureParameters.SubnetIpAddress;
        $subnetConfig = New-AzureRmVirtualNetworkSubnetConfig -Name ( $resourceGroupName + "Subnet" ) -AddressPrefix "$SubnetIpAddress/24";
        $vnet = New-AzureRmVirtualNetwork -ResourceGroupName $resourceGroupName -Location $resourceGroupLocation -Name $vnetName -AddressPrefix "$SubnetIpAddress/16" -Subnet $subnetConfig;
    }
    $subnetId = $vnet.Subnets[0].Id;

    $storageAccounts = Get-AzureRmStorageAccount -ResourceGroupName $resourceGroupName -ErrorAction Ignore;
    if ( !$storageAccounts )
    {
        $storageAccountNameLong = [guid]::NewGuid().Guid.Replace("-","");
        $storageAccountName = $storageAccountNameLong.Substring( 0, [System.Math]::Min( 24, $storageAccountNameLong.Length ) ).ToLower();
        New-AzureRmStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountName -Location $resourceGroupLocation `
            -SkuName "Standard_LRS" -Kind "Storage" | Out-Null;
    }    
}
$storageAccounts = Get-AzureRmStorageAccount -ResourceGroupName $resourceGroupName
$storageAccountName = $storageAccounts[0].StorageAccountName;

function CreateMachine ( $machineParameters ) {
    $machineName = $machineParameters.Name;
    Write-Host "$(Get-Date) Creating $machineName machine"
    $publicIpName = ( $machineName + "IP" );
    $pip = Get-AzureRmPublicIpAddress -ResourceGroupName $resourceGroupName -Name $publicIpName -ErrorAction Ignore;
    if ( !$pip )
    {
        $pip = New-AzureRmPublicIpAddress -ResourceGroupName $resourceGroupName -Location $resourceGroupLocation -AllocationMethod Dynamic -IdleTimeoutInMinutes 4 -Name $publicIpName;
    }

    $nsgName = ( $machineName + "-ngs")
    $nsg = Get-AzureRmNetworkSecurityGroup -ResourceGroupName $resourceGroupName -Name $nsgName -ErrorAction Ignore;
    if ( !$nsg )
    {
        $nsgRuleRDP = New-AzureRmNetworkSecurityRuleConfig -Name RDP -Protocol Tcp `
            -Direction Inbound -Priority 1000 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * `
            -DestinationPortRange 3389 -Access Allow;
        $nsg = New-AzureRmNetworkSecurityGroup -ResourceGroupName $resourceGroupName -Location $resourceGroupLocation -Name $nsgName -SecurityRules $nsgRuleRDP;
        if ( $machineParameters.Roles -contains "WFE" )
        {
            $nsg | Add-AzureRmNetworkSecurityRuleConfig -Name Web -Protocol Tcp `
                -Direction Inbound -Priority 1001 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * `
                -DestinationPortRange 80 -Access Allow | Out-Null;
            $nsg | Set-AzureRmNetworkSecurityGroup | Out-Null;
        }
    }

    $nicName = ( $machineName + "NIC" )
    $nic = Get-AzureRmNetworkInterface -ResourceGroupName $resourceGroupName -Name $nicName -ErrorAction Ignore;
    if ( !$nic )
    {
        $nic = New-AzureRmNetworkInterface -Name $nicName -ResourceGroupName $resourceGroupName -Location $resourceGroupLocation `
            -SubnetId $subnetId -PublicIpAddressId $pip.Id -NetworkSecurityGroupId $nsg.Id
    }

    #Check machine sizes: Get-AzureRmVMSize -Location westeurope
    if ( $machineParameters.Memory -le 1.5 ) { $VMSize = "Basic_A1" } else { $VMSize = "Standard_D11_v2" }
    if ( $machineParameters.Memory -gt 14 ) { $VMSize = "Standard_D12_v2" }
    # Check SKUS: Get-AzureRmVMImageSku -Location westeurope -PublisherName MicrosoftWindowsServer -Offer WindowsServer
    $offer = "WindowsServer";
    $skusPrefix = "2016";
    if ( $machineParameters.WinVersion -eq "2012" ) { $skusPrefix = "2012" }
    if ( $machineParameters.WinVersion -eq "2012R2" ) { $skusPrefix = "2012-R2" }
    if ( $machineParameters.DiskSize -le 30 ) { $skus = "$skusPrefix-Datacenter-smalldisk" } else { $skus = "$skusPrefix-Datacenter" }
    if ( $machineParameters.WinVersion -eq "10" ) { $offer = "Windows"; $skus = "Windows10-RS2-Pro" }
    
    if ( $machineParameters.Roles -contains "AD" ) { $vmCredential = $ShortDomainAdminCredential } else { $vmCredential = $LocalAdminCredential }

    $imageParameter = $machineParameters.Image;
    if ( $imageParameter -and ( $imageParameter -ne "" ) )
    {
        $image = $null;
        $image = Get-AzureRMImage -ResourceGroupName $azureParameters.ImageResourceGroupName -ImageName $machineParameters.Image;
        $vmConfig = New-AzureRmVMConfig -VMName $machineName -VMSize $VMSize | `
            Set-AzureRmVMOperatingSystem -Windows -ComputerName $machineName -Credential $vmCredential | `
            Set-AzureRmVMSourceImage -Id $image.Id | `
            Add-AzureRmVMNetworkInterface -Id $nic.Id
    } else {
        $vmConfig = New-AzureRmVMConfig -VMName $machineName -VMSize $VMSize | `
            Set-AzureRmVMOperatingSystem -Windows -ComputerName $machineName -Credential $vmCredential | `
            Set-AzureRmVMSourceImage -PublisherName MicrosoftWindowsServer -Offer $offer -Skus $skus -Version latest | `
            Add-AzureRmVMNetworkInterface -Id $nic.Id
    }
    New-AzureRmVM -ResourceGroupName $resourceGroupName -Location $resourceGroupLocation -VM $vmConfig | Out-Null;
}

function PrepareMachine ( $machineParameters ) {
    $machineName = $machineParameters.Name;
    if ( $azureParameters.PrepareMachines )
    {
        if ( $machineParameters.WinVersion -eq "2012" ) {
            Write-Progress -Activity "Preparing $machineName machine" -PercentComplete 10 -ParentId 1 -CurrentOperation "Preparing Windows 2012 on $machineName";            
            $containerName = "psscripts";
            $fileName = "Win2012Prepare.ps1"
            Set-AzureRmCurrentStorageAccount -StorageAccountName $storageAccountName -ResourceGroupName $resourceGroupName;
            $existingStorageContainer = $null;
            $existingStorageContainer = Get-AzureStorageContainer $containerName -ErrorAction SilentlyContinue;
            if ( !$existingStorageContainer )
            {
                New-AzureStorageContainer -Name $containerName -Permission Off | Out-Null;
            }
            Set-AzureStorageBlobContent -Container $containerName -File $fileName -Force | Out-Null;
            Set-AzureRmVMCustomScriptExtension -VM $machineName -ContainerName $containerName -FileName $fileName -Name $fileName -ResourceGroupName $resourceGroupName -Location $resourceGroupLocation -StorageAccountName $storageAccountName;
            Remove-AzureRmVMCustomScriptExtension -ResourceGroupName $resourceGroupName -VMName $machineName -Name $fileName -Force | Out-Null;
        }
        if ( $machineParameters.Roles -contains "AD" )
        {
            Write-Progress -Activity "Preparing $machineName machine" -PercentComplete 15 -ParentId 1 -CurrentOperation "Installing AD role on $machineName";            
            if ( $azureParameters.ADInstall )
            {
                $configName = "DomainInstall"
                $configFileName = ".\DSC\$configName.ps1";
                Write-Host "$(Get-Date) Deploying $configName extension on $machineName"
                Publish-AzureRmVMDscConfiguration $configFileName -ResourceGroupName $resourceGroupName -StorageAccountName $storageAccountName -Force | Out-Null;
                Set-AzureRmVmDscExtension -Version 2.71 -ResourceGroupName $resourceGroupName -VMName $machineName -ArchiveStorageAccountName $storageAccountName -ArchiveBlobName "$configName.ps1.zip" -AutoUpdate:$true -ConfigurationName $configName -Verbose -Force -ErrorAction Inquire;
            }
        }
        if ( $machineParameters.Roles -contains "SQL" )
        {
            Write-Progress -Activity "Preparing $machineName machine" -PercentComplete 20 -ParentId 1 -CurrentOperation "Loading SQL installation files on $machineName";            
            if ( ( $azureParameters.SQLMediaSource -eq "Public" ) -or $azureParameters.SQLImageUnpack )
            {
                $configName = "SQLLoadingInstallationFiles";
                $configFileName = ".\DSC\$configName.ps1";
                Write-Host "$(Get-Date) Deploying $configName extension on $machineName"
                Publish-AzureRmVMDscConfiguration $configFileName -ResourceGroupName $resourceGroupName -StorageAccountName $storageAccountName -Force | Out-Null;
                $configurationArguments = @{
                    ConfigParameters = $configParameters
                    SystemParameters = $azureParameters
                    CommonDictionary = $commonDictionary
                    MediaShareCredential = $MediaShareCredential
                }
                Set-AzureRmVmDscExtension -Version 2.71 -ResourceGroupName $resourceGroupName -VMName $machineName -ArchiveStorageAccountName $storageAccountName -ArchiveBlobName "$configName.ps1.zip" -AutoUpdate:$true -ConfigurationName $configName -Verbose -Force -ConfigurationArgument $configurationArguments -ErrorAction Inquire;
            }
            Write-Progress -Activity "Preparing $machineName machine" -PercentComplete 25 -CurrentOperation "SQL server installation on $machineName" -ParentId 1;
            if ( $azureParameters.SQLInstall )
            {
                $configName = "SQLInstall";
                $configFileName = ".\DSC\$configName.ps1";
                Write-Host "$(Get-Date) Deploying $configName extension on $machineName"
                Publish-AzureRmVMDscConfiguration $configFileName -ResourceGroupName $resourceGroupName -StorageAccountName $storageAccountName -Force | Out-Null;
                $configurationArguments = @{
                    configParameters = $configParameters
                    SQLPassCredential = $SQLPassCredential
                    LocalAdminCredential = $LocalAdminCredential
                    MachineName = $machineName
                }
                Set-AzureRmVmDscExtension -Version 2.71 -ResourceGroupName $resourceGroupName -VMName $machineName -ArchiveStorageAccountName $storageAccountName -ArchiveBlobName "$configName.ps1.zip" -AutoUpdate:$true -ConfigurationName $configName -Verbose -Force -ConfigurationArgument $configurationArguments -ErrorAction Inquire;
            }
        }
        if ( $machineParameters.Roles -contains "SharePoint" )
        {
            if ( $SPVersion -eq "2013" )
            {
                Write-Progress -Activity "Preparing $machineName machine" -PercentComplete 35 -CurrentOperation "Preparing $machineName for installing SP 2013" -ParentId 1;
                $configName = "SP2013Prepare";
                $configFileName = ".\DSC\$configName.ps1";
                Write-Host "$(Get-Date) Deploying $configName extension on $machineName"
                Publish-AzureRmVMDscConfiguration $configFileName -ResourceGroupName $resourceGroupName -StorageAccountName $storageAccountName -Force | Out-Null;
                $configurationArguments = @{
                    ConfigParameters = $configParameters
                }
                Set-AzureRmVmDscExtension -Version 2.71 -ResourceGroupName $resourceGroupName -VMName $machineName -ArchiveStorageAccountName $storageAccountName -ArchiveBlobName "$configName.ps1.zip" -AutoUpdate:$true -ConfigurationName $configName -Verbose -Force -ConfigurationArgument $configurationArguments -ErrorAction Inquire;
            }
            if ( ( $azureParameters.SPMediaSource -eq "Public" ) -or ( $azureParameters.SPMediaSource -eq "AzureBlobImage" ) -or $azureParameters.SPImageUnpack )
            {
                Write-Progress -Activity "Preparing $machineName machine" -PercentComplete 40 -CurrentOperation "Downloading SP media on $machineName" -ParentId 1;
                $containerName = "psscripts";
                $fileName = "AutoSPSourceBuilder\AutoSPSourceBuilder.ps1"
                Set-AzureRmCurrentStorageAccount -StorageAccountName $azureParameters.ImageStorageAccount -ResourceGroupName $azureParameters.ImageResourceGroupName | Out-Null;
                $existingStorageContainer = $null;
                $existingStorageContainer = Get-AzureStorageContainer $containerName -ErrorAction SilentlyContinue;
                if ( !$existingStorageContainer )
                {
                    New-AzureStorageContainer -Name $containerName -Permission Off | Out-Null;
                }
                Set-AzureStorageBlobContent -Container $containerName -File $fileName -Force | Out-Null;

                $configName = "SPLoadingInstallationFiles";
                $configFileName = ".\DSC\$configName.ps1";
                Write-Host "$(Get-Date) Deploying $configName extension on $machineName"
                Publish-AzureRmVMDscConfiguration $configFileName -ResourceGroupName $resourceGroupName -StorageAccountName $storageAccountName -Force | Out-Null;
                $key = Get-AzureRmStorageAccountKey -ResourceGroupName $azureParameters.ImageResourceGroupName -Name $azureParameters.ImageStorageAccount | ? { $_.KeyName -eq "key1" }
                $configurationArguments = @{
                    ConfigParameters = $configParameters
                    SystemParameters = $azureParameters
                    CommonDictionary = $commonDictionary
                    AzureStorageAccountKey = $key.Value
                    MediaShareCredential = $MediaShareCredential
                }
                Set-AzureRmVmDscExtension -Version 2.71 -ResourceGroupName $resourceGroupName -VMName $machineName -ArchiveStorageAccountName $storageAccountName -ArchiveBlobName "$configName.ps1.zip" -AutoUpdate:$true -ConfigurationName $configName -Verbose -Force -ConfigurationArgument $configurationArguments -ErrorAction Inquire;
            }
            if ( $azureParameters.SPInstall )
            {
                Write-Progress -Activity "Preparing $machineName machine" -PercentComplete 50 -CurrentOperation "SharePoint binaries installation $machineName" -ParentId 1;
                $configName = "SPInstall";
                $configFileName = ".\DSC\$configName.ps1";
                Write-Host "$(Get-Date) Deploying $configName extension on $machineName"
                Publish-AzureRmVMDscConfiguration $configFileName -ResourceGroupName $resourceGroupName -StorageAccountName $storageAccountName -Force | Out-Null;
                $configurationArguments = @{
                    ConfigParameters = $configParameters
                    CommonDictionary = $commonDictionary
                }
                Set-AzureRmVmDscExtension -Version 2.71 -ResourceGroupName $resourceGroupName -VMName $machineName -ArchiveStorageAccountName $storageAccountName -ArchiveBlobName "$configName.ps1.zip" -AutoUpdate:$true -ConfigurationName $configName -Verbose -Force -ConfigurationArgument $configurationArguments -ErrorAction Inquire;
            }
        }
        if ( $machineParameters.Roles -contains "Code" )
        {
            if ( $azureParameters.CodeToolsInstallation )
            {
                Write-Progress -Activity 'Code tools installing' -PercentComplete 55 -CurrentOperation $machineName -ParentId 1;
                $configName = "SPCodeTools"
                $configFileName = ".\DSC\$configName.ps1";
                Write-Host "$(Get-Date) Deploying $configName extension on $machineName"
                Publish-AzureRmVMDscConfiguration $configFileName -ResourceGroupName $resourceGroupName -StorageAccountName $storageAccountName -Force | Out-Null;
                $configurationArguments = @{
                    ConfigParameters = $configParameters
                    CommonDictionary = $commonDictionary
                }
                Set-AzureRmVmDscExtension -Version 2.71 -ResourceGroupName $resourceGroupName -VMName $machineName -ArchiveStorageAccountName $storageAccountName -ArchiveBlobName "$configName.ps1.zip" -AutoUpdate:$true -ConfigurationName $configName -Verbose -Force -ConfigurationArgument $configurationArguments -ErrorAction Inquire;
            }
        }
        if ( $machineParameters.Roles -contains "Configuration" )
        {
            if ( $azureParameters.ConfigurationToolsInstallation )
            {
                Write-Progress -Activity 'Configuration tools installing' -PercentComplete 58 -CurrentOperation $machineName -ParentId 1;
                $configName = "SPConfigurationTools"
                $configFileName = ".\DSC\$configName.ps1";
                Write-Host "$(Get-Date) Deploying $configName extension on $machineName"
                Publish-AzureRmVMDscConfiguration $configFileName -ResourceGroupName $resourceGroupName -StorageAccountName $storageAccountName -Force | Out-Null;
                $configurationArguments = @{
                    ConfigParameters = $configParameters
                    CommonDictionary = $commonDictionary
                }
                Set-AzureRmVmDscExtension -Version 2.71 -ResourceGroupName $resourceGroupName -VMName $machineName -ArchiveStorageAccountName $storageAccountName -ArchiveBlobName "$configName.ps1.zip" -AutoUpdate:$true -ConfigurationName $configName -Verbose -Force -ConfigurationArgument $configurationArguments -ErrorAction Inquire;
            }
        }
    }
}

$SPVersion = $configParameters.SPVersion;
if ( $SPVersion -eq "2013" ) { $SQLVersion = "2014" } else { $SQLVersion = "2016" }

$azurePreparationPercentage = 3;
$numberOfMachines = $configParameters.Machines.Count
$machinePercentage = ( 70 - $azurePreparationPercentage ) / ( $numberOfMachines )

$machineCounter = 0;
$vnet = Get-AzureRmVirtualNetwork -ResourceGroupName $resourceGroupName -Name $vnetName;
$subnetId = $vnet.Subnets[0].Id;

$configParameters.Machines | % {
    $machineName = $_.Name;
    Write-Progress -Activity 'Deploying SharePoint farm in Azure' -PercentComplete ( $azurePreparationPercentage + $machineCounter * $machinePercentage ) -id 1 -CurrentOperation "Preparing $machineName machine" ;
    $vm = Get-AzureRmVM -ResourceGroupName $resourceGroupName -Name $machineName -ErrorAction Ignore;
    if ( $_.Image -and ( $_.Image -ne "" ) )
    {
        if ( !$vm )
        {
            $image = $null;
            $imageName = $_.Image
            $image = Get-AzureRMImage -ResourceGroupName $azureParameters.ImageResourceGroupName | ? { $_.Name -eq $imageName }
            if ( !$image ) {
                $templateMachineName = "templatemachine";
                Write-Host "$(Get-Date) Creating $templateMachineName temporary"
                $templateMachineParameters = @{
                    Name = $templateMachineName
                    Roles = $_.Roles
                    Memory = $_.Memory
                    DiskSize = $_.DiskSize
                    WinVersion = $_.WinVersion
                }
                Write-Progress -Activity "Preparing $machineName machine" -PercentComplete 0 -ParentId 1 -CurrentOperation "Creating $templateMachineName temporary";
                CreateMachine $templateMachineParameters;  
                PrepareMachine $templateMachineParameters;
                if ( $azureParameters.PauseBeforeImaging )
                {
                    Write-Host "$(Get-Date) Apply the changes in the template machine before the image is taken. Then press any key"
                    $host.UI.RawUI.ReadKey() | Out-Null
                }
                Write-Progress -Activity "Preparing $machineName machine" -PercentComplete 60 -ParentId 1 -CurrentOperation "Extracting image from template VM $templateMachineName";
                Write-Host "$(Get-Date) Removing DSC extension from $templateMachineName"
                Remove-AzureRmVMDscExtension -ResourceGroupName $resourceGroupName -VMName $templateMachineName;
                Write-Host "$(Get-Date) Deploying sysprep extension on $templateMachineName"
                $containerName = "psscripts";
                $fileName = "sysprep.ps1";
                Set-AzureRmCurrentStorageAccount -StorageAccountName $storageAccountName -ResourceGroupName $resourceGroupName | Out-Null;
                $existingStorageContainer = $null;
                $existingStorageContainer = Get-AzureStorageContainer $containerName -ErrorAction SilentlyContinue;
                if ( !$existingStorageContainer )
                {
                    New-AzureStorageContainer -Name $containerName -Permission Off | Out-Null;
                }
                Set-AzureStorageBlobContent -Container $containerName -File $fileName -Force | Out-Null;
                Set-AzureRmVMCustomScriptExtension -VM $templateMachineName -ContainerName $containerName -FileName $fileName -Name $fileName -ResourceGroupName $resourceGroupName -Location $resourceGroupLocation -StorageAccountName $storageAccountName
                Write-Host "$(Get-Date) Waiting until $templateMachineName shuts down"
                Do {
                    Sleep 3;
                    $vm = Get-AzureRmVM -Status | ? { ( $_.ResourceGroupName -eq $resourceGroupName ) -and ( $_.Name -eq $templateMachineName ) }
                    $vmState = $vm.PowerState;
                } while ( $vmState -ne "VM stopped" )
                Write-Host "$(Get-Date) Deallocating $templateMachineName"
                Stop-AzureRmVM -ResourceGroupName $resourceGroupName -Name $templateMachineName -Force | Out-Null
                Write-Host "$(Get-Date) Extracting image $templateMachineName"
                Set-AzureRmVm -ResourceGroupName $resourceGroupName -Name $templateMachineName -Generalized | Out-Null
                $vm = Get-AzureRmVM -ResourceGroupName $resourceGroupName -Name $templateMachineName;
                $image = New-AzureRmImageConfig -Location $resourceGroupLocation -SourceVirtualMachineId $vm.ID;
                New-AzureRmImage -Image $image -ImageName $_.Image -ResourceGroupName $azureParameters.ImageResourceGroupName | Out-Null;
                Write-Progress -Activity "Preparing $machineName machine" -PercentComplete 70 -ParentId 1 -CurrentOperation "Removing template machine $templateMachineName";
                Write-Host "$(Get-Date) Removing template machine $templateMachineName";
                $vm = Get-AzureRmVM $resourceGroupName $templateMachineName;
                $diskName = $vm.StorageProfile.OsDisk.Name;
                Remove-AzureRmVm -ResourceGroupName $resourceGroupName -Name $templateMachineName -Force | Out-Null;
                Remove-AzureRmDisk -ResourceGroupName $resourceGroupName -Name $diskName -Force;
                Write-Progress -Activity "Preparing $machineName machine" -PercentComplete 80 -ParentId 1 -CurrentOperation "Creating $machineName machine via template";
            } else {
                Write-Progress -Activity "Preparing $machineName machine" -PercentComplete 0 -ParentId 1 -CurrentOperation "Creating $machineName machine via template";
            }
            CreateMachine $_;
        }
        if ( $azureParameters.PrepareMachinesAfterImage )
        {
            PrepareMachine $_;
        }
    } else {
        if ( !$vm )
        {
            Write-Progress -Activity "Preparing $machineName machine" -PercentComplete 0 -ParentId 1 -CurrentOperation "Creating $machineName machine";            
            CreateMachine $_;
        }
        PrepareMachine $_;
    }
    if ( $_.Roles -contains "AD" )
    {
        $vm = Get-AzureRmVM -ResourceGroupName $resourceGroupName -VMName $machineName;
        $networkInterfaceRef = $vm.NetworkProfile[0].NetworkInterfaces[0].id;
        $networkInterface = Get-AzureRmNetworkInterface | ? { $_.Id -eq $networkInterfaceRef }
        $networkInterface.IpConfigurations[0].PrivateIpAllocationMethod = "Static"
        Set-AzureRmNetworkInterface -NetworkInterface $networkInterface | Out-Null;

        $vnet = Get-AzureRmVirtualNetwork -ResourceGroupName $resourceGroupName -name $vnetName;
        $vnet.DhcpOptions.DnsServers = $networkInterface.IpConfigurations[0].PrivateIpAddress;
        $vnet.DhcpOptions.DnsServers += "8.8.8.8";
        Set-AzureRmVirtualNetwork -VirtualNetwork $vnet | Out-Null;
    }
    $machineCounter++;
}

#Domain deploying
Write-Progress -Activity 'Configuring Active Directory' -PercentComplete 70 -id 1;
if ( $azureParameters.ADConfigure )
{
    $ADMachines = $configParameters.Machines | ? { $_.Roles -contains "AD" }
    $ADMachines | % {
        $machineName = $_.Name;
        Write-Progress -Activity 'Configuring domain' -PercentComplete 10 -CurrentOperation $machineName -ParentId 1;
        <#
        if ( $_.Image -and ( $_.Image -ne "" ) )
        {
            Write-Progress -Activity 'Configuring preparing DC machine from the image' -PercentComplete 10 -CurrentOperation $machineName -ParentId 1;
            $configName = "DomainInstall"
            $configFileName = ".\DSC\$configName.ps1";
            Write-Host "$(Get-Date) Deploying $configName extension on $machineName"
            Publish-AzureRmVMDscConfiguration $configFileName -ResourceGroupName $resourceGroupName -StorageAccountName $storageAccountName -Force | Out-Null;
            Set-AzureRmVmDscExtension -Version 2.71 -ResourceGroupName $resourceGroupName -VMName $machineName -ArchiveStorageAccountName $storageAccountName -ArchiveBlobName "$configName.ps1.zip" -AutoUpdate:$true -ConfigurationName $configName -Verbose -Force -ErrorAction Inquire;
            Write-Progress -Activity 'Configuring domain' -PercentComplete 40 -CurrentOperation $machineName -ParentId 1;
        } else {
            Write-Progress -Activity 'Configuring domain' -PercentComplete 10 -CurrentOperation $machineName -ParentId 1;
        }
        #>
        <#
        if ( $_.Image -and ( $_.Image -ne "" ) )
        {
            Write-Host "$(Get-Date) Press any key when you want to install the extension"
            $host.UI.RawUI.ReadKey() | Out-Null
        }
        #>

        $configName = "SPDomain"
        $configFileName = ".\DSC\$configName.ps1";
        Write-Host "$(Get-Date) Deploying $configName extension on $machineName"
        Publish-AzureRmVMDscConfiguration $configFileName -ResourceGroupName $resourceGroupName -StorageAccountName $storageAccountName -Force | Out-Null;
        $configurationArguments = @{
            configParameters = $configParameters
            ShortDomainAdminCredential = $ShortDomainAdminCredential
            DomainSafeModeAdministratorPasswordCredential = $DomainSafeModeAdministratorPasswordCredential
            SPInstallAccountCredential = $SPInstallAccountCredential
            SPFarmAccountCredential = $SPFarmAccountCredential
            SPWebAppPoolAccountCredential = $SPWebAppPoolAccountCredential
            SPServicesAccountCredential = $SPServicesAccountCredential
            SPSearchServiceAccountCredential = $SPSearchServiceAccountCredential
            SPCrawlerAccountCredential = $SPCrawlerAccountCredential
            SPOCAccountCredential = $SPOCAccountCredential
            SPTestAccountCredential = $SPTestAccountCredential
            SPSecondTestAccountCredential = $SPSecondTestAccountCredential
            MachineName = $machineName
        }
        Set-AzureRmVmDscExtension -Version 2.71 -ResourceGroupName $resourceGroupName -VMName $machineName -ArchiveStorageAccountName $storageAccountName -ArchiveBlobName "$configName.ps1.zip" -AutoUpdate:$true -ConfigurationName $configName -Verbose -Force -ConfigurationArgument $configurationArguments -ErrorAction Inquire;
    }
}

Write-Progress -Activity 'Joining domain' -PercentComplete 75 -id 1;
if ( $azureParameters.JoinDomain )
{
    $firstAdVMName = $null;
    $configParameters.Machines | ? { $_.Roles -contains "AD" } | % {
        if ( !$firstAdVMName ) { $firstAdVMName = $_.Name }
    }
    $domainClientMachines = $configParameters.Machines | ? { !( $_.Roles -contains "AD" ) }
    $domainClientMachines | % {
        $machineName = $_.Name;
        Write-Progress -Activity 'Joining domain' -PercentComplete 10 -CurrentOperation $machineName -ParentId 1;
        $configName = "DomainClient"
        $configFileName = ".\DSC\$configName.ps1";
        Write-Host "$(Get-Date) Deploying $configName extension on $machineName"
        $configurationDataString = '@{ AllNodes = @( @{ NodeName = "' + $machineName + '"; PSDscAllowPlainTextPassword = $True } ) }';
        $tempConfigDataFilePath = $env:TEMP + "\tempconfigdata.psd1"
        $configurationDataString | Set-Content -Path $tempConfigDataFilePath
        Publish-AzureRmVMDscConfiguration $configFileName -ConfigurationDataPath $tempConfigDataFilePath -ResourceGroupName $resourceGroupName -StorageAccountName $storageAccountName -Force | Out-Null;
        $configurationArguments = @{
            ConfigParameters = $configParameters
            SystemParameters = $azureParameters
            DomainAdminCredential = $DomainAdminCredential
        }
        Set-AzureRmVmDscExtension -Version 2.7 -ResourceGroupName $resourceGroupName -VMName $machineName -ArchiveStorageAccountName $storageAccountName -ArchiveBlobName "$configName.ps1.zip" -AutoUpdate:$true -ConfigurationName $configName -Verbose -Force -ConfigurationArgument $configurationArguments -ErrorAction Inquire;
    }
}

Write-Progress -Activity 'Configuring SharePoint farm' -PercentComplete 85 -id 1;
if ( $azureParameters.ConfigureSharePoint )
{

    $SPMachines = $configParameters.Machines | ? { $_.Roles -contains "SharePoint" }
    $SPMachineNames = $SPMachines | % { $_.Name }
    if ( $SPMachineNames.Count -gt 1 )
    {
        $SPMachines | % {
            $machineName = $_.Name;
            Write-Progress -Activity 'Applying SharePoint configuration' -PercentComplete 10 -CurrentOperation $machineName -ParentId 1;
            $configName = "SPFarm";
            $configFileName = ".\DSC\$configName.ps1";
            Write-Host "$(Get-Date) Deploying $configName extension on $machineName (except Search granule)"
            $configurationDataString = '@{ AllNodes = @( @{ NodeName = "' + $machineName + '"; PSDscAllowPlainTextPassword = $True } ) }';
            $tempConfigDataFilePath = $env:TEMP + "\tempconfigdata.psd1"
            $configurationDataString | Set-Content -Path $tempConfigDataFilePath
            Publish-AzureRmVMDscConfiguration $configFileName -ConfigurationDataPath $tempConfigDataFilePath -ResourceGroupName $resourceGroupName -StorageAccountName $storageAccountName -Force | Out-Null;
            $configurationArguments = @{
                ConfigParameters = $configParameters
                SPPassphraseCredential = $SPPassphraseCredential
                SPInstallAccountCredential = $SPInstallAccountCredential
                SPFarmAccountCredential = $SPFarmAccountCredential
                SPWebAppPoolAccountCredential = $SPWebAppPoolAccountCredential
                SPServicesAccountCredential = $SPServicesAccountCredential
                SPSearchServiceAccountCredential = $SPSearchServiceAccountCredential
                SPCrawlerAccountCredential = $SPCrawlerAccountCredential
                GranularApplying = $true
            }
            Set-AzureRmVmDscExtension -Version 2.71 -ResourceGroupName $resourceGroupName -VMName $machineName -ArchiveStorageAccountName $storageAccountName -ArchiveBlobName "$configName.ps1.zip" -AutoUpdate:$true -ConfigurationName $configName -Verbose -Force -ConfigurationArgument $configurationArguments -ErrorAction Inquire;
        }

        $SearchQueryMachines = $configParameters.Machines | ? { $_.Roles -contains "SearchQuery" }
        $SearchQueryMachines | % {
            $machineName = $_.Name;
            Write-Progress -Activity 'Configuring SharePoint Search Topology' -PercentComplete 90 -CurrentOperation $machineName -ParentId 1;
            $configurationArguments = @{
                ConfigParameters = $configParameters
                SPPassphraseCredential = $SPPassphraseCredential
                SPInstallAccountCredential = $SPInstallAccountCredential
                SPFarmAccountCredential = $SPFarmAccountCredential
                SPWebAppPoolAccountCredential = $SPWebAppPoolAccountCredential
                SPServicesAccountCredential = $SPServicesAccountCredential
                SPSearchServiceAccountCredential = $SPSearchServiceAccountCredential
                SPCrawlerAccountCredential = $SPCrawlerAccountCredential
                GranularApplying = $true
                SearchTopologyGranule = $true
            }
            $configurationDataString = '@{ AllNodes = @( @{ NodeName = "' + $machineName + '"; PSDscAllowPlainTextPassword = $True } ) }';
            $tempConfigDataFilePath = $env:TEMP + "\tempconfigdata.psd1"
            $configurationDataString | Set-Content -Path $tempConfigDataFilePath
            $configName = "SPFarm";
            $configFileName = ".\DSC\$configName.ps1";
            Write-Host "$(Get-Date) Deploying $configName extension on $machineName (Search granule)"
            if ( $configParameters.SPVersion -eq "2013" ) { $configFileName = ".\DSC\SP2013.ps1" } else { $configFileName = ".\DSC\SP2016.ps1" }
            Publish-AzureRmVMDscConfiguration $configFileName -ConfigurationDataPath $tempConfigDataFilePath -ResourceGroupName $resourceGroupName -StorageAccountName $storageAccountName -Force | Out-Null;
            Remove-Item $tempConfigDataFilePath;
            Set-AzureRmVmDscExtension -Version 2.71 -ResourceGroupName $resourceGroupName -VMName $_.Name -ArchiveStorageAccountName $storageAccountName -ArchiveBlobName "$configName.ps1.zip" -AutoUpdate:$true -ConfigurationName $configName -Verbose -Force -ConfigurationArgument $configurationArguments -ErrorAction Inquire;
        }
    }
    if ( $SPMachineNames.Count -eq 1 )
    {
        $SPMachines | % {
    
            $machineName = $_.Name;
            Write-Progress -Activity 'Applying SharePoint configuration' -PercentComplete 10 -CurrentOperation $machineName -ParentId 1;
            $configName = "SPFarm";
            $configFileName = ".\DSC\$configName.ps1";
            Write-Host "$(Get-Date) Deploying $configName extension on $machineName"
            $configurationDataString = '@{ AllNodes = @( @{ NodeName = "' + $machineName + '"; PSDscAllowPlainTextPassword = $True } ) }';
            $tempConfigDataFilePath = $env:TEMP + "\tempconfigdata.psd1"
            $configurationDataString | Set-Content -Path $tempConfigDataFilePath
            Publish-AzureRmVMDscConfiguration $configFileName -ConfigurationDataPath $tempConfigDataFilePath -ResourceGroupName $resourceGroupName -StorageAccountName $storageAccountName -Force | Out-Null;
            $configurationArguments = @{
                ConfigParameters = $configParameters
                SPPassphraseCredential = $SPPassphraseCredential
                SPInstallAccountCredential = $SPInstallAccountCredential
                SPFarmAccountCredential = $SPFarmAccountCredential
                SPWebAppPoolAccountCredential = $SPWebAppPoolAccountCredential
                SPServicesAccountCredential = $SPServicesAccountCredential
                SPSearchServiceAccountCredential = $SPSearchServiceAccountCredential
                SPCrawlerAccountCredential = $SPCrawlerAccountCredential
            }
            Set-AzureRmVmDscExtension -Version 2.71 -ResourceGroupName $resourceGroupName -VMName $machineName -ArchiveStorageAccountName $storageAccountName -ArchiveBlobName "$configName.ps1.zip" -AutoUpdate:$true -ConfigurationName $configName -Verbose -Force -ConfigurationArgument $configurationArguments -ErrorAction Inquire;
        }
    }        
}

Write-Progress -Activity 'Configuring SharePoint farm' -PercentComplete 100 -id 1;
if ( $azureParameters.ShutDownAfterProvisioning )
{
    Write-Host "$(Get-Date) Stopping all the machines"
    $configParameters.Machines | ? { $_.Roles -notcontains "AD" } | % {
        Stop-AzureRmVM -ResourceGroupName $azureParameters.ResourceGroupName -Name $_.Name -Force;
    }
    $configParameters.Machines | ? { $_.Roles -contains "AD" } | % {
        Stop-AzureRmVM -ResourceGroupName $azureParameters.ResourceGroupName -Name $_.Name -Force;
    }
} else {
    Write-Host "Following machines are ready to use:"
    $configParameters.Machines | % {
        $vm = Get-AzureRmVM -ResourceGroupName $resourceGroupName -VMName $_.Name;
        $networkInterfaceRef = $vm.NetworkProfile[0].NetworkInterfaces[0].id;
        $networkInterface = Get-AzureRmNetworkInterface | ? { $_.Id -eq $networkInterfaceRef }
        Write-Host "$($_.Name) $($networkInterface.IpConfigurations[0].PrivateIpAddress)"
    }
}

Get-Date