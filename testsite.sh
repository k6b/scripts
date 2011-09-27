#! /bin/sh
# Generate test site and start server locally
mkdir ~/site
echo Generating test site at localhost:4000 ^C to quit
jekyll ~/jekyll ~/site --server
wait
rm -rf ~/site
