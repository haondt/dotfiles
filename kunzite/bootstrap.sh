#!/usr/bin/env bash
set -euo pipefail
# assumes we are on a clean install of fedora workstation 43

#############
# DNS Setup #
#############
target_dns="192.168.1.132"

# Get the first active IPv4 DNS from NetworkManager
current_dns=$(nmcli dev show | grep 'IP4.DNS' | awk '{print $2}' | head -n1)

if [[ "$current_dns" == "$target_dns" ]]; then
    echo "DNS is already set to $target_dns. Skipping..."
else
    echo "Your current DNS is: $current_dns"
    echo "Do you want to set your DNS resolver to $target_dns? (y/N)"
    read -r set_dns

    if [[ "$set_dns" =~ ^[Yy]$ ]]; then
        echo "Setting DNS to $target_dns..."
        # Apply DNS to all active connections
        while IFS= read -r con; do
            [[ -z "$con" ]] && continue
            echo "Updating DNS for connection: $con"
            nmcli con mod "$con" ipv4.dns "$target_dns" ipv4.ignore-auto-dns yes \
                          ipv6.dns "" ipv6.ignore-auto-dns yes
            nmcli con up "$con" >/dev/null
        done < <(nmcli -t -f NAME c show --active)
        echo "DNS updated. Current DNS:"
        nmcli dev show | grep 'IP4.DNS'
    else
        echo "Skipping DNS setup."
    fi
fi

#################
# SSH key setup #
#################
ssh_key="$HOME/.ssh/id_ed25519"

if [[ -f "$ssh_key" ]]; then
    echo "SSH key already exists at $ssh_key. Skipping key generation."
else
    # Prompt for email
    read -rp "Enter the email address for your SSH key: " ssh_email
    if [[ -z "$ssh_email" ]]; then
        echo "Error: Email is required to generate SSH key. Exiting."
        exit 1
    fi

    echo "Generating a new SSH key..."
    ssh-keygen -t ed25519 -C "$ssh_email" -f "$ssh_key" -N ""
    echo "SSH key generated at $ssh_key"

    echo "Here is your public key. Add it to GitHub:"
    echo "--------------------------------------------------"
    cat "${ssh_key}.pub"
    echo "--------------------------------------------------"
    echo "You can add it here: https://github.com/settings/keys"
fi

set +euo pipefail
echo "Testing SSH connection to GitHub..."
if ssh -o StrictHostKeyChecking=no -o BatchMode=yes -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
    echo "SSH key is working with GitHub!"
else
    echo "SSH key is NOT working with GitHub."
    echo "Make sure you added the public key to your GitHub account: https://github.com/settings/keys"
    cat "${ssh_key}.pub"
    exit 1
fi

echo "Testing SSH connection to GitLab..."
if ssh -o StrictHostKeyChecking=no -o BatchMode=yes -T git@gitlab.com 2>&1 | grep -q "Welcome to GitLab"; then
    echo "SSH key is working with GitLab!"
else
    echo "SSH key is NOT working with GitLab."
    echo "Make sure you added the public key to your GitLab account: https://gitlab.com/-/user_settings/ssh_keys"
    cat "${ssh_key}.pub"
    exit 1
fi
set -eo pipefail
####################
# Use SSH for repo #
####################
echo "Assuming Git repo is at: $HOME/projects/dotfiles"
repo_path="$HOME/projects/dotfiles"

# Make sure the path exists
if [[ ! -d "$repo_path/.git" ]]; then
    echo "No Git repo found at $repo_path. Please clone it first."
    exit 1
fi

cd "$repo_path" || exit 1

current_url=$(git remote get-url origin)
echo "Current remote URL: $current_url"

if [[ "$current_url" =~ ^https://github.com/(.*)/(.*)\.git$ ]]; then
    user="${BASH_REMATCH[1]}"
    repo="${BASH_REMATCH[2]}"
    ssh_url="git@github.com:${user}/${repo}.git"

    if [[ "$current_url" != "$ssh_url" ]]; then
        git remote set-url origin "$ssh_url"
        echo "Remote updated to SSH: $ssh_url"
    else
        echo "Remote already using SSH."
    fi
else
    echo "Remote is already SSH or non-GitHub URL. Skipping."
fi

########################
# Install dependencies #
########################
sudo dnf install -y just yq

echo "Bootstrap completed successfully!"

