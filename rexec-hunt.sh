#!/bin/bash

# Function to encode payload
url_encode() {
    printf '%s' "$1" | jq -sRr @uri
}

# Function to test for command injection
test_injection() {
    local url=$1
    # List of safer payloads to inject
    local payloads=(
        "uname -a"
        "echo Hello"
    )

    local found=false

    # Loop through each payload and test for command injection
    for payload in "${payloads[@]}"; do
        local encoded_payload=$(url_encode "$payload")
        local response=$(curl -s -X POST --data-urlencode "input=$encoded_payload" "$url")

        # Check for a pattern in the response that indicates successful execution
        if [[ $response =~ 'expected response pattern' ]]; then
            echo "Potential Command Injection found: Payload: $payload"
            echo "Response: $response"
            echo ""
            found=true
        fi
    done

    # If no successful payloads were found
    if ! $found; then
        echo "No potential Command Injection vulnerabilities found."
    fi
}

# Main loop to continuously prompt for URLs
while true; do
    echo "Enter the target URL (e.g., http://example.com/vulnerable_page.php):"
    read -p "URL (or type 'exit' to quit): " TARGET_URL

    if [[ "$TARGET_URL" == "exit" ]]; then
        echo "Exiting..."
        break
    else
        test_injection "$TARGET_URL"
    fi
done
