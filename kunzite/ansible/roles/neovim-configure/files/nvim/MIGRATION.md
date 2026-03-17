This repo has recently been updated for nvim 0.11.6 and switched from packer to lazyvim. some steps that will help with migration:

- Clear out packer installs to prevent conflicts

```sh
rm -rf ~/.local/share/nvim/site/pack/packer
```

- Upgrade bob and nvim

```
~ cargo install --git https://github.com/MordechaiHadad/bob.git
...
~ bob -V
bob-nvim 4.1.6
~ bob use v0.11.6
~ nvim --version
NVIM v0.11.6
Build type: Release
LuaJIT 2.1.1741730670
Run "nvim -V1 -v" for more info
```
