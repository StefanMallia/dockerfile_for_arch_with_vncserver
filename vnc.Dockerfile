FROM arch-linux-base AS arch-linux-vnc

ARG vncpassword

RUN pacman -S --noconfirm xorg-server xfce4 xfce4-goodies tigervnc firefox code

RUN echo "xfce4-session" > /home/arch/.xinitrc

USER arch
RUN mkdir ~/.vnc
RUN printf "#!/bin/sh\nxrdb $HOME/.Xresources\nstartxfce4 &" | tee  ~/.vnc/xstartup
RUN printf "geometry=2560x1440" | tee  ~/.vnc/config
RUN chmod +x ~/.vnc/xstartup
RUN echo ${vncpassword} | vncpasswd -f > ~/.vnc/passwd
RUN chmod 600 ~/.vnc/passwd

CMD ["vncserver", ":1"]
