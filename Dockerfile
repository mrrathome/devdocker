FROM library/debian
LABEL maintainer "Matt Q. <mattsmailq@gmail.com>"
ARG user
ARG uid
ARG group
ARG gid
ARG docker_gid
ARG DEBIAN_FRONTEND=noninteractive

LABEL ids=$user.$uid.$group.$gid.$docker_gid

RUN mkdir -p /home/$user
VOLUME /home/$user

### We want to pull in some packages from testing.  Copy in the appropriate
### configuration before we update anything
COPY download.docker.com.linux.debian.gpg deb.nodesource.com.gpg start.sh /tmp/
RUN groupadd -g $docker_gid docker \
	&& groupadd -g $gid $group \
	&& useradd $user -u $uid -g $group -G docker -d /home/$user --shell /bin/bash \
	&& chown $user:$group /home/$user \
	&& echo "deb http://deb.debian.org/debian stretch main" \
		> /etc/apt/sources.list.d/stretch.list \
	&& apt-get update && apt-get install -y --no-install-recommends \
		apt-transport-https \
		apt-utils \
		lsb-release \
		software-properties-common \
	&& apt-key add /tmp/download.docker.com.linux.debian.gpg \
	&& rm /tmp/download.docker.com.linux.debian.gpg \
	&& echo "deb [arch=amd64] https://download.docker.com/linux/debian \
		$(lsb_release -cs) \
		stable" > /etc/apt/sources.list.d/docker.list \
	&& apt-key add /tmp/deb.nodesource.com.gpg \
	&& rm /tmp/deb.nodesource.com.gpg \
	&& echo "deb https://deb.nodesource.com/node_8.x \
		$(lsb_release -cs) \
		main" > /etc/apt/sources.list.d/nodesource.list \
	&& echo "deb-src https://deb.nodesource.com/node_8.x \
		$(lsb_release -cs) \
		main" >> /etc/apt/sources.list.d/nodesource.list \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends \
		apt-file \
		autoconf \
		automake \
		awscli \
		bash-doc \
		bc \
		binutils-doc \
		bison \
		build-essential \
		ca-certificates \
		chromium \
		curl \
		dnsutils \
		doc-base \
		docker-ce \
		docutils-doc \
		file \
		firefox-esr \
		flex \
		gdb \
		git \
		git-doc \
		git-svn \
		gitk \
		gnupg2 \
		info \
		less \
		libffi-dev \
		libssl-dev \
		man-db \
		manpages \
		manpages-dev \
		nodejs \
		openjdk-7-jre \
		openssh-client=1:7* \
			libgssapi-krb5-2=1.15* \
			libkrb5-3=1.15* \
			libkrb5support0=1.15* \
			libk5crypto3=1.15* \
		python \
		python-doc \
		python-dev \
		python-pip \
		python-setuptools \
		python-setuptools-doc \
		python-wheel \
		python3 \
		python3-dev \
		python3-pip \
		python3-setuptools \
		screen \
		sudo \
		vim \
		vim-doc \
		xz-utils \
	&& pip install \
		ansible \
		boto3 \
	&& apt-file update \
	&& echo "$user ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/$user

USER $uid
WORKDIR /home/$user

CMD ["/bin/bash", "/tmp/start.sh"]
