# Dotfiles
This repository contains my personal dotfiles — configuration files for  the various programs and tools I use daily.

The repo is organized using GNU Stow, a symlink farm manager, with a per-package layout, and is designed to work across environments and branches, with a long-term goal of migrating to **nix-darwin** and
**home-manager**.

## Installation

To deploy these dotfiles on your system:

1. Clone this repository to your home directory:
   ```sh
   git clone https://github.com/asrarsyed/dotfiles.git ~/dotfiles
   ```

2. Navigate to the cloned repository:
   ```sh
   cd ~/dotfiles
   ```

## Stow Layout

This repo uses a **per-package layout**, meaning:

- Packages are stowed explicitly (never implicitly)
- Each package mirrors its target directory structure internally
- `stow .` is intentionally avoided and blocked to prevent accidental mass symlinking.
- `stow */` is intentionally avoided and blocked to prevent also symlinking .archive folder.

## Usage
To add new configurations or update existing ones:

1. Add or modify the files within their respective directories in dotfiles repository.
2. Re-run the `stow` command for the configurations you've updated:
   ```sh
   stow tmux vim
   ```

## Bulk Stowing

A custom script (e.g. `stowdots`) is used to:

- Stow / restow / unstow **all packages at once**
- Automatically **exclude `.git` and `.archive`** directories
- Optionally exclude more directories via a `.stowrc` file

## Homebrew Manager

Homebrew is managed **declaratively**:

- A `.brewfile` defines all installed packages
- If something is **not in the brewfile**, it should **not be installed**
- Installing / uninstalling / cleaning is done via aliases that enforce this rule

## Git Worktree Workflow

This repo is designed to be used with **Git worktrees**:

- **`maindot`** — stable, daily-use configuration
- **`workdot`** — stripped-down essentials for work
- **`sandbox`** — experimental changes and testing

### Typical flow

1. `sandbox` is created from `maindot`
2. Experiments happen in `sandbox`
3. Stable changes are promoted back into `maindot`
4. `workdot` selectively cherry-picks from `maindot`

This avoids copy-pasting dotfiles while keeping environments clean and intentional.

## Future Plans: Nix Manager

Long-term, this repo is structured to migrate toward:

- **nix-darwin** (macOS system config)
- **home-manager** (user-level dotfiles)
- Possibly **NixOS** if/when I leave macOS

The per-package layout and declarative approach are intentional steps in that direction.

## Contributing

Feel free to suggest improvements or contribute to this repository by opening issues or pull requests. Your feedback and contributions are highly appreciated!

## License

This repository is licensed under the [MIT License](LICENSE). Feel free to use and modify the configurations as you see fit.
