@{
    SPVersion = "2013"
    SPServicePack = ""
    SPLanguage = "English"
    SPLanguagePacks = @("Swedish")
    SPMultitenancy = $false
    DomainName = "sp.local"
    #machine name restriction: 15 characters, ^[a-z][a-z0-9-]{1,61}[a-z0-9]$
    #roles: AD, SQL, SharePoint, WFE, Application, DistributedCache, SearchQuery, SearchCrawl, SingleServerFarm, OOS, WFM, Addins, Admin, Code, Client, Configuration
    #SP 2013 software requirements: https://technet.microsoft.com/en-us/library/cc262485.aspx?f=255&MSPPError=-2147217396
    # WinVersion options: "2016", "2012R2", "2012"
    Machines = @(
        @{
            Name = "SP2013Ent01dc01"
            Roles = "AD"
            Memory = 1.5
            DiskSize = 30
            WinVersion = "2016"
            Image = "Win2016AD"
        }
        @{
            Name = "SP2013Ent01cl01"
            Roles = @()
            Memory = 1.5
            DiskSize = 30
            WinVersion = "2016"
            Image = ""
        }
    )
    SPDatabaseServer = "SP2016Ent01sp01"
    SPSiteCollectionHostName = "SP2016Ent01sp01.westeurope.cloudapp.azure.com"
    SearchIndexDirectory = "c:\SPSearchIndex"
    SPProductKey = "NQGJR-63HC8-XCRQH-MYVCH-3J3QR"
    DomainAdminUserName = "dauser1"
    DomainAdminPassword = "123$%^qweRTY"
    DomainSafeModeAdministratorPassword = "123$%^qweRTY"
    SPInstallAccountUserName = "_spadm"
    SPInstallAccountPassword = "123$%^qweRTY"
    SPFarmAccountUserName = "_spfrm"
    SPFarmAccountPassword = "123$%^qweRTY"
    SPWebAppPoolAccountUserName = "_spwebapppool"
    SPWebAppPoolAccountPassword = "123$%^qweRTY"
    SPServicesAccountUserName = "_spsrv"
    SPServicesAccountPassword = "123$%^qweRTY"
    SPSearchServiceAccountUserName = "_spsrchsrv"
    SPSearchServiceAccountPassword = "123$%^qweRTY"
    SPCrawlerAccountUserName = "_spcrawler"
    SPCrawlerAccountPassword = "123$%^qweRTY"
    SPTestAccountUserName = "_sptestuser1"
    SPTestAccountPassword = "123$%^qweRTY"
    SPSecondTestAccountUserName = "_sptestuser2"
    SPSecondTestAccountPassword = "123$%^qweRTY"
    SPOCSuperUser = "_spocuser"
    SPOCSuperReader = "_spocrdr"
    SPAdminGroupName = "SPAdmins"
    SPMemberGroupName = "SP Members"
    SPVisitorGroupName = "SP Visitors"
    SQLAdminGroupName = "SQL Admins" #not in use so far
    SPPassphrase = "123$%^qweRTY"
    SQLPass = "P@ssw0rd"
    SPDatabaseAlias = "SPDB"
    SQLInstallationMediaPath = "C:\Install\SQLMedia"
    SPInstallationMediaPath = "C:\Install\SPMedia"
    SPCumulativeUpdate = "2017Aug"
    SSMSInstallationFolderPath = "C:\Install\SSMS"
    SSMSVersion = "17.2"
    SPLogFolder = "C:\SPLogs"
}