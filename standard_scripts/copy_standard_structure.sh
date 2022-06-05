#!/usr/bin/env bash

# Copy to clipboard v2 basic framework for scripts

verify_privileges() {
        if [ ${UID} -eq 0 ]; then
                echo -e "ERROR: Run this program without privileges!\nExiting..."
                exit 1
        fi
}

print_usage() {
        echo -e "Run:\n\t./$(basename ${0})"
}

verify_privileges

[ ${#} -ge 1 -o "${1,,}" = '-h' -o "${1,,}" = '--help' ] && {
        print_usage
        exit 1
}

# >>>>> PROGRAM START <<<<<

tee << EOF | xclip -rmlastnl -selection clipboard
#!/usr/bin/env bash

# <comments>

verify_privileges() {
        if [ \${UID} -eq 0 ]; then
                echo -e "ERROR: Run this program without privileges!\nExiting..."
                exit 1
        fi
}

print_usage() {
        echo -e "Run:\n\t./\$(basename \${0})"
}

verify_privileges

[ \${#} -ge 1 -o "\${1,,}" = '-h' -o "\${1,,}" = '--help' ] && {
        print_usage
        exit 1
}

# >>>>> PROGRAM START <<<<<

# <commands>
EOF
