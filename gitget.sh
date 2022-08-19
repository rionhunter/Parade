#!/bin/bash
cd ..
xclip -i -sel clip gitkey
cd Parade
git add .
git commit
git push
