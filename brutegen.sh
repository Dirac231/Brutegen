brutegen(){
    echo -e "\nCRAWLING WEB APPLICATION\n"
    gospider --sitemap -d 0 -k 2 -c 8 -s $1 | grep -E '(\[linkfinder\]|\[url\]|\[robots\]|\[sitemap\])' | grep -o -E "(([a-zA-Z][a-zA-Z0-9+-.]*\:\/\/)|mailto|data\:)([a-zA-Z0-9\.\&\/\?\:@\+-\_=#%;,])*" | sort -u > brutegen_tmp

    echo -e "\nRETRIEVING ENDPOINTS WITH COMMON.TXT\n"
    ffuf -c -mc 200,204 -w /usr/share/seclists/Discovery/Web-Content/common.txt -r -u $1FUZZ/ -s > endpoints_tmp

    echo -e "\nSORTING AND FIXING LIST\n"
    while read p
    do
        echo $1$p/ >> brutegen_tmp
    done < endpoints_tmp
    rm endpoints_tmp
    cat brutegen_tmp | sort -u > temp_endpoints.txt && rm brutegen_tmp

    echo -e "\nRE-CRAWLING AT DEPTH 3\n"
    touch endpoints.txt
    while read p
    do
        gospider --sitemap -d 0 -k 2 -c 8 -s $1 | grep -E '(\[linkfinder\]|\[url\]|\[robots\]|\[sitemap\])' | grep -o -E "(([a-zA-Z][a-zA-Z0-9+-.]*\:\/\/)|mailto|data\:)([a-zA-Z0-9\.\&\/\?\:@\+-\_=#%;,])*" | anew -q endpoints.txt
    done < temp_endpoints.txt
    rm temp_endpoints.txt

    echo -e "\n----FOUND ENDPOINTS----\n"
    cat endpoints.txt
    echo -e "\n-----------------------\n"

    echo -e "\nGENERATING WORDLIST FROM FOUND ENDPOINTS\n"
    while read p
    do
        cewl -m 4 --with-numbers -d 3 -w tmp_list -a $p
        cat tmp_list | anew -q wordlist.txt
        rm tmp_list
    done < endpoints.txt
    rm endpoints.txt

    length=$(wc -l wordlist.txt | awk '{print $1}')
    echo -e "\nWORDLIST HAS LENGTH: $length, DO YOU WANT TO RECOMBINE IT? (EST. LENGTH: $(($length*72+5000)) (Y/N)\n"

    read REPLY\?""
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
            hashcat --force wordlist.txt -r /usr/share/hashcat/rules/my_custom.rule --stdout | anew -q combined_wordlist.txt
    fi

    echo -e "\nSHUFFLING AND ADDING COMMON PASSWORDS\n"
    cat /usr/share/seclists/Passwords/darkweb2017-top10000.txt | anew -q combined_wordlist.txt
    shuf combined_wordlist.txt > a; mv a combined_wordlist.txt
}
