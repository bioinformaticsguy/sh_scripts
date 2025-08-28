search_dir="/data/cephfs-2/unmirrored/groups/kircher/SexDiversity"
prefix="DNA_"

# Define your digit list here
digit_list=({01..49})

for digit in "${digit_list[@]}"; do
    pattern="*${prefix}${digit}*"
    label="${prefix}${digit}"
    count=$(find "$search_dir" -name "$pattern" | wc -l)

    if [ "$count" -eq 4 ]; then
        echo "$label"
    fi
done

