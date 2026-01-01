# Set thunar and nvim default terminal to kitty

```
mkdir -p ~/.config/Thunar
vim ~/.config/Thunar/helpers.rc
```
text in file: 
```
TerminalEmulator=/usr/bin/kitty
```

another file
```
vim ~/.local/share/applications/nvim-terminal.desktop
```

text in file:
```
[Desktop Entry]
Type=Application
Name=Neovim (Terminal)
Exec=kitty nvim %F
Terminal=false
MimeType=text/plain;
```

refreshing mime to apply changes

```
update-desktop-database ~/.local/share/applications
xdg-mime default nvim-terminal.desktop text/plain
```



