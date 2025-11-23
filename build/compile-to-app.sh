#!/bin/bash

app_path="../app/app.lua"
external_lib="local lfs = require("lfs")"

touch $app_path
echo "-- Merged version of repo-report-tool" > $app_path

lua_files=($(find ../lua/ -type f -name *.lua))
main_file=(${lua_files[0]})
other_files=("${lua_files[@]:1}")

# external lib
echo $external_lib >> $app_path
echo "" >> $app_path

# other files
for file in ${other_files[@]}; do
    grep -Pv "^(return|.*require.*)" $file >> $app_path
done

# main file
grep -Pv ".*require.*" $main_file >> $app_path

echo "app.lua completed!"
