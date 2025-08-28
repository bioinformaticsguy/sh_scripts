#!/bin/bash

# Print table header
printf "%-10s %-6s %-7s %-10s %-15s %-10s %-12s %-20s\n" \
    "JobID" "CPUs" "Nodes" "Memory(GB)" "NodeList" "RunTime" "TimeLimit" "JobName"

# Loop through jobs
squeue -u $USER --noheader -o "%i %C %D %m %R %M %l %j" | while read jobid cpus nodes mem nodelist runtime timelimit name; do
    printf "%-10s %-6s %-7s %-10s %-15s %-10s %-12s %-20s\n" \
        "$jobid" "$cpus" "$nodes" "$mem" "$nodelist" "$runtime" "$timelimit" "$name"
done

