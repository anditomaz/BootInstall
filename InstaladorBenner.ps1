## Script criado para automatizar a instalação de uma aplicação ASP.NET MVC; By: Anderson

function BaixaFerramentas {

 Param($Caminho)

cls

$temp = 'c:\tmp'
 
 try {     
    if (-not(Test-Path -Path $CaminhoInstalacao -PathType Leaf)) {
        mkdir $CaminhoInstalacao
        mkdir $temp

        powershell –c “(new-object System.Net.WebClient).DownloadFile(‘#Link do download do arquivo.zip contendo as ferramentas para instalação’,’C:\tmp\ferramentasdownload.zip’)”

        Start-Sleep -Seconds 5

        Expand-Archive -LiteralPath 'C:\tmp\ferramentasdownload.zip' -DestinationPath 'C:\BootInstaller\'
       
    }
    else {
        powershell –c “(new-object System.Net.WebClient).DownloadFile(‘#Link do download do arquivo.zip contendo as ferramentas para instalação’,’C:\tmp\ferramentasdownload.zip’)”

        Start-Sleep -Seconds 5

        Expand-Archive -LiteralPath 'C:\tmp\ferramentasdownload.zip' -DestinationPath 'C:\BootInstaller\'
    } 
   }
catch {
   echo 'Dowload realizado com sucesso'

 } 

 cls 

 echo 'Deseja voltar para o menu inicial ?'
   echo '(S) - Sim'
   echo '(N) - Não'

   $Resposta = Read-Host
   
   if ($Resposta -eq 'S') {
     cls
     Menu
     $Opcao = Read-Host
   }
   else {
     break
   } 
} 
function Menu {
  echo '================='
  echo 'Instalador benner'
  echo '================='

  echo 'Selecione a opção desejada:'
  echo '---------------------------'
  echo '---------------------------'
  echo '(1) - Baixar Ferramentas'
  echo '(2) - Instalar BServer'
  echo '(3) - Instalar Integrator'
  echo '(4) - Instalar Provider'
  echo '(5) - Criar Aplicativo'

  $Opcao = Read-Host  

  if ($Opcao -eq '1') {
   cls
   BaixaFerramentas -Caminho $CaminhoInstalacao
  }

  elseif($Opcao -eq '2') {
   cls
   InstalaBserver

  }
  elseif($Opcao -eq '3') {
   cls
   InstalaIntegrator

  }
  elseif($Opcao -eq '4') {
   cls
  }
  elseif ($Opcao -eq '5'){
    CriarEstruturaWes
  }
} 
function InstalaBserver{
 Invoke-Expression -Command "$CaminhoInstalacao\ferramentas\bserver\bserver.exe -install"

 echo 'Deseja voltar para o menu inicial ?'
   echo '(S) - Sim'
   echo '(N) - Não'

   $Resposta = Read-Host
   
   if ($Resposta -eq 'S') {
     cls
     Menu
     $Opcao = Read-Host
   }
   else {
     break
   }
}
function InstalaIntegrator{
 Invoke-Expression -Command "$CaminhoInstalacao\Ferramentas\Integrator\intsrv.exe -install"

 echo 'Deseja voltar para o menu inicial ?'
   echo '(S) - Sim'
   echo '(N) - Não'

   $Resposta = Read-Host
   
   if ($Resposta -eq 'S') {
     cls
     Menu
     $Opcao = Read-Host
   }
   else {
     break
   }
}
function InstalaIIS {
 #Forçando a execução em um nível mais avançado 
 Set-ExecutionPolicy Unrestricted;

 Install-WindowsFeature -name Web-Server -IncludeManagementTools

 echo 'Deseja voltar para o menu inicial ?'
   echo '(S) - Sim'
   echo '(N) - Não'

   $Resposta = Read-Host
   
   if ($Resposta -eq 'S') {
     cls
     Menu
     $Opcao = Read-Host
   }
   else {
     break
   }
}
function CriarEstruturaWes {
  #Forçando a execução em um nível mais avançado 
  Set-ExecutionPolicy Unrestricted;

  #Tentando setar pt-BR
  Set-WinHomeLocation -GeoId 32;
  Set-WinUserLanguageList pt-BR -Force;
  Set-WinUILanguageOverride pt-BR;
  Set-WinSystemLocale pt-BR;
  Set-Culture pt-BR;

  echo 'Informe um usuário administrador do ambiente:'
  $UserName = Read-Host

  echo 'Informe a senha do usuário:'
  $UserPass = Read-Host

  echo 'Informe o nome da Pool:'
  $PoolName = Read-Host

  echo 'Informe o nome do aplicativo:'
  $AplicationName = Read-Host

  
  echo 'Informe o caminho fisico/pasta do aplicativo:'
  $CaminhoWes = Read-Host

  if (-not(Test-Path -Path $CaminhoWes -PathType Leaf)) {
        mkdir $CaminhoWes

        #Criando pool de aplicativos no IIS
        Import-Module WebAdministration;

        CD IIS:\AppPOOLS\;

        New-Item $PoolName;

        Set-ItemProperty webapppool managedRuntimeVersion -value v4.0;
        Set-ItemProperty webapppool -Name processModel.identityType -Value SpecificUser;
        Set-ItemProperty webapppool -Name processModel.userName -Value $UserName
        Set-ItemProperty webapppool -Name processModel.password -Value $UserPass

        New-WebApplication -Name $AplicationName -Site "Default Web Site" -PhysicalPath $CaminhoWes -ApplicationPool $PoolName -Force
        }
  else {
        #Criando pool de aplicativos no IIS
        Import-Module WebAdministration;

        CD IIS:\AppPOOLS\;

        New-Item $PoolName;

        Set-ItemProperty webapppool managedRuntimeVersion -value v4.0;
        Set-ItemProperty webapppool -Name processModel.identityType -Value SpecificUser;
        Set-ItemProperty webapppool -Name processModel.userName -Value $UserName
        Set-ItemProperty webapppool -Name processModel.password -Value $UserPass

        New-WebApplication -Name $AplicationName -Site "Default Web Site" -PhysicalPath $CaminhoWes -ApplicationPool $PoolName -Force
  
  }

  echo 'Deseja voltar para o menu inicial ?'
   echo '(S) - Sim'
   echo '(N) - Não'

   $Resposta = Read-Host
   
   if ($Resposta -eq 'S') {
     cls
     Menu
     $Opcao = Read-Host
   }
   else {
     break
   }
}

If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
        {   
        $arguments = "& '" + $myinvocation.mycommand.definition + "'"
        Start-Process powershell -Verb runAs -ArgumentList $arguments
        Break
        }

echo '==================================================================================================================================================='
echo '==================================================================================================================================================='
echo '                                                                                                                                                   '
echo '                                                                   Instalador                                                                      '
echo '                                                                                                                                                   '
echo '==================================================================================================================================================='
echo '==================================================================================================================================================='
echo '                                                                                                                                                   '
echo '                                                                                                                                                   '
echo '                                                                                                                                                   '

Start-Sleep -Seconds 5

cls 

echo 'Informe o diretório para instalação: '

$CaminhoInstalacao = Read-Host

cls

Menu



