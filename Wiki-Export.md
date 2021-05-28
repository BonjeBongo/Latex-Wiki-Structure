# Printing the Wiki

### [Sure, here you go](./source/static/Wiki-bit-pdf-2021-04-18.pdf)


## Modifying the Wiki

Clone the wiki and edit as needed.

### Updating PDF

Only tested on ubuntu 20.04

Make sure you install `make` as a prerequisite

```bash
sudo apt install make -y
```

Within the cloned repository run `make install-dependencies`

> **NOTE:** *It takes a long time to install all of them, there are many fonts needed; patience, young padawan*

You can also install them yourself:

```
texlive pandoc texlive-latex-extra texlive-fonts-recommended texlive-fonts-extra librsvg2-bin
```

After all of those are set, run `make` or `make pdf`.

The updated pdf can be found under:

> **`./source/static/Wiki-but-pdf-YYYY-MM-DD.pdf`**

for settings and configs see `makefile`

[Wiki template](https://github.com/Wandmalfarbe/pandoc-latex-template) credits to [Pascal Wagler](https://github.com/Wandmalfarbe).