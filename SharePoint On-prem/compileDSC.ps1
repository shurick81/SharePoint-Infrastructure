# script for compiling mof files on your development machine

[CmdletBinding()]
Param(
    [Parameter(Mandatory=$False,Position=1)]
    [string]$mainParametersFileName = "mainParemeters.psd1",
	
    [Parameter(Mandatory=$False,Position=2)]
    [string]$azureParametersFileName = "azureParameters.psd1"
)

$configParameters = Import-PowershellDataFile $mainParametersFileName;
$azureParameters = Import-PowershellDataFile $azureParametersFileName;
$commonDictionary = Import-PowershellDataFile commonDictionary.psd1;

$DomainName = $configParameters.DomainName;
$shortDomainName = $DomainName.Substring( 0, $DomainName.IndexOf( "." ) );

$SPVersion = $configParameters.SPVersion;
if ( $SPVersion -eq "2013" ) { $SQLVersion = "2014" } else { $SQLVersion = "2016" }

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

    $DomainSafeModeAdministratorPassword = $configParameters.DomainSafeModeAdministratorPassword;
    if ( $DomainSafeModeAdministratorPassword )
    {
        $securedPassword = ConvertTo-SecureString $configParameters.DomainSafeModeAdministratorPassword -AsPlainText -Force
        $DomainSafeModeAdministratorPasswordCredential = New-Object System.Management.Automation.PSCredential( "anyidentity", $securedPassword )
    } else {
        $DomainSafeModeAdministratorPasswordCredential = Get-Credential -Message "Enter any but not empty login and safe mode password";
    }

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

    $SPFarmAccountUserName = $configParameters.SPFarmAccountUserName;
    if ( $SPFarmAccountUserName )
    {
        $securedPassword = ConvertTo-SecureString $configParameters.SPFarmAccountPassword -AsPlainText -Force
        $SPFarmAccountCredential = New-Object System.Management.Automation.PSCredential( "$shortDomainName\$SPFarmAccountUserName", $securedPassword )
    } else {
        $SPFarmAccountCredential = Get-Credential -Message "Credential for SharePoint farm account";
    }

    $SPWebAppPoolAccountUserName = $configParameters.SPWebAppPoolAccountUserName;
    if ( $SPWebAppPoolAccountUserName )
    {
        $securedPassword = ConvertTo-SecureString $configParameters.SPWebAppPoolAccountPassword -AsPlainText -Force
        $SPWebAppPoolAccountCredential = New-Object System.Management.Automation.PSCredential( "$shortDomainName\$SPWebAppPoolAccountUserName", $securedPassword )
    } else {
        $SPWebAppPoolAccountCredential = Get-Credential -Message "Credential for SharePoint Web Application app pool account";
    }

    $SPServicesAccountUserName = $configParameters.SPServicesAccountUserName;
    if ( $SPServicesAccountUserName )
    {
        $securedPassword = ConvertTo-SecureString $configParameters.SPServicesAccountPassword -AsPlainText -Force
        $SPServicesAccountCredential = New-Object System.Management.Automation.PSCredential( "$shortDomainName\$SPServicesAccountUserName", $securedPassword )
    } else {
        $SPServicesAccountCredential = Get-Credential -Message "Credential for SharePoint shared services app pool";
    }

    $SPSearchServiceAccountUserName = $configParameters.SPSearchServiceAccountUserName;
    if ( $SPSearchServiceAccountUserName )
    {
        $securedPassword = ConvertTo-SecureString $configParameters.SPSearchServiceAccountPassword -AsPlainText -Force
        $SPSearchServiceAccountCredential = New-Object System.Management.Automation.PSCredential( "$shortDomainName\$SPSearchServiceAccountUserName", $securedPassword )
    } else {
        $SPSearchServiceAccountCredential = Get-Credential -Message "Credential for SharePoint search service account";
    }

    $SPCrawlerAccountUserName = $configParameters.SPCrawlerAccountUserName;
    if ( $SPCrawlerAccountUserName )
    {
        $securedPassword = ConvertTo-SecureString $configParameters.SPCrawlerAccountPassword -AsPlainText -Force;
        $SPCrawlerAccountCredential = New-Object System.Management.Automation.PSCredential( "$shortDomainName\$SPCrawlerAccountUserName", $securedPassword );
    } else {
        $SPCrawlerAccountCredential = Get-Credential -Message "Credential for SharePoint crawler account";
    }

    $SPTestAccountUserName = $configParameters.SPTestAccountUserName;
    if ( $SPTestAccountUserName )
    {
        $securedPassword = ConvertTo-SecureString $configParameters.SPTestAccountPassword -AsPlainText -Force;
        $SPTestAccountCredential = New-Object System.Management.Automation.PSCredential( "$shortDomainName\$SPTestAccountUserName", $securedPassword );
    } else {
        $SPTestAccountCredential = Get-Credential -Message "Credential for SharePoint test user";
    }

    $SPSecondTestAccountUserName = $configParameters.SPSecondTestAccountUserName;
    if ( $SPSecondTestAccountUserName )
    {
        $securedPassword = ConvertTo-SecureString $configParameters.SPSecondTestAccountPassword -AsPlainText -Force
        $SPSecondTestAccountCredential = New-Object System.Management.Automation.PSCredential( "$shortDomainName\$SPSecondTestAccountUserName", $securedPassword );
    } else {
        $SPSecondTestAccountCredential = Get-Credential -Message "Credential for SharePoint test user";
    }

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

# credentials are ready

