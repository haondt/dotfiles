## Installation

```shell
# set up minimal dependencies
./bootstrap.sh

# set up full config
just install [machine]
```

## Additional configuration

There are some things that are not included in the default `just install`, as they are a bit riskier and should be handled one at a time.

```shell
just install storage
just install grub
```

## Other tools

```shell
# reinstall
just install --force

# (re)install individual components
just install [--force] zsh neovim

# system update
just update [machine]

# configure a specific component(s)
just configure zsh tmux

# show terminal colors
just show colors
```

Generally speaking, `just install` installs and configures software at the root or user level. `just configure` does not ask for the root password, and therefore can only configure software at the user level.
