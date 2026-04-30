# Feeco Dotfiles


## Init Chezmoi on new device
```
sudo snap install chezmoi --classic && chezmoi init --apply Feeco-Li
```

## Commands
```
alias updatedotfiles='chezmoi re-add'
alias syncdotfiles='chezmoi update'
alias cddotfiles='cd ~/.local/share/chezmoi && ranger'
alias adddotfiles='chezmoi add'
alias removedotfiles='chezmoi destroy'
alias diffdotfiles='chezmoi status'
```
