echo Downloading large dataset of about 13 GB. This may take some time:
echo
curl -L http://downloads.datastax.com/extra/demos/wikipedia/wikipedia-sample-dl.xml.bz2.sha -o wikipedia-sample-dl.xml.bz2.sha
curl -L http://downloads.datastax.com/extra/demos/wikipedia/wikipedia-sample-dl.xml.bz2 -o wikipedia-sample-dl.xml.bz2
echo
echo Computing checksum for downloaded file:
shasum -c wikipedia-sample-dl.xml.bz2.sha

