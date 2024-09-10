# Getting Started

## Download Chezmoi

To load the configurations first download Chezmoi from your package
manager, for debian based flavors use snap.

```
sudo snap install chezmoi
```

## Load Dotfiles

### Initialize Chezmoi with your repo

```
chezmoi init https://github.com/BrysonUrie/chezmoi-dotgfiles.git
```

### Run a diff to see the changes

```
chezmoi diff
```

### To apply the changes run

```
chezmoi apply -v
```

### Other wise you can try one of these options

To edit the file

```
chezmoi edit $FILE
```

To merge the file

```
chezmoi merge $FILE
```

## Update dotfiles

### To update remote with your changes

```
chezmoi cd
git add .
git commit
git push
```

### To pull and apply the latests changes

```
chezmoi update -v
```
