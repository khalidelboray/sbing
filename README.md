# sbing
Simple Tool Scraps Bing Search Engine for urls and some info about it
## Requirements
  * [Perl 6 (rakudo-star)](https://rakudo.org/files)
  * [zef (Perl 6 module manager)](https://github.com/ugexe/zef) 
  * Modules
    * Net::DNS run `zef install --force-test Net::DNS`
    * JSON::Fast #comes preinstalled with the latest perl6 version
    * HTTP::UserAgent #comes preinstalled with the latest perl6 version
    * URI #comes preinstalled with the latest perl6 version
## USAGE
 * run `perl6 sbing.p6 --help`
## USAGE Examples
  * `perl6 sbing.p6 --search --keyword=site:google.com --out=file-name`
    * --search will start the search proccess
    * --keyword sets the query keyword
    * --out sets the output file name
    * defaults --pages to 10 pages
    
this will output a file named file-name.txt with the urls found from bing

  * `perl6 sbing.p6 --search --keyword=site:google.com --out=file-name --json --pages=20`
    * --search will start the search proccess
    * --keyword sets the query keyword
    * --out sets the output file name
    * --json sets the output format to json file with sarch results
    * --pages sets number of pages to scrap
    
this will output a file named file-name.json with the urls found from bing in json format

  * `perl6 sbing.p6 --search --keyword=site:google.com --out=file-name --info --pages=20`
    * --search will start the search proccess
    * --keyword sets the query keyword
    * --out sets the output file name
    * --info gets the urls info (host,ip address,host CNAME,paths found for each host and it's params)
    * --pages sets number of pages to scrap
    
this will output a file named file-name.json with the urls found from bing and it's info in json format
