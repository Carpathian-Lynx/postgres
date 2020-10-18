# Using PostgreSQL with Docker and Kubernetes

## Contents:
- [Docker](#using-docker)
- [Kubernetes](#using-kubernetes)
- [Connect to the database](#connect-to-the-database)

## Using Docker
If you wish to keep your data after you restart Docker, use the [Kubernetes](#using-kubernetes) section.

### Single line command

The easiest way to use PostgreSQL locally is:
```
docker run -e POSTGRES_PASSWORD=[your_pass_here] -p [port]:5432 postgres
```
This command does the following:
- sets the POSTGRES_PASSWORD environment variable
- publishes the internal port 5432 to whatever you give
- runs the image **postgres**

The PostgreSQL server will start in the same session. If you wish to start it in background, add a **-d** before the name of the image, like so:
```
docker run -e POSTGRES_PASSWORD=[your_pass_here] -p [port]:5432 -d postgres
```

Alternatively, you can use the [Docker Compose file](./docker/docker-compose.yml):
```
docker-compose up -d
```

### Running with initial setup scripts
To use .sql files in the container, you would first need to copy them in the container.
They will be executed in alphabetical order, so if you have multiple files, it would be a good idea to add a prefix(something like 001, or the date).
In the [Dockerfile](./docker/Dockerfile), a new **lynx-postgres** image is created.
Build the image:
```
docker build . -t lynx-postgres
```
Run the new image:
```
docker run [port]:5432 -d lynx-postgres
```

### Connect to server and run commands:
Determine container id:
```
docker ps
docker exec -it [container-id] psql -U [POSTGRES_USER]
```
By default, POSTGRES_USER is postgres, but can be easily set, exactly like POSTGRES_PASSWORD.

### Stop the container and cleanup
Stop the container:
```
docker stop [container-id]
```
Remove container:
```
docker rm [container-id]
```
Remove image:
```
docker rmi lynx-postgres
```

## Using Kubernetes
You can use [Kustomize](https://github.com/kubernetes-sigs/kustomize/releases/tag/kustomize%2Fv3.8.5), or you can use only kubectl.

### Only kubectl
Run the following to configure everything needed:
```
kubectl apply -f config-map.yaml
kubectl apply -f service.yaml
kubectl apply -f volume.yaml
kubectl apply -f volume-claim.yaml
kubectl apply -f deployment.yaml
```
Recreate:
```
kubectl rollout restart deployment postgres
```

### Kustomize
Run the following to configure everything needed:
```
kustomize build . | kubectl apply -f -
```

The first part is going to merge all the files in a single one. You can review it by removing the pipe.

The other steps are the same.

The Kubernetes version can also use the [lynx-postgres](#running-with-initial-setup-scripts) image created previously.

## Connect to the database
Your database is available at localhost:[port]/postgres, user postgres and the password you set.