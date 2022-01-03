FROM codercom/code-server:3.12.0

RUN sudo apt update

###install package
#tools
RUN sudo apt install -y wget
#python
RUN sudo apt install -y python3-pip
RUN sudo apt install -y python3-venv
RUN sudo pip3 install pylint
RUN sudo pip3 install jupyter

#dot net core 5.0
RUN sudo wget https://packages.microsoft.com/config/ubuntu/21.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
RUN sudo dpkg -i packages-microsoft-prod.deb
RUN sudo rm packages-microsoft-prod.deb
RUN sudo apt update; \
  sudo apt install -y apt-transport-https && \
  sudo apt update && \
  sudo apt install -y dotnet-sdk-5.0

RUN sudo bash -c '\
    curl -SsL https://github.com/boxboat/fixuid/releases/download/v0.4/fixuid-0.4-linux-amd64.tar.gz | tar -C /usr/local/bin -xzf - && \
    chmod 4755 /usr/local/bin/fixuid && \
    mkdir -p /etc/fixuid && \
    printf "user: coder\ngroup: coder\n" > /etc/fixuid/config.yml'

#postgre client
RUN sudo apt install curl ca-certificates gnupg
RUN curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/apt.postgresql.org.gpg >/dev/null
RUN sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
RUN sudo apt update
RUN sudo apt install -y postgresql-client-14

#nodejs
RUN sudo apt install -y nodejs npm
RUN sudo npm install n -g
RUN sudo n 12.22.5
RUN sudo apt purge -y nodejs npm
RUN sudo npm install --global yarn
RUN sudo npm install --global express-generator
RUN sudo npm install --global gitignore

ENTRYPOINT ["fixuid", "dumb-init", "code-server", "--host", "0.0.0.0"]

