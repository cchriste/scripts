#!/bin/bash

#run each line of the file as a command

while IFS='' read -r line || [[ -n "$line" ]]; do
    #eval "$line"
    echo "$line"
done < "$1"
