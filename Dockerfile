FROM centos:7
MAINTAINER "Masaaki Hirano" <lambda.groove@gmail.com>

# Timezone
RUN rm /etc/localtime
RUN ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# Locale
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8

# Cleanup
RUN yum update -y && yum clean all
RUN yum reinstall -y glibc-common

# User
RUN useradd dev-admin
RUN yum -y install sudo
RUN echo "dev-admin ALL=(ALL) ALL" > /etc/sudoers.d/dev-admin
RUN echo 'dev-admin:dev-admin' | chpasswd
RUN echo "export LANG=ja_JP.UTF-8" >> /home/dev-admin/.bashrc

# Install dev tools
RUN yum install -y gcc gcc-c++ make openssl-devel ncurses-devel zsh tmux git
RUN yum install -y epel-release
RUN yum install -y wget tar bzip2 incron
RUN yum clean all
RUN chsh dev-admin -s /bin/zsh

# Secret Keys
RUN mkdir /home/dev-admin/.ssh
RUN chmod 700 /home/dev-admin/.ssh
RUN touch /home/dev-admin/.ssh/config
RUN chmod 600 /home/dev-admin/.ssh/config
RUN chown -R dev-admin:dev-admin /home/dev-admin/.ssh
RUN /usr/bin/ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ''
RUN /usr/bin/ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N ''

# Initialize configs
RUN cd /home/dev-admin && git clone https://github.com/FL4TLiN3/dotfiles.git .dotfiles
RUN chown -R dev-admin:dev-admin /home/dev-admin/.dotfiles
RUN su - dev-admin -c 'cd /home/dev-admin/.dotfiles && sh bin/setup'
