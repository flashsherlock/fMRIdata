#! /bin/csh

# The format for publishing ports is hostPort:containerPort
set GITLAB_HOME=/Volumes/WD_D/gufei/gitlab

docker run --detach \
    --publish 443:443 --publish 80:80 --publish 2222:22 \
    --name gitlab \
    --restart always \
    --volume $GITLAB_HOME/config:/etc/gitlab \
    --volume $GITLAB_HOME/logs:/var/log/gitlab \
    --volume $GITLAB_HOME/data:/var/opt/gitlab \
    gitlab/gitlab-ce:latest