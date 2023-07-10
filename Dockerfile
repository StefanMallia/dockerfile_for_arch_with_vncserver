FROM archlinux

ARG vncpassword
ARG archpassword

RUN useradd -m -G wheel arch
RUN echo "arch:"${archpassword} | chpasswd
RUN echo "xfce4-session" > /home/arch/.xinitrc

RUN pacman -Syu --noconfirm
RUN pacman -S --noconfirm xorg-server xfce4

RUN pacman -S --noconfirm base-devel git extra/go
RUN git clone https://aur.archlinux.org/yay.git /tmp/yay

RUN useradd builduser -m
RUN passwd -d builduser
RUN echo 'builduser ALL=(ALL) NOPASSWD: /usr/bin/makepkg' >> /etc/sudoers
RUN echo 'builduser ALL=(ALL) NOPASSWD: /usr/bin/pacman' >> /etc/sudoers
RUN su - builduser -c "git clone https://aur.archlinux.org/yay.git /tmp/yay-build/yay"
RUN su - builduser -c "cd /tmp/yay-build/yay && makepkg -si --noconfirm"
RUN rm -rf /tmp/yay-build

RUN pacman -S --noconfirm xorg-server xfce4 xfce4-goodies tigervnc
RUN mkdir ~/.vnc
RUN printf "#!/bin/sh\nxrdb $HOME/.Xresources\nstartxfce4 &" | tee  ~/.vnc/xstartup
RUN printf "geometry=2560x1440" | tee  ~/.vnc/config
RUN chmod +x ~/.vnc/xstartup
RUN echo ${vncpassword} | vncpasswd -f > ~/.vnc/passwd
RUN chmod 600 ~/.vnc/passwd

RUN userdel builduser 
RUN pacman --noconfirm -R go

CMD ["vncserver", ":1"]

