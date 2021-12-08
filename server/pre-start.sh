#!/bin/bash

function version_gt() {
    test "$(echo "$@" | tr " " "\n" | sort -V | head -n 1)" != "$1";
}

function migrate-config() {
    cp -f /mcs-server/* /mcs
}

function migrate-datapacks() {
    mkdir -p /mcs/world/datapacks
    rm -f /mcs/world/datapacks/*.zip
    cp -f /mcs-extras/* /mcs/world/datapacks
}

function pre-start-script() {
    if [ ! -f "/mcs/mcs-meta.json" ]; then
        echo "mcs-meta.json does not exist in /mcs, migrating configs from container to /mcs";
        migrate-config;
        migrate-datapacks;
        return;
    fi

    BOX_VERSION=$(jq '.version' "/mcs-server/mcs-meta.json");
    VOL_VERSION=$(jq '.version' "/mcs/mcs-meta.json");
    if version_gt "$BOX_VERSION" "$VOL_VERSION"; then
        echo "mcs-meta.json version in container is higher, migrating config from container to /mcs";
        migrate-config;
        echo "migrating datapacks";
        migrate-datapacks;
    fi

    echo "Done with pre-start";
}

echo "Running pre-start"
pre-start-script