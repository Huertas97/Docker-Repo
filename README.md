# Docker-Repo :robot::whale::desktop_computer:

- [Docker-Repo :robot::whale::desktop_computer:](#docker-repo-robotwhaledesktop_computer)
- [JupyterLab](#jupyterlab)
  - [New features](#new-features)
    - [Debugger](#debugger)
    - [Plotly and Plotly Chart editor](#plotly-and-plotly-chart-editor)
    - [Drawio](#drawio)
    - [NVIDIA Dashboard](#nvidia-dashboard)
    - [Use R and tidyverse](#use-r-and-tidyverse)
    - [Themes](#themes)
  - [How to use](#how-to-use)
  - [Include new libraries](#include-new-libraries)
    - [Apply changes](#apply-changes)
- [Jupyterlab & Conda](#jupyterlab--conda)
  - [Create a new conda environment](#create-a-new-conda-environment)
  - [Add new jupyterlab extensions and re-build it](#add-new-jupyterlab-extensions-and-re-build-it)
- [VSCode](#vscode)

--- 

This repo beholds two different folders to create images for running Jupyterlab v3.x with GPU support. The `Docker-GPU-R` folder additionaly installs 'rpy2' and 'tidyverse' for using R inside Jupyter Notebooks. 

# JupyterLab

## New features

### Debugger
https://user-images.githubusercontent.com/56938752/142846483-4f1e8287-332c-40ae-86fb-ef40a24ed528.mp4

### Plotly and Plotly Chart editor


https://user-images.githubusercontent.com/56938752/142846772-383875a3-dbd4-40a6-aa52-d02ce1761a5e.mp4



### Drawio



https://user-images.githubusercontent.com/56938752/142850275-8926fdc5-9e06-4662-b5cb-81d008237188.mp4



### NVIDIA Dashboard


https://user-images.githubusercontent.com/56938752/142846761-df6d2913-3fec-49ce-a0a0-ebfab2e393ab.mp4


### Use R and tidyverse


https://user-images.githubusercontent.com/56938752/142846797-1fbcf616-b61a-43d1-8635-bcf7c8a9f546.mp4


### Themes


https://user-images.githubusercontent.com/56938752/142846785-0b56f68c-a28b-4bfa-8f6e-abe85613ba6a.mp4


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

Note: If you don't want MongoDB feel free to only complete `COMPOSE_PROJECT_NAME`, `JUPYTER_PASSWORD`, `JUPYTERLAB_CONTAINER_NAME`, `JUPYTERLAB_PORT`, `UID`, `GID` and `USER`.

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

## Include new libraries

If yuo want to add new libraries in the Docker Image you should change the `Dockerfile` inside the `jupyterlab_GPU` folder. 
For the sake of clarity, let's do an example. 

The initial `Dockerfile` contains:

```
FROM tensorflow/tensorflow:latest-gpu
FROM vrodriguezf/jupyterlab-cuda:latest

# INSTALL R
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends build-essential r-base r-cran-randomforest

# UPGRADE PIP
RUN pip3 install --upgrade pip

# PYTHON PACKAGES with pip
RUN pip3 install scikit-learn fastgpu nbdev pandas transformers tensorflow-addons \
     tensorflow torch pymongo torch emoji python-dotenv
```

and we want to add `tidyverse` library for R and `plotly` for Python:

```
FROM tensorflow/tensorflow:latest-gpu
FROM vrodriguezf/jupyterlab-cuda:latest

# INSTALL R
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends build-essential r-base r-cran-randomforest

# ADD  tidyverse
RUN echo 'install.packages("tidyverse")' > /tmp/packages.R && Rscript /tmp/packages.R

# UPGRADE PIP
RUN pip3 install --upgrade pip

# PYTHON PACKAGES with pip - ADD plotly
RUN pip3 install scikit-learn fastgpu nbdev pandas transformers tensorflow-addons \
     tensorflow torch pymongo torch emoji python-dotenv plotly
```


### Apply changes
If you make any changes inside the folder (like changing the libraries to install) while the image is already running, you should stop and remove the image and build it again. For the sake of clarity, let's do an example. 

First we can list the running Docker Images:
```
docker ps
CONTAINER ID   IMAGE      COMMAND                  CREATED          STATUS          PORTS                                        NAMES
1b4612355955   image_1    "jupyter lab --ip=0.…"   41 minutes ago   Up 41 minutes   0.0.0.0:xxxx->8888/tcp, :::xxxx->8888/tcp    IMAGE_NAME_1
03691aa6dzfv   image_2    "sh -c 'jupyter note…"   4 days ago       Up 4 days       0.0.0.0:xxxx->8888/tcp, :::xxxx->8888/tcp    IMAGE_NAME_2
```

Imagine that we have applied some changes in the Dockerfile of `IMAGE_NAME_1` and we want to make those changes to be applied. First we stop it:
```
docker stop IMAGE_NAME_1
```

or 

```
docker stop 1b4612355955
```

Then we remove it:

```
docker rm IMAGE_NAME_1
```

or 

```
docker rm 1b4612355955
```

Now, inside the folder where we have changed and the `.env` file is located we build the image:
```
docker-compose --env-file .env up -d --build
```

Now the changes should be applied. 

---

# Jupyterlab & Conda

A new version of Dockerfiles templates that include Conda are available from this [repository](https://github.com/vrodriguezf/dockerfiles) (credits to [vrodriguezf](https://github.com/vrodriguezf)). Follow the steps explained there. Here I will further explain how to:
+  create a new conda environment
+  add new jupyterlab extensions and re-build it

## Create a new conda environment

Once we have built and run our Docker container (as explained in the above repository), we can navigate through our Jupyterlab in the browser and create new conda environment in order to separate different projects packages requirements. 

To create a new conda environment we can follow the normal steps explained in the [conda documentation](https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#creating-an-environment-with-commands):

+ Creating an environment from commands
  + ``conda create --name myenv -y``

+ Creating an environment from .yml file
  + ``conda env create -f environment.yml``

An example of `environment.yml` file can be found in `Docker-Conda > compose > environment.yml`. 
You can check that the conda environment has been created using ``conda info --envs` which will show all the environments available (take into account that environments outside conda's default path will also be listed but without a name. [More info](https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#specifying-a-location-for-an-environment)). 

Now, you will want to work in a jupyter notebook using your new environment as the jupyter notebook's kernel. To do this, you will need to install `ipykernel` to the environment, and add the environment as a kernel:

````bash
$ conda activate myenv    
(myenv)$ conda install ipykernel
(myenv)$ ipython kernel install --user --name=<any_name_for_kernel_you_will_see_displayed>
(myenv)$ conda deactivate
````

Now reload the page (press `F5`) and you will be able to select `<any_name_for_kernel_you_will_see_displayed>` as kernel for the jupyter notebook. Here is an example of before and after setting the kernel available. 


![before](https://user-images.githubusercontent.com/56938752/154686097-f16b1b7b-5e9c-4b2a-a8a6-766bc8a9d3a8.PNG)

````bash
$ conda create --name myenv -y
$ conda activate myenv    
(myenv)$ conda install ipykernel
(myenv)$ ipython kernel install --user --name=example_env_name
(myenv)$ conda deactivate
````

![after](https://user-images.githubusercontent.com/56938752/154686114-e8ae998d-4870-47b4-a0ed-8fd56e8c5180.PNG)

## Add new jupyterlab extensions and re-build it

Even thought the `Docker-Conda` template already includes some extensions (e.g., themes, drawio, debugger, GPU dashboards), you might probably find some other extensions useful for you in Jupyterlab 3 in the market place. 

For example we will add a new theme extension: `quetz-theme` from mamba creators. First we find it in the marketplace and click on `Install`: 

![step_!](https://user-images.githubusercontent.com/56938752/154688314-635688ce-3806-46d6-9c87-f38d890f1bf4.PNG)


We probably see this message. 

![step_2](https://user-images.githubusercontent.com/56938752/154688355-52da93c1-2515-4b49-9d6c-49a5cec4c4ed.PNG)


We will need to rebuild jupyter lab for changes take place. Build jupyterlab from the browser is not possible as it is running on a docker container. Hence, we need to enter to the container shell and execute the build command. To do this, we have to go to our ssh terminal server (where we run the `docker-compose up -d --build` command) and enter to the bash terminal of the image like so:

``docker exec -it <CONTAINER-NAME> bash``

Now, we are in the shell of our container and we can run the following command:

``jupyter lab build --minimize=False``

That's it! We can now reload our Jupyterlab sesion in the browser and we will have succesfully added the new extension.

# VSCode

Another editor option is VSCode. To use this editor in our local machine but inside the container there are two main requirements:
- VSCode installed in our local machine
- Docker installed in our local machine
- Access to the remote server (i.e., user and password to connect from `ssh user@IP-remote-server`)
- A built image and its running container

The key point in this process is to set up VSCode to access to the remote server via SSH. For this purpose we will need an authorized user and a password to access this remote server. To check if you already accomplish this requirement try this command in your terminal:

```bash
ssh my-user-name@IP-remote-server
```

Once we check we can connect to the remote server through SSH, we will set up VSCode to access via SSH to the remote server. We will need several extensions from tha VSCode extension market:


![image](https://user-images.githubusercontent.com/56938752/151775514-a81216bd-bee3-4401-8ead-b7ba5a86c8d4.png)


Then, we will configurate the SSH connection to the remote server. In VSCode open the command palette (click `F1`), write ` Remote-SSH: Open Configuration File` in the search bar, select `.ssh/config` from the dropdown selection bar. This file will be open (see screenshot below). Add the following lines with your own information. From the lef sidebar, check that the `Remote Explorer` shows your custome remote server (the name introduced in first line). 

![image](https://user-images.githubusercontent.com/56938752/151777262-5187511b-f8fe-4595-878c-ebeae774adec.png)

One final step is nrequired before connecting to the remote server. We will now add the SSH settings conectivity to the VSCode settings. In VSCode open the command palette (click `F1`), write and select `Preferences: Open settings (JSON)` in the search bar. Add the following lines to the current settings: 

````
    "remote.SSH.showLoginTerminal": true,
    "remote.SSH.useLocalServer": false,
    "remote.SSH.connectTimeout": 30,
    "terminal.integrated.windowsEnableConpty": false,
    "remote.SSH.remotePlatform": {
        "custom-name-remote-server": "linux" # your remote server operating system. Use the same custom remote server name as in the previous step
    }
````

Finally we can connect to the remote server. Go to the `Remote Explorer` in the left sidebar, right click on your remote server and select `Connect to Host in New Window`. 

![imagen](https://user-images.githubusercontent.com/56938752/151825105-d1b3a3ac-6887-4d17-9115-763d1f88991a.png)


![image](https://user-images.githubusercontent.com/56938752/151779056-06911909-e7b9-456d-95e5-d3ac74481797.png)

A new VSCode window will open and ask for the user password. Write it down and click Enter. Congratulations! You are now using VSCode in your remote server. However, now we have to access to a container in order to have a private workspace. If we directly use the remote server as our workspace we can affect other users. Thus, docker container are quite handy in this kind of situations. We can check that we are now working with VSCode in a new environment (the remote server), if we go to the `Extensions` left sidebar. We will see `Local Installed` extensions and `SSH: XXXX-NAME-SERVER - INSTALLED`. We will add `Docker` extension to the remote server to build images, run containers and access to them. 

![image](https://user-images.githubusercontent.com/56938752/151780431-40e43036-3ce3-49b5-9896-a3fe3cf590d9.png)


Now we can go to the `Docker` left sidebar explorer and navigate through all the images available and containers in the server.  

![image](https://user-images.githubusercontent.com/56938752/151780676-b011613e-8ad0-44a1-9523-167946112030.png)


If we want to build and start a container we should use the same commands and requirements specify in the `JupterLab` previous section in the VSCode terminal (which is the remote server terminal). Once our container is running we just need to access to the container using VSCode. For that, go to the desired container, right click and select `Attach Visual Studio Code`. Select your container from the dropdown list. You will need to write down again your user's password.

![image](https://user-images.githubusercontent.com/56938752/151781991-9a81fbb3-53c5-43fc-ba99-cbfe842b8f6a.png)

![image](https://user-images.githubusercontent.com/56938752/151782306-ceba1a46-7bf3-4162-be29-06f03072ad97.png)


Congrats! Now you are working with VSCode inside your container. Now you can navigate through the files of your container and set your working directory from the `File > Open Folder ...` options inside VSCode and use VSCode as you will use it in your local machine (i.e, add extensions, install packages, etc.).



