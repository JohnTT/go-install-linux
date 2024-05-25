# Go Install Linux
Run this script as sudo to install golang toolchain
If no version specified, the script will install the latest version

## Running the script from internet 
```
# To install the latest version
curl -s https://raw.githubusercontent.com/JohnTT/go-install-linux/main/go-install-linux.sh | sudo bash

# To install a specific version 
curl -s https://raw.githubusercontent.com/JohnTT/go-install-linux/main/go-install-linux.sh | sudo bash -s -- go1.22.0
```

## Running the script locally
```
# To install the latest version
sudo ./go-install-linux.sh

# To install a specific version 
sudo ./go-install-linux.sh go1.22.0
```
