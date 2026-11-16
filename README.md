# dotfiles

## Homebrew on a new Mac

Homebrew lives in `~/homebrew` (not the default `/opt/homebrew`), so it needs no `sudo`.
Some formulae have no prebuilt binaries for a non-default prefix and build from source, which is slower but works.

1. Install the Xcode Command Line Tools:

   ```sh
   xcode-select --install
   ```

2. Install Homebrew into `~/homebrew`:

   ```sh
   cd ~ && mkdir homebrew && curl -L https://github.com/Homebrew/brew/tarball/main | tar xz --strip-components 1 -C homebrew
   eval "$(~/homebrew/bin/brew shellenv)"
   brew update --force --quiet
   ```

3. Copy the Homebrew settings (no analytics, apps go to `~/Applications`, casks must have a checksum):

   ```sh
   mkdir -p ~/.homebrew && cp .homebrew/brew.env ~/.homebrew/brew.env
   ```

4. Install the tools, then the apps:

   ```sh
   brew bundle --file=Brewfile
   brew bundle --file=Brewfile.casks
   ```

5. Make Homebrew's fish the login shell:

   ```sh
   echo ~/homebrew/bin/fish | sudo tee -a /etc/shells
   chsh -s ~/homebrew/bin/fish
   ```

   `fish/config.fish` puts `~/homebrew` on `PATH` in every new shell.

To check later that everything in both files is installed:

```sh
brew bundle check --file=Brewfile
brew bundle check --file=Brewfile.casks
```

## Fish on a new Mac

Do this after Homebrew (fish comes from the `Brewfile`). Run it from the repo root.

1. Link the config and the plugin list into `~/.config/fish`:

   ```sh
   mkdir -p ~/.config/fish
   ln -sf "$PWD/fish/config.fish" ~/.config/fish/config.fish
   ln -sf "$PWD/fish/fish_plugins" ~/.config/fish/fish_plugins
   ```

2. Install fisher, then the plugins from `fish_plugins`:

   ```sh
   fish -c 'curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher update'
   ```

### Plugins

Managed by [fisher](https://github.com/jorgebucaran/fisher). Add or remove with `fisher install <plugin>` / `fisher remove <plugin>`: fisher rewrites `fish_plugins` itself (comments there would be lost, so they're described here).

| Plugin | What it does |
|---|---|
| `jorgebucaran/fisher` | The plugin manager itself |
| `PatrickF1/fzf.fish` | fzf key bindings: search history (Ctrl+R), files (Ctrl+Alt+F), git log/status, processes, variables |
| `edc/bass` | Runs bash scripts and keeps their environment changes: `bass source script.sh` |

### Local and corporate settings

Anything that must not be pushed (company endpoints, tokens, work-only tools) goes in `~/.config/fish/local.d/*.fish`.
`config.fish` sources these files last, in name order, so they can use everything set up before them and override it.
They live outside the repo, so they can't be committed by accident.

```fish
# ~/.config/fish/local.d/work.fish
set -gx VAULT_ADDR https://vault.example.com
```

## Git on a new Mac

Link the config and the global ignore list into `~/.config/git` (run from the repo root):

```sh
mkdir -p ~/.config/git
ln -sf "$PWD/git/config" ~/.config/git/config
ln -sf "$PWD/git/ignore" ~/.config/git/ignore
```

`~/.gitconfig` must not exist: git reads it after `~/.config/git/config`, so it would override the repo settings.

Commits are signed with the YubiKey SSH key `~/.ssh/id_yubikey_1.pub` through ssh-agent (started by `config.fish`).

### Local and corporate settings

Put work email, company-only rules and anything else that must not be pushed in `~/.config/git/local`. `git/config` includes it last, so it overrides the repo settings. For example, to sign every commit in company repos:

```ini
# ~/.config/git/local
[includeIf "hasconfig:remote.*.url:git@github.com:my-company/**"]
	path = ~/.config/git/my-company
```
