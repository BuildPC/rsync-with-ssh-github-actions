# This file is adapted from https://github.com/alinz/ssh-scp-action and https://github.com/AEnterprise/rsync-deploy.
# All the actual credit goes to the original developers.

FROM debian:9.5-slim

RUN apt update
RUN apt -yq install rsync openssh-client openssl ca-certificates

# Label
LABEL "maintainer"="Kerem Gure <kerem.gure@ozu.edu.tr>"
LABEL "com.github.actions.name"="rsync-with-ssh-github-actions"
LABEL "com.github.actions.description"="Deploy to a remote server using rsync over ssh with arbitary command running support"
LABEL "com.github.actions.icon"="server"
LABEL "com.github.actions.color"="green"
LABEL "version"="1.0.0"

LABEL "repository"="https://github.com/BuildPC/rsync-with-ssh-github-actions"
LABEL "homepage"="https://github.com/BuildPC/rsync-with-ssh-github-actions"


ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]