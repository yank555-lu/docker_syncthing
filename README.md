## Create Image ##

The following Dockerfile will setup a Syncthing Server based on an Ubuntu 20.04 LTS server image.

    docker build -t syncthing-server:focal \
        --build-arg GUI_ADDRESS="127.0.0.1" \
        --build-arg GUI_PORT="8384" \
        --build-arg USERNAME=$USER \
        .

## Network cofiguration ##

In order to bind the ubuntu server container into your network, bridging it with your physical network interface, you need to create a macvlan docker network for your container :

    docker network create \
        -d macvlan \
        --subnet <your subnet> \
        --gateway <the gateway address in your network> \
        --ip-range <the IP address range available in this docker network> \
        -o parent=<network interface to bind to> \
        <docker network name>

Example :

    docker network create \
        -d macvlan \
        --subnet 192.168.10.0/24 \
        --gateway 192.168.10.1 \
        --ip-range 192.168.10.10/32 \
        -o parent=eth0 \
        my_service

* Note : setting the IP range to "/32" allows for only one IP to be usable by docker, under which the docker container host is reachable by other machines on your network.

## Create Container ##

Use following command to create a container from the image :

    docker run -d \
        --restart unless-stopped \
        --name syncthing-server \
        --network <docker_network> \
        -h syncthing-server \
        -v <local_syncthing_data>:/home/syncthing \
        syncthing-server:focal

The root syncthing data folder will be set to /home/syncthing, so if you want your data to be on your local file-system, bind-mount the root of your local folder there.

* Note : the container will restart (on reboots or whenever it stops) unless you explicitely stop it manually.
