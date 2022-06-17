## What is this?
Brutegen is a bash function that creates a profiled wordlist from a web application, especially useful during bruteforce attacks.\
\
It crawls the web application and fetches words with a minimum length of 4 including numbers, then it optionally recombines this wordlist by using a custom-made hashcat rule file, and adds common passwords from the darkweb2017 seclist file.

## Requirements
To use brutegen you'll neeed a few things installed, you can solve this first by running this command (Kali Linux recommended)
```
sudo apt install -y gospider ffuf hashcat cewl seclists shuf
```
One extra thing that you'll need is the ```anew``` program, that you can easily install through ```go```:
```
go install -v github.com/tomnomnom/anew@latest
```
Next, download the custom .rule file and put it in ```/usr/share/hashcat/rules/my_custom.rule```

## How to use?
Simply run it with the full root web address as an argument
```bash
brutegen http://www.example.com/
```
