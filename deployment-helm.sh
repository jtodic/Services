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

helm install helm-service1 helm-service1 --set deployment.tag=$version_service1
helm install helm-service2 helm-service2 --set deployment.tag=$version_service2

