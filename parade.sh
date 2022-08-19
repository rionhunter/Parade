#!/bin/bash
godot3 open project.godot
cd ..
xclip -i -sel clip gitkey
cd Parade
git add .
git commit
git push

