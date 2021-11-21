# Docker-Repo

This repo beholds two different folders to create images for running Jupyterlab v3.x with GPU support. The `Docker-GPU-R` folder additionaly installs 'rpy2' and 'tidyverse' for using R inside Jupyter Notebooks. 

## New features


## How to use

Clone this repository:

```
git clone https://github.com/Huertas97/Docker-Repo.git
```

In each folder there is a `.env` file where you should add your personal information: 

```
COMPOSE_PROJECT_NAME=""
MONGO_USER=""
MONGO_PASSWORD=""
MONGO_ACCESS_URL=""

JUPYTER_PASSWORD=""

JUPYTERLAB_CONTAINER_NAME=""
JUPYTERLAB_PORT=""

MONGO_CONTAINER_NAME=""
MONGODB_PORT=""
UID=""
GID=""
USER=""
```

Move to the desired folder:

```
cd Docker-GPU-R
```

If you run `ls -a` you should see the following output:

```
.  ..  .env  .ipynb_checkpoints  .virtual_documents  Demo_functionalities.ipynb  docker-compose.yml  jupyterlab_GPU
```

In case it is the fisrt time you create the image run the following command to create and start the Docker image:
```
docker-compose --env-file .env up -d --build
```

If the Docker image already exists but it is not running and you want to start it, run:
```
docker-compose --env-file .env up -d
```

## Include new libraries during the Docker Image creation



### Apply changes
If you make any changes inside the folder (like changing the libraries to install) you should stop and remove the image and build it again. First we can list the running Docker Images:
```
docker ps
CONTAINER ID   IMAGE      COMMAND                  CREATED          STATUS          PORTS                                        NAMES
1b4612355955   image_1    "jupyter lab --ip=0.…"   41 minutes ago   Up 41 minutes   0.0.0.0:xxxx->8888/tcp, :::xxxx->8888/tcp    IMAGE_NAME_1
03691aa6dzfv   image_2    "sh -c 'jupyter note…"   4 days ago       Up 4 days       0.0.0.0:xxxx->8888/tcp, :::xxxx->8888/tcp    IMAGE_NAME_2
```

