FROM ubuntu:18.04

MAINTAINER efen.fauzi@gmail.com

RUN apt-get update && \
	apt-get install  -y \
    apt-transport-https ca-certificates curl gnupg lsb-release \ 
	dumb-init	 zsh     htop     locales     man     nano     git  \
	procps     openssh-client     sudo     vim.tiny     lsb-release \
	wget sshfs && \
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
	echo \
	"deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
	$(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
	apt-get update && \
	apt-get install -y docker-ce docker-ce-cli containerd.io && \
	curl -sL https://deb.nodesource.com/setup_14.x |  bash - && \
    apt-get install -y nodejs && \
    npm install -g orcinus --unsafe-perm

# fix uid user/group pass from host to container
RUN adduser --gecos '' --disabled-password coder &&   echo "coder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd

RUN ARCH="$(dpkg --print-architecture)" &&     \
	curl -fsSL "https://github.com/boxboat/fixuid/releases/download/v0.5/fixuid-0.5-linux-$ARCH.tar.gz" | tar -C /usr/local/bin -xzf - &&  \
	chown root:root /usr/local/bin/fixuid &&     \
	chmod 4755 /usr/local/bin/fixuid &&     mkdir -p /etc/fixuid &&     \
	printf "user: coder\ngroup: coder\n" > /etc/fixuid/config.yml

# download latest code server	
RUN wget https://github.com/cdr/code-server/releases/download/v3.9.3/code-server_3.9.3_amd64.deb && \ 
	dpkg -i code-server_3.9.3_amd64.deb  && rm code-server_3.9.3_amd64.deb 

USER 1000
 
EXPOSE 8080

ENV USER=coder
WORKDIR /home/coder

COPY config.yaml /home/coder/.config/code-server/config.yaml
COPY entrypoint.sh /usr/bin/entrypoint.sh


ENTRYPOINT ["/usr/bin/entrypoint.sh","--bind-addr","0.0.0.0:8080","."]
