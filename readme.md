# Erez's bashrc stuff

Theese are some scripts that make my bash terminal a fun place to be!

## Getting Started

Just clone this repo and direct your bashrc source these files

### Samlpe installation

Do these commands, then you'll be good

```bash
cd
git clone https://github.com/ErezBinyamin/.init.git
printf '
INIT_DIR=/home/$USER/.init
if [ -d ${INIT_DIR} ]; then
    for f in $(ls ${INIT_DIR}/*.sh)
    do
        source $f
    done
fi
' >> /home/user/.bashrc
```
## Demo
<a href="https://imgflip.com/gif/31bcz5"><img src="https://i.imgflip.com/31bcz5.gif" title="made at imgflip.com"/></a>
