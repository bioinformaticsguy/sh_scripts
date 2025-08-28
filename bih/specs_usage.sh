# Print table header
printf "%-10s %-6s %-7s %-10s %-15s %-10s %-12s %-20s\n" \
    "JobID" "CPUs" "Nodes" "Memory(GB)" "NodeList" "RunTime" "TimeLimit" "JobName"

# Loop through all your jobs
for job in $(squeue --user $USER --noheader --format="%i"); do
    scontrol show job "$job" | awk -v jobid="$job" '
    BEGIN {
        name="NA"; cpus="NA"; nodes="NA"; mem="NA";
        nodelist="NA"; runtime="NA"; timelimit="NA";
    }
    /JobName=/ {
        for (i=1;i<=NF;i++) {
            if ($i ~ /^JobName=/) name=substr($i,9);
        }
    }
    /NumCPUs=/ {
        for (i=1;i<=NF;i++) {
            if ($i ~ /^NumCPUs=/) cpus=substr($i,9);
            if ($i ~ /^NumNodes=/) nodes=substr($i,10);
        }
    }
    /TRES=/ {
        match($0, /mem=([0-9]+)([MG]?)B?/, m);
        if (m[1] != "") {
            if (m[2] == "G") mem = m[1];
            else if (m[2] == "M") mem = sprintf("%.1f", m[1]/1024);
            else mem = "NA";
        }
    }
    /NodeList=/ {
        for (i=1;i<=NF;i++) {
            if ($i ~ /^NodeList=/) nodelist=substr($i,10);
        }
    }
    /RunTime=/ {
        for (i=1;i<=NF;i++) {
            if ($i ~ /^RunTime=/) runtime=substr($i,9);
            if ($i ~ /^TimeLimit=/) timelimit=substr($i,11);
        }
    }
    END {
        printf "%-10s %-6s %-7s %-10s %-15s %-10s %-12s %-20s\n", \
               jobid, cpus, nodes, mem, nodelist, runtime, timelimit, name;
    }'
done
