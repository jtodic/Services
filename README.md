# Services
As for the project, it is divided into several parts.

The first part consists of the service1 and service2 folders, which contain scripts for MS. A copy of files for special repositories was made at:
https://github.com/jtodic/service1
https://github.com/jtodic/service2
because I thought that MS should be in separate repositories. We also have a Jenkinsfile that builds, tags and pushes images.

The second part of the project is docker-compose.yml in which docker-compose for MS is defined and the deployment.sh script that uses docker-compose and is started with:
./deployment.sh -1 1.0 -2 1.0 where the versions of individual MS are inserted.

The third part of the project is the k8s folder, which contains the deployment-k8s.sh script that deploys the k8s yaml files from the folder:
./deployment-k8s.sh -1 1.0 -2 1.0 where the versions of individual MS are inserted.

The fourth part of the project is the helm-service1 and helm-service2 folders with helm charts that are launched with deployment-helm.sh:
./deployment-helm.sh -1 1.0 -2 1.0 where the versions of individual MS are inserted.
