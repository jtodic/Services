#!/bin/bash
while getopts "1:2:" flag
    do
             case "${flag}" in
                    1) version_service1=${OPTARG};;
                    2) version_service2=${OPTARG};;
             esac
    done
    echo "version_service1: $version_service1";
    echo "version_service2: $version_service2";


if [ $# -eq 0 ]; then
    echo "No arguments provided"
    exit 1
fi

cp docker-compose.yml docker-compose-edited.yml

sed -i "s|VERSION_PLACEHOLDER_INJECTED_AT_BUILD_TIME_1|${version_service1}|g" docker-compose-edited.yml
sed -i "s|VERSION_PLACEHOLDER_INJECTED_AT_BUILD_TIME_2|${version_service2}|g" docker-compose-edited.yml

cat docker-compose-edited.yml

docker-compose -f docker-compose-edited.yml up

