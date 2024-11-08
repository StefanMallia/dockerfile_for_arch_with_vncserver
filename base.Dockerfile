FROM archlinux AS arch-linux-base

ARG archpassword

RUN useradd -m -G wheel arch
RUN echo "arch:"${archpassword} | chpasswd
RUN echo 'arch ALL=(ALL) ALL' >> /etc/sudoers

RUN pacman-key --init
RUN pacman -Sy archlinux-keyring --noconfirm
RUN pacman -Syu --noconfirm
RUN pacman -Syu --noconfirm neovim

RUN pacman -Sy --noconfirm base-devel git extra/go
RUN git clone https://aur.archlinux.org/yay.git /tmp/yay

RUN useradd builduser -m
RUN passwd -d builduser
RUN echo 'builduser ALL=(ALL) NOPASSWD: /usr/bin/makepkg' >> /etc/sudoers
RUN echo 'builduser ALL=(ALL) NOPASSWD: /usr/bin/pacman' >> /etc/sudoers
RUN su - builduser -c "git clone https://aur.archlinux.org/yay.git /tmp/yay-build/yay"
RUN su - builduser -c "cd /tmp/yay-build/yay && makepkg -si --noconfirm"

RUN rm -rf /tmp/yay-build
RUN rm -rf /home/builduser
RUN sed -i -e 's|builduser ALL=(ALL) NOPASSWD: /usr/bin/makepkg||g' /etc/sudoers
RUN sed -i -e 's|builduser ALL=(ALL) NOPASSWD: /usr/bin/pacman||g' /etc/sudoers
RUN userdel builduser 
RUN pacman --noconfirm -R go
WORKDIR /home/arch

CMD ["tail", "-f", "/dev/null"]
