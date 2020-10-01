Function Get-NewDomains ($LatestID){

    try{
        If ($LatestID){
            $Response = invoke-restmethod -URI $URI -Headers $Headers
        }
        Else {
            $URI = "https://api.certspotter.com/v1/issuances?domain=" + $Domain + "&expand=id&include_subdomains=true&expand=dns_names&match_wildcards=true&expand=issuer"
            $Response = invoke-restmethod -URI $URI -Headers $Headers }
            
    }
    catch [System.Net.WebException]{
        write-warning $Error[0]
        Write-warning "Waiting 7 minutes, then invoking script again"
        start-sleep -seconds 420
        Write-Warning "Invoking CertSpotter function again"
        Invoke-CertSpotter
    }
    catch {
        write-warning $Error[0]
    }

    finally {
        If ($Response.length -gt 0){
            $Response.dns_names | sort | get-unique
            $Response.id
            echo $Response.dns_names >> dnsnames.txt
            $Response.dns_names | sort | get-unique >> uniquednsnames.txt
            echo ($Response.id | measure -Maximum).maximum > latest.txt
            $LatestID = Get-Content latest.txt
            Clear-Variable Response
            $URI = "https://api.certspotter.com/v1/issuances?domain=" + $Domain + "&expand=id&include_subdomains=true&after=" + $LatestID + "&expand=dns_names&match_wildcards=true&expand=issuer"
            #Wait 7 minutes between each request to stay under the API Rate limit.
            Write-Host "Waiting 7 minutes"
            start-sleep -seconds 420
            Get-NewDomains -LatestID $LatestID
        }
    
        else {
            Write-host "Response was size 0."
            Write-Host "Waiting 7 minutes"
            start-sleep -seconds 420
            Get-NewDomains -LatestID $LatestID
        }
    }


}

Function Invoke-CertSpotter {
$Domain = ""
$APIKey = ""
$b64APIKEY = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($APIKey))
$basicAuthValue = "Basic $b64APIKEY"
$Headers = @{
    Authorization = $basicAuthValue
}

$LatestID = Get-Content latest.txt
#$LatestID = ""
$URI = "https://api.certspotter.com/v1/issuances?domain=" + $Domain + "&expand=id&include_subdomains=true&after=" + $LatestID + "&expand=dns_names&match_wildcards=true&expand=issuer"

Get-NewDomains -LatestID $LatestID

}


Invoke-CertSpotter
