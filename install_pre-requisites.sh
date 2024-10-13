#!/bin/bash

set -e

# Function to install Homebrew on macOS
install_homebrew() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        if command -v brew &>/dev/null; then
            echo "Homebrew is already installed"
        else
            echo "Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
    else
        echo "Homebrew is not needed for Linux"
    fi
}

# Function to install Python3 and pip
install_python() {
    if command -v /usr/local/bin/python3 &>/dev/null; then
        echo "Python 3 is already installed"
    else
        echo "Installing Python 3..."
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            sudo apt update
            sudo apt install -y python3 python3-pip
        elif [[ "$OSTYPE" == "darwin"* ]]; then
            brew install python
        fi
    fi
}

# Function to install Docker
install_docker() {
    if command -v docker &>/dev/null; then
        echo "Docker is already installed"
    else
        echo "Installing Docker..."
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
            sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
            sudo apt update
            sudo apt install -y docker-ce
            sudo systemctl enable --now docker
        elif [[ "$OSTYPE" == "darwin"* ]]; then
            brew install --cask docker
            open -a Docker
        fi
    fi
}

# Function to install kubectl
install_kubectl() {
    if command -v kubectl &>/dev/null; then
        echo "kubectl is already installed"
    else
        echo "Installing kubectl..."
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
            sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
            rm kubectl
        elif [[ "$OSTYPE" == "darwin"* ]]; then
            brew install kubectl
        fi
    fi

    # Creating .kube directory if it doesn't exist
    mkdir -p $HOME/.kube

    # Creating a basic .kube/config file
    echo "Creating .kube/config..."
    cat <<EOF > $HOME/.kube/config
apiVersion: v1
kind: Config
preferences: {}

clusters:
- cluster:
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURCVENDQWUyZ0F3SUJBZ0lJTnNiVnZVd2o1WFF3RFFZSktvWklodmNOQVFFTEJRQXdGVEVUTUJFR0ExVUUKQXhNS2EzVmlaWEp1WlhSbGN6QWVGdzB5TkRFd01ETXdOalV5TkRaYUZ3MHpOREV3TURFd05qVTNORFphTUJVeApFekFSQmdOVkJBTVRDbXQxWW1WeWJtVjBaWE13Z2dFaU1BMEdDU3FHU0liM0RRRUJBUVVBQTRJQkR3QXdnZ0VLCkFvSUJBUUMvQWs2RHdLaW03dDI2ZWlZa3hTNGZUKys5czVLTmsrRE1EVFBmU0o4TXNZbnEwb21sNEloMHk0NC8KZGlXVmhHdE9QVFdiUFhOL1VGWW1LZ0JJVkN3K2V6MWx5MEsyRXljVlpyQ0NVS0w2VDNaSzNBTVpybTRsK1YySQpXUmg5UThlUVJVR0FMaElrNWxKczgrdWZZc1lUcjRScEEwUFlUWFpNcldvd1cxY0JKdXVRVTIxU2NIY2JjMFNGCld5Rkd1bzBsYUFZOHVFc1huSTVucld5K05JZ08vWVU5L2RTVzdMc0hsZXJEQzRMa09NaExaMkJLNVVtQjQydVkKMVB5UVdNTVd0RkxlV1F4SGNTNzN6MU9YN2V2VmF6TEorWG1sSi9CQUhjUjFWdkE1QndFaVVRcTQxZWV0SFBDTwowcnhZRmlUaUNBODVRY0ZsVkpwN0R0L1kxVlpWQWdNQkFBR2pXVEJYTUE0R0ExVWREd0VCL3dRRUF3SUNwREFQCkJnTlZIUk1CQWY4RUJUQURBUUgvTUIwR0ExVWREZ1FXQkJRblNJMFZWTkRoSndoOUQwR0FrZjYwQ1p2cit6QVYKQmdOVkhSRUVEakFNZ2dwcmRXSmxjbTVsZEdWek1BMEdDU3FHU0liM0RRRUJDd1VBQTRJQkFRQVpzbnlzcDlncApSaGUxTzRnUGt1T2ZWWkExUEw4dEkybERPWmNnRjk1UnFZOFZ0Z2x2MXBMSEVzQnlSZ2tvbTBmM003WEJ1VU1jClBsZnpNN2dyaVF6c0FIUUxLTFpJb2dFMVFwcFFVRWdzQ1FZdUU3QXV1enorRG9aK0dUcXNYYVRVanRENHhqTDEKRm1MWW5iY3NkM1NTcTh3WDlKMkVSeVJ3dXFUVEZDNnVEYzNiVitwQ09IZGV0TXZiL1hRYzN0cTlrbUZub0ZCLwppUFJIaGpnQzViUWNYYk92ZHFsTnd6c202UGlnS3hXUFFkUTZ0NDc3ZkdjYzQxZWFFdWZZZ1h1dnVxSzdGeWxvCkxDWHZ2QWNGaEphUURjY3R2dUZ5Z001WGQwbGdTQzNsZ2crdGFxeXJWc2JNKzZUYkxvOHNxNCtaay8yWWpzT0EKRG1MeGNFLzVrWSthCi0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K
    server: https://9c9ac1f7-1d29-46f9-81a5-364913e1d417.ap-south-1.linodelke.net:443
  name: lke238244

users:
- name: lke238244-admin
  user:
    as-user-extra: {}
    token: eyJhbGciOiJSUzI1NiIsImtpZCI6InNlejVlMFJUNWw3U1FBYTlpS0xCWVFRYS1SZ1M0QWgzdWo2aUJVNXdDSXMifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlLXN5c3RlbSIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJsa2UtYWRtaW4tdG9rZW4tY2hxcXYiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC5uYW1lIjoibGtlLWFkbWluIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQudWlkIjoiZWMyMmNiNzgtYTc4Zi00OGZlLWFhOTktZmE2MmZmMDU0ZWEyIiwic3ViIjoic3lzdGVtOnNlcnZpY2VhY2NvdW50Omt1YmUtc3lzdGVtOmxrZS1hZG1pbiJ9.J8gij2fPqHkC7rtkDVjsv-JxD_vSGyEPuo1lblMuVN_g_4H40MtHGFpb6FpTty6BJzgDy2BiI78VT0_Kfvk7sZ31wEvrNrxPg--sMdxvRutwz0Y-FF6FG51c3Q3JiltGYMeB3sgTPSYyXinHqkVUa-HSfjyeQ_j1jT-8utqed1Yrl-O74AzAqJVw-n_41lntJ9ENDEsmtzh1goyQlsPbrClYAHDJFxCqx3Z5Euey1RokGZOaqr-9GL7giatsLuzPl-ghaF0RMVu3FkRbQ2fVNHVhB5Pohdsopjg6yGKxCkftPla_s0xBXVyFUkuHWrG2gTPpugxZTcBGq9P56mUyFQ

contexts:
- context:
    cluster: lke238244
    namespace: default
    user: lke238244-admin
  name: lke238244-ctx

current-context: lke238244-ctx
EOF

    echo "kubectl installed and .kube/config created."
}

# Run the functions
install_homebrew
install_python
install_docker
install_kubectl

echo "Installation completed successfully."
