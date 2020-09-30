# certspotter
Powershell Script to continually query Certspotter API

Work in progress. I'll update and make this better as time permits.

Just add values for $Domain and $APIKey then execute.  
It will then send a request to the certspotter API every 7 minutes (to stay under the API rate limit).

3 files will be created:  
**dnsnames.txt**: a list of all domains/subdomains seen in CTLogs by CertSpotter for the provided domain. Newest seen names at end of file.  
**latest.txt**: Stores the ID of the latest seen certificate for the provided domain. Used for pagination in CertSpotter as well as resuming the script from where it left off.  
**uniquednsnames.txt**: Sorted and unique list of domain names found in CT logs for provided Domain.  


