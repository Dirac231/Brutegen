## What is this?
Brutegen is a bash function that creates a profiled wordlist from a web application, especially useful during bruteforce attacks regarding passwords.\
\
It crawls the web application while trying to guess endpoints from ```common.txt```, then it fetches words with a minimum length of 4 including numbers and optionally recombines them by using a custom-made hashcat rule file. As the final step, it adds common passwords from the darkweb2017 seclist file.

## Requirements
To use brutegen you'll neeed a few things installed, you can solve this first by running this command (Kali Linux recommended)
```
sudo apt install -y gospider ffuf hashcat cewl seclists shuf
```
One extra thing that you'll need is the ```anew``` program, that you can easily install through ```go```:
```
go install -v github.com/tomnomnom/anew@latest
```
Next, download the ```my_custom.rule``` file and put it in ```/usr/share/hashcat/rules/my_custom.rule```

## How to use?
Copy the function in the ```brutegen.sh``` file and paste it in your ```~/.bashrc``` or equivalent, then ```source``` the file, and run the function against the starting crawling endpoint:
```bash
brutegen http://www.example.com/
```
At the end of the execution, you will have the ```combined_wordlist.txt``` file that you can use as a password list for your attack.
