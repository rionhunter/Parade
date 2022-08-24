#!/bin/bash
godot3 open project.godot
cd ..
xclip -i gitkey
cd Parade
git add .
git commit
git push
xclip -o
exit
