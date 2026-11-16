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
