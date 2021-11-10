# Empty the welcome message
set fish_greeting

# Setup Homebrew
set homebrew_file ~/homebrew/bin/brew
if test -x $homebrew_file
	eval ($homebrew_file shellenv)
	set --export HOMEBREW_CASK_OPTS "--require-sha --appdir=~/Applications"
end

# Setup goenv
if type --quiet goenv
	source (goenv init - | psub)
end

if status is-interactive
  # Set GPG terminal
  set --export GPG_TTY (tty)

	# Setup Ruby
  # For compilers to find ruby you may need to set:
  # set -gx LDFLAGS "-L/Users/veniamin/homebrew/opt/ruby/lib"
  # set -gx CPPFLAGS "-I/Users/veniamin/homebrew/opt/ruby/include"
  # For pkg-config to find ruby you may need to set:
  # set -gx PKG_CONFIG_PATH "/Users/veniamin/homebrew/opt/ruby/lib/pkgconfig"
end

alias g "git"
