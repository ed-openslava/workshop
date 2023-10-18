# Workshop Requirements

If you want to follow along there are some containers that you need to pull up front so you do not waste any time during the workshop.

## Software

Docker Desktop is preferred however Podman or any other means to run containers is ok.

## Resources

This workshop is resource intensive. Please make sure you have your Containers can consume at least:

* CPU 4 cores
* RAM 4 GB
* SWAP 2 GB

## Container Images to Pull

```bash
docker pull gitlab/gitlab-ce:15.11.13-ce.0
docker pull gitlab/gitlab-runner:alpine3.15-v15.11.1
docker pull registry.gitlab.com/gitlab-org/build/cng/gitlab-container-registry:v3.15.0-gitlab
docker pull registry:2.8.3
docker pull hashicorp/vault:1.14.4
docker pull alpine:3.18.4
```

-----

BEYOND POOR MAN'S CI/CD TOOLCHAIN

To follow along hands on part of the workshop comfortably there are some preparation steps and requirements. 

* Ability to run containers locally (docker is preferred however podman or any other way to run containers is ok)
* Allocate enough resources for containers, minimum:
  * 4 CPU Cores
  * 4 GB RAM
  * 2 GB swap
  * 10-20 GB Virtual disk
* Locally pulled images:
  * gitlab/gitlab-ce:15.11.13-ce.0
  * gitlab/gitlab-runner:alpine3.15-v15.11.1
  * registry:2.8.3
  * hashicorp/vault:1.14.4
  * alpine:3.18.4
* Preferred terminal with shell of your choice
* Git installed
* Code editor or IDE of your choice
* Windows machines needs WSL2
