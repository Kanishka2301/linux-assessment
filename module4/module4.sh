input="input.txt"
output="output.txt"

> "$output"

while read -r line
do
    if [[ $line == *"frame.time"* ]]; then
        echo "$line" >> "$output"
    fi

    if [[ $line == *"wlan.fc.type"* ]]; then
        echo "$line" >> "$output"
    fi

    if [[ $line == *"wlan.fc.subtype"* ]]; then
        echo "$line" >> "$output"
    fi

done < "$input"

echo "Output stored in output.txt"

