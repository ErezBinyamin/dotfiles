# Erez's bashrc stuff

These are some scripts that make my bash terminal a fun place to be!

## Getting Started

Just clone this repo and direct your bashrc source these files

### Samlpe Installation

Do these commands, then you'll be good

```bash
cd
git clone https://github.com/ErezBinyamin/Bash_init.git
printf '
INIT_DIR=/home/$USER/Bash_init
if [ -d ${INIT_DIR} ]; then
    for f in $(ls ${INIT_DIR}/*.sh)
    do
        source $f
    done
fi
' >> /home/$USER/.bashrc
source /home/$USER/.bashrc

```

# Example features
Both ascii and emoji branches are shown below. To learn about more capabilities of this fun repo, use the command:
```
erez
```

## Git command line
Autodetect git repository. Show repo name (in unique random color) and current branch name/status.

![Git Command line](img/ascii/gitcmdline.png)
![Git Command line](img/emoji/gitcmdline.png)

## Battery life
Battery life that goes from Green -> yellow -> orange -> red -> blinking red

![Git Command line](img/ascii/battery.png)
![Git Command line](img/emoji/battery.png)

## SSH awareness
Prompt is either a shell or a secure shell :)

![Git Command line](img/ascii/ssh.png)
![Git Command line](img/emoji/ssh.png)

## Cheat.sh
I did not make this, but it sure is great!

![Cheat.sh](img/cheatsh.png)
