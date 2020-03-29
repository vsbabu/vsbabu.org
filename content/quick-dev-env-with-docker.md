+++
title = "Quick development envs with Docker"
date = 2018-06-06T06:00:00+05:30
description = "Before moving production envs to Docker, use it for making new dev setup painless."
weight = 1
draft = false
in_search_index = true
[taxonomies]
categories = ["article"]
tags = [ "cli", "productivity", "docker"]
+++
Very often, we end up setting up an entirely different machine for testing our stuff.
Of late, I’ve been using docker on Ubuntu 18.04 for testing individual environments for various projects I work on.

That way, when things finally make into production, I am sure that I’ve not forgotten 
to handle dependencies, configuration parameters required etc.

An added advantage is when you decide upon release version names. For each release,
you’ve an environment with version name as environment name. Later, when you want to
make a hotfix on a branch of a version, just spin up that container to bring back your test bed.

So, what are the two key requirements to get this done?
1. Always use named containers _(despite docker’s random names for unnamed containers being quite entertaining)__.
2. Just check for presence of named container and start it if it exists.

docker containers exit once the process you started with the container exits. Essentially, the trick is to 
have a name first instead of having to always look at container ids.

## Making a container

```sh
docker run \
--name helloworld_v10 \         #that is your container name
-e HOST_IP=192.168.0.5 \        #host's ip address
-v $HOME/code/helloworld:/src \ #host folder mapped to container
-t -i ubuntu \                  #get latest ubuntu image
/bin/bash                       #start shell
```

This will setup a container with the name given and drop you into bash shell.

Let us try installing `sqlite3`; just to prove the point of reusing and sharing the files across host and container.

```sh
apt update
apt install sqlite3
cd /src
sqlite3 test.db
exit
```
Now, I can see _test.db_ in _$HOME/code/helloworld_ folder in my host. I use whatever editor 
_(VIM, if you ask)_ on my host and do the version control stuff _(git or fossil)_ also from there.
But for executing and testing my work, I use the container.

## Reusing the container
```sh
docker ps -a                #shows that our container is inactive
docker start helloworld_v10 #starts the container
docker exec -it \
 `docker ps -a -q --filter "name=helloworld_v10"`\
 /bin/bash                  #you are back into the container
cd src && sqlite3 test.db   #yes, it is your old container
```

## Collecting all to a script
```sh
#!/bin/bash
# Quick script to manage latest ubuntu docker containers
#   Useful for spinning up machines for development
# args:
#   name-of-machine
#   make|start|stop
#   make > sharedfolderhere:target
CONTAINER=$1
OP=$2
if [ "${OP}xx" == "makexx" ]; then
  # do an ifconfig to see which is your etherner interface and
  # change it from eno1 below
  docker run \
    --name ${CONTAINER} \
    -e HOST_IP=$(ifconfig eno1 | awk '/ *ether /{print $2}') \
    -v $3 \
    -t -i \
    ubuntu /bin/bash
fi
if [ "${OP}xx" == "startxx" ]; then
  #check if it is already there
  FOUND=""
  FOUND=`docker ps -a -q --filter "name=$CONTAINER"`
  if [ "${FOUND}xx" != "xx" ]; then
    docker start $CONTAINER
    docker exec -it $FOUND /bin/bash
  else
    echo "Error: Could not find a container $CONTAINER"
  fi
fi
if [ "${OP}xx" == "stopxx" ]; then
  docker stop $CONTAINER
fi
```

And just use it like below:
```sh
dockermachine.sh helloworld_v11 make $HOME/code/helloworld:/src
dockermachine.sh helloworld_v11 start
```

If you really don’t want this container, you can always manually remove the container like:

```sh
docker rm -f `docker ps -a -q --filter "name=$CONTAINER"`
```

To transport to other machines, `docker export` and `docker import` should work; I’ve not yet tried that yet.

PS: This article was [posted in
medium.com](https://medium.com/@vsbabu/quick-development-envs-with-docker-a334e7be6774) as well.


