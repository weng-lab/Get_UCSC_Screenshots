#!/usr/bin/env bash

# Author: Qin Wang
# Usage ucsc_screenshots.sh hublink bed_file outpath
# Usage ucsc_screenshots.sh https://***/hub.txt narrowPeak.bed /home/***/***
# hublink is what you put into the UCSC browser(the hub.txt contains all the tracks you have loaded)
#example:
#https://genome.ucsc.edu/cgi-bin/hgTracks?db=mm10&position=chr8:126820533-126833569&hubClear=https://users.wenglab.org/***/***/***/hub.txt

hublink=$1
infile=$2
outpath=$3
# db is the genome
db=mm10

### your bed file has a 4 columns format like: chr1 1000000 1010000 peak-1
ranges=( $(cut -f1-4 ${infile} | awk '{print $1":"$2"-"$3"."$4}') )
#echo $ranges
for i in "${ranges[@]}"; do
    # position="chr1:1000000-1010000"
    position=$(echo $i | cut -d. -f1)
    # position=$(echo $i)
    echo ${i}
    ### using the 4th column to name pdf files
    outpdf=${outpath}"/"$(echo $i | cut -d. -f2).pdf
    curl -s "https://genome.ucsc.edu/cgi-bin/hgTracks?db=$db&position=$position&hubClear=$hublink" >/dev/null
    pdf_page="https://genome.ucsc.edu/cgi-bin/hgTracks?db=$db&position=$position&hubClear=$hublink&hgt.psOutput=on"
    pdf_url=$(curl -s "$dl_page" | grep "the current browser graphic in PDF" | grep -E -o "\".+\"" | tr -d "\"" | sed 's/../https:\/\/genome.ucsc.edu/')

    echo "Saving $outpdf from $pdf_url"
    curl -s -o ${outpdf} "$pdf_url"
done
