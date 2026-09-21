# SSH Key Best Practices for Individual Developers (GitHub & GitLab)

This guide helps individual developers implement modern SSH key best practices for use with GitHub, GitLab, and similar platforms. These practices align with current standards for improved security, clarity, and maintainability.


## Step 1: Generate a Modern SSH Key (ed25519)

```bash
ssh-keygen -t ed25519 -f ~/.ssh/account_personal -C "comment" -a 100
```

* Replace `account_personal` with platform + underscore + account type e.g `github_personal` 
* Replace `comment` with personal/work + platform + month & year e.g `Personal Github - August 2026`
* The `-C` comment helps you track creation date and ownership
* Use a **strong passphrase** when prompted

<details>
<summary>Click to expand - Learn what the flags mean</summary>

* `-t ed25519`: specifying the algorithm
* `-f ~/.ssh/account_personal`: specifying the filename
* `-C "comment"`: specifying the comment embedded in the public key
* `-a 100`: sets the number of KDF rounds used to encrypt your private key with your passphrase

</details>

## Step 2: Add the SSH Key to SSH Agent

Start the SSH agent (if not already running):

```bash
eval "$(ssh-agent -s)"
```

Add the new key:

```bash
ssh-add ~/.ssh/account_personal
```


## Step 3: Add Public Key to GitHub & GitLab

Copy the public key:

```bash
cat ~/.ssh/account_personal.pub | pbcopy       # macOS

xclip -sel clip < ~/.ssh/account_personal.pub  # Linux
```

### GitHub:

1. Go to GitHub > Settings > SSH and GPG keys
2. Click **New SSH Key**
3. Name it descriptively (e.g., `MacBook 2025`)
4. Paste the public key

### GitLab:

1. Go to GitLab > Preferences > SSH Keys
2. Paste your public key
3. Set an expiration date if desired


## Step 4: Update SSH Config (defaults)

> Likely won't need changes since my default accounts won't change

Edit `~/.ssh/config`

```bash
Host github.com
    User git
    UseKeychain yes
    AddKeysToAgent yes
    IdentitiesOnly yes
    HostName github.com
    IdentityFile ~/.ssh/github_personal

Host gitlab.com
    User git
    UseKeychain yes
    AddKeysToAgent yes
    IdentitiesOnly yes
    HostName gitlab.com
    IdentityFile ~/.ssh/gitlab_personal
```


## Step 5: Update SSH Config (non-defaults)

Edit `~/.ssh/config` and adjust the following 
* Change Host: from github.com to company name
* Change IdentityFile: from github_personal to github_company

```bash
Host company-name
    User git
    UseKeychain yes
    AddKeysToAgent yes
    IdentitiesOnly yes
    HostName github.com
    IdentityFile ~/.ssh/github_company
```


## Step 6: Seperate Info for all Accounts 

Copy this template and create a file inside `~/.config/git/accounts/`
* Note: We do not need URL rewriting for my default github and gitlab account

```bash
# This is my default configuration for .gitconfig
# This is my seperate work configuration for .gitconfig

[user]
  name =
  email =
  # signingkey = ...

[commit]
  gpgsign = false # all commits should be GPG signed

[credential]
  helper = osxkeychain # external helper for when a username/password credential is needed

# URL rewriting
[url "git@<ssh-host-alias>:<account-or-org>/"]     # target: your SSH config alias + account namespace
  insteadOf = git@github.com:<account-or-org>/     # source: normal SSH-style URL for that account
  insteadOf = https://github.com/<account-or-org>/ # source: normal HTTPS-style URL for that account
```


## Step 7: Location for Account Activation

Edit `~/.config/git/config` and adjust the following
* Note: Default is for main account active for all git repos
* Note: Use includeIf for other accounts limited to git repos inside specific folders

# Default
[include]
  path = ~/.config/git/accounts/github

# Gitlab
[includeIf "gitdir:~/Desktop/writing/"]
  path = ~/.config/git/accounts/gitlab


## Miscellaneous

> Ensure all Identity Files have correct permissions

```bash
chmod 600 ~/.ssh/github_personal
chmod 600 ~/.ssh/gitlab_personal

# For any company accounts e.g
chmod 600 ~/.ssh/github_codepath
```

> Testing the Connection

```bash
ssh -T git@github.com
ssh -T git@gitlab.com

# For any company accounts e.g
ssh -T git@codepath
```

> Check what keys are loaded in your SSH agent

```bash
ssh-add -l
```

> Remove keys from SSH agent

```bash
ssh-add -D
```

