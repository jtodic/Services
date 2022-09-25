# Services
Što se tiće projekta podjeljen je na više dijelova.

Prvi dio sastoji se od service1 i service2 foldera u kojem se nalaze skripte za MS. Napravljena je kopija file-ova za posebne repozitorije na: 
https://github.com/jtodic/service1
https://github.com/jtodic/service2
jer sam smatrao da MS trebaju biti u zasebnim repozitorijima. Imamo i Jenkinsfile koji builda, tagira i push-a image.

Drugi dio projekta je docker-compose.yml u kojem je definiran docker-compose.yml i deployment.sh skripta koja koristi docker-compose a pokreće se sa:
./deployment.sh -1 1.0 -2 1.0 gdje se ubacuju verzije pojedinih MS.

Treći dio projekta je k8s folder u kojem se nalazi deployment-k8s.sh skripta koja deploy-a k8s yaml file-ove iz foldera:
./deployment-k8s.sh -1 1.0 -2 1.0 gdje se ubacuju verzije pojedinih MS.

Četvrti dio projekta su helm-service1 i helm-service2 folderi sa helm chart-ovima koji se pokreću sa deployment-helm.sh:
./deployment-helm.sh -1 1.0 -2 1.0 gdje se ubacuju verzije pojedinih MS.
