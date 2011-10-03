#! /bin/sh
# Generate test site and start server locally
mkdir ~/site
echo Generating test site at localhost:4000 ^C to quit
cd ~/jekyll
jekyll ~/jekyll ~/site --server --auto
wait
cd ~ 
rm -rf ~/site