#compiling domain
$configParameters.Machines | ? { $_.Roles -contains "AD" } | % {
    $configurationData = @{ AllNodes = @(
        @{ NodeName = $_.Name; PSDscAllowPlainTextPassword = $True }
    ) }
    . .\DSCDomainInstall.ps1
    DomainInstall -ConfigurationData $configurationData
    . .\DSCSPDomain.ps1
    SPDomain -ConfigurationData $configurationData -ConfigParameters $configParameters `
        -ShortDomainAdminCredential $ShortDomainAdminCredential `
        -DomainSafeModeAdministratorPasswordCredential $DomainSafeModeAdministratorPasswordCredential `
        -SPInstallAccountCredential $SPInstallAccountCredential `
        -SPFarmAccountCredential $SPFarmAccountCredential `
        -SPWebAppPoolAccountCredential $SPWebAppPoolAccountCredential `
        -SPServicesAccountCredential $SPServicesAccountCredential `
        -SPSearchServiceAccountCredential $SPSearchServiceAccountCredential `
        -SPCrawlerAccountCredential $SPCrawlerAccountCredential `
        -SPOCAccountCredential $SPOCAccountCredential `
        -SPTestAccountCredential $SPTestAccountCredential `
        -SPSecondTestAccountCredential $SPSecondTestAccountCredential

}

#compiling SQL
$configParameters.Machines | ? { $_.Roles -contains "SQL" } | % {
    $configurationData = @{ AllNodes = @(
        @{ NodeName = $_.Name; PSDscAllowPlainTextPassword = $True }
    ) }
    if ( $configParameters.SPVersion -eq "2013" )
    {
        . .\DSCSQL2014LoadingInstallationFiles.ps1
        SQL2014LoadingInstallationFiles -ConfigurationData $configurationData -ConfigParameters $configParameters -SystemParameters $azureParameters -CommonDictionary $commonDictionary
        . .\DSCSQL2014Install.ps1
        SQL2014Install -ConfigurationData $configurationData -SQLPassCredential $configParameters.SQLPassCredential -LocalAdminCredential $LocalAdminCredential -MachineName $_.Name
    }
    if ( $configParameters.SPVersion -eq "2016" )
    {
        . .\DSCSQL2016.ps1
        SQL2016 -ConfigurationData $configurationData -ConfigParameters $configParameters
    }
}

#compiling SP machine preparation config
$configParameters.Machines | ? { $_.Roles -contains "SharePoint" } | % {
    $configurationData = @{ AllNodes = @(
        @{ NodeName = $_.Name; PSDscAllowPlainTextPassword = $True }
    ) }
    if ( $configParameters.SPVersion -eq "2013" )
    {
        $storageAccountKey = Get-AzureRmStorageAccountKey -ResourceGroupName $azureParameters.ImageResourceGroupName -Name $azureParameters.ImageStorageAccount | ? { $_.KeyName -eq "key1" }
        . .\DSCSP2013Prepare.ps1
        SP2013Prepare -ConfigurationData $configurationData -ConfigParameters $configParameters
        . .\DSCSP2013AzureLoadingInstallationFiles.ps1
        SP2013AzureLoadingInstallationFiles -ConfigurationData $configurationData -AzureParameters $azureParameters -AzureStorageAccountKey $storageAccountKey.Value
        . .\DSCSP2013LoadingInstallationFiles.ps1
        SP2013LoadingInstallationFiles -ConfigurationData $configurationData -ConfigParameters $configParameters -SystemParameters $azureParameters -CommonDictionary $commonDictionary
        . .\DSCSP2013Install.ps1
        SP2013Install -ConfigurationData $configurationData -ConfigParameters $configParameters -LocalAdminCredential $LocalAdminCredential
    }
    if ( $configParameters.SPVersion -eq "2016" )
    {
        . .\DSCSQL2016.ps1
        SQL2016 -ConfigurationData $configurationData -ConfigParameters $configParameters
    }
}

#compiling domain machine adding
$configParameters.Machines | ? { !( $_.Roles -contains "AD" ) } | % {
    $configurationData = @{ AllNodes = @(
        @{ NodeName = $_.Name; PSDscAllowPlainTextPassword = $True }
    ) }
    . .\DSCDomainClient.ps1
    DomainClient -ConfigurationData $configurationData -ConfigParameters $configParameters -SystemParameters $azureParameters -DomainAdminCredential $DomainAdminCredential
}

#compiling configuration machines provisioning
$configParameters.Machines | ? { $_.Roles -contains "Configuration" } | % {
    $configurationData = @{ AllNodes = @(
        @{ NodeName = $_.Name; PSDscAllowPlainTextPassword = $True }
    ) }
    . .\DSCSPConfigurationTools.ps1
    SPConfigurationTools -ConfigurationData $configurationData -ConfigParameters $configParameters -CommonDictionary $commonDictionary
}

#compiling SPFarm configuration
$SPMachines = $configParameters.Machines | ? { $_.Roles -contains "SharePoint" }
if ( $SPMachines )
{
    $configurationData = @{ AllNodes = @() }
    $SPMachines | ? { $_.Roles -contains "SharePoint" } | % {
        $configurationData.AllNodes += @{ NodeName = $_.Name; PSDscAllowPlainTextPassword = $True }
    }
    . .\DSCSP2013.ps1
    SP2013 -ConfigurationData $configurationData -ConfigParameters $configParameters `
        -SPPassphraseCredential $SPPassphraseCredential `
        -SPInstallAccountCredential $SPInstallAccountCredential `
        -SPFarmAccountCredential $SPFarmAccountCredential `
        -SPWebAppPoolAccountCredential $SPWebAppPoolAccountCredential `
        -SPServicesAccountCredential $SPServicesAccountCredential `
        -SPSearchServiceAccountCredential $SPSearchServiceAccountCredential `
        -SPCrawlerAccountCredential $SPCrawlerAccountCredential
}
