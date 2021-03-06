# MCS Box

This project aims to be a simple way to run a minecraft server in a container. This is very much convention over configuration in the sense that it was built to work in a specific situation and very little, or no options for configuration are available.

The container is built with the assumption that a `/mcs` volume is mounted which contains the minecraft server, including the world directory.

When the container is started, it checks a `mcs-meta.json` file. If the version in the container is newer than the version in `/mcs`, then the various configuration and binaries will be copied to the mount, making for a smoother upgrade experience.

## Update
It turns out that the virtual CPUs provided in my cloud host of choice is not beefy enough to handle this strategy and I'm moving on to other projects, so I switched to a dedicated host which runs about the same price I was paying on the cloud host.

## Build the container
```Shell
docker build -t mcs-box .
```

## Run mcs-box
```Shell
docker run -p 25565:25565 -v $(pwd)/mcs:/mcs mcs-box
```
## Structure

### server

This directory holds the configuration files and binaries that will be copied to the `/mcs` directory.

### datapacks

This directory holds datapack zip files that will be copied to the `/mcs/world/datapacks` directory.

## Upgrading the server

To upgrade the server, the following will most likely need to be updated.

* **mcs-meta.json** - Update the version so that other changes are copied to `/mcs`
* **server.jar** - This is the Minecraft server.jar (e.g. 1.17, 1.18, etc.). Found at [https://www.minecraft.net/en-us/download/server](https://www.minecraft.net/en-us/download/server)
* **server.properties** - This properties file is read by `server.jar` when the server starts up
* **datapacks** - These are modifications that can be made to the server. May we suggest [https://vanillatweaks.net](https://vanillatweaks.net) as a potential source for some of our favorite datapacks?