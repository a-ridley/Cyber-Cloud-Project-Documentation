---
id: getting-files
title: Get Files
---


# wget smol file from google: 
```
// https://silicondales.com/tutorials/g-suite/how-to-wget-files-from-google-drive/
wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=<FILE_ID>' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=<FILE_ID>" -O <FILE_NAME> && rm -rf /tmp/cookies.txt
```
# wget lorg from google: 
```
wget -O $filename 'https://docs.google.com/uc?export=download&id='$fileid
wget -O favicon.ico 'https://docs.google.com/uc?export=download&id='1GEloTSyfCJIF9nvhxlcDe3MRpaqzHJ4S
wget -O ccet-mark-logo.png 'https://docs.google.com/uc?export=download&id='16F1hlBK38oTcDi5gRuRykefMXTBL6A7_
wget -O $filename 'https://docs.google.com/uc?export=download&id='$fileid
```
# wget from dropbox:
```
//dl must = 1
curl https://www.dropbox.com/s/ndjiifcbdhgb1ro/ubuntu.7z?dl=1 -L -O -J

7za x -o/tmp/sub-directory file.7z
```