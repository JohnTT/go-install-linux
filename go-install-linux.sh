#!/usr/bin/bash
# Run this script as sudo to install golang toolchain
# If no version specified, the script will install the latest version
# 
# Example usage:
# sudo ./go-install-linux.sh $VERSION

GO_WEBSITE_DOWNLOAD='https://go.dev/dl/'
GO_VERSION=$1

get_go_latest_version() {
    curl -s $GO_WEBSITE_DOWNLOAD?mode=json | jq -r .[].version | sort -r > versions.json
    head -n 1 versions.json
}

install_go() {
    arch=$(uname -m)
    version=$GO_VERSION
    if [ -z $version ]; then
        echo "No version specified, finding latest"
        version=$(get_go_latest_version)
    fi

    case $arch in
        x86_64)
            file="$version.linux-amd64.tar.gz"
            ;;
        i386 | i686)
            file="$version.linux-386.tar.gz"
            ;;
        arm64 | aarch64)
            file="$version.linux-arm64.tar.gz"
            ;;
        armv6l)
            file="$version.linux-armv6.tar.gz"
            ;;
        *)
            echo "Unsupported architecture: $arch"
            exit 1
            ;;
    esac

    echo "The file for your architecture ($arch) is: $file"
    rm -f $file
    wget $GO_WEBSITE_DOWNLOAD$file
    rm -rf /usr/local/go
    tar -C /usr/local -xzf $version.linux-amd64.tar.gz
}

install_go

# For all users, export go to PATH if not present in .bashrc
NEW_PATH='export PATH=$PATH:/usr/local/go/bin'
update_bashrc() {
    local file="$1/.bashrc"
    if [ -f "$file" ]; then
        # Check if the line already exists to avoid duplicates
        grep -qxF "$NEW_PATH" "$file" || echo "$NEW_PATH" >> "$file"
    fi
}

# Loop through each user in the /etc/passwd file
while IFS=: read -r username _ uid _ _ home _; do
    if [ "$uid" -ge 1000 ] || [ "$uid" -eq 0 ]; then  # regular users and root
        update_bashrc "$home"
    fi
done < /etc/passwd
source ~/.bashrc
