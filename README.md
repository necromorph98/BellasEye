# BellasEye
A lightweight program written in BASH which automates and saves time during vulnerability analysis and penetration testing. It automates various tools such as NMAP, Gobuster, theHarvester etc. It uses a custom designed Vulnerability Lookup which parses major databases like ExploitDB, National Vulnerability Database and VulDB (requires an API key). It saves all the outputs to separate files for easy use.

## Setting up
First we need to make requirements.sh executable before running. It will make sure you have all the tools/files available. 
**Make sure you run this as root.**
```
chmod +x requirements.sh
./requirements.sh
```
<img src="/images/image1.PNG" alt="req" />

## Tutorial
1. Run the main script as
`./BellasEye`
<img src="/images/image2.PNG" alt="main" />

2. You may select a single option or you can automate multiple tasks by selecting multiple options, separated by a comma. All the duplicate processes will be skipped.
<img src="/images/image3.PNG" alt="options" />

## Vulnerability Lookup
You can search for any vulnerability by passsing a query in the form of a product name with/without version, CVE id, CPE id or even CWE id. The program will parse three major databases: 
  1. ExploitDb
  2. National Vulnerability Database
  3. VulDB (Requires API key)
<img src="/images/vul1.PNG" alt="vul1" />
<img src="/images/vul2.PNG" alt="vul2" />

## API Key Setup For VulDB
1. Got to vuldb.com and create an account. 
2. Go to profile and copy your api key


# Contact
Email: bellaseye.cyber@gmail.com

# Support this project!
https://www.patreon.com/necromorph

# Disclaimer
The creator of this code doesn't accept responsibility if it's used with malicious intent. This code is free to be used by anyone. This project should not be used to harm any individual or organisation. 


