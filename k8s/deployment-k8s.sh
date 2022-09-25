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

cp service1-deployment.yaml service1-deployment-edited.yaml
cp service2-deployment.yaml service2-deployment-edited.yaml

sed -i "s|VERSION_PLACEHOLDER_INJECTED_AT_BUILD_TIME_1|${version_service1}|g" service1-deployment-edited.yaml
sed -i "s|VERSION_PLACEHOLDER_INJECTED_AT_BUILD_TIME_2|${version_service2}|g" service2-deployment-edited.yaml

kubectl apply -f service1-deployment-edited.yaml
kubectl apply -f service2-deployment-edited.yaml
kubectl apply -f service1-service.yaml
kubectl apply -f service2-service.yaml
kubectl apply -f avl-net-networkpolicy.yaml




