FROM vrodriguezf/jupyterlab-cuda:latest

# INSTALL NODEjs from NodeSource
RUN curl -s http://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -
RUN sh -c "echo deb http://deb.nodesource.com/node_12.x focal main > /etc/apt/sources.list.d/nodesource.list"
RUN apt-get update
RUN apt-get install -y nodejs

# INSTALL R
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends build-essential r-base r-cran-randomforest

# UPGRADE PIP
RUN pip3 install --upgrade pip

# INSTALL CUDNN8
RUN apt-get update && apt-get install -y --no-install-recommends \
    libcudnn8 fonts-powerline \
    && apt-mark hold libcudnn8 && \
    rm -rf /var/lib/apt/lists/*

# UPDATE JUPYTERLAB to 3.x (plotly visualization and pre-built debugger are now supported) ipkykernel>=6 is required
RUN pip3 install --upgrade jupyterlab jupyterlab-git nbdime aquirdturtle_collapsible_headings jupyterlab_widgets jupyterlab-quickopen ipykernel

# JUPYTERLAB additional extension for CPU, Memory, GPU usage and new themes
RUN pip3 install jupyterlab_nvdashboard jupyterlab-logout jupyterlab-system-monitor jupyterlab-topbar \
                 jupyterlab_theme_hale jupyterlab_theme_solarized_dark nbresuse \
                 jupyter-lsp jupyterlab-drawio jupyter-dash jupyterlab_code_formatter black isort jupyterlab_latex \
                 xeus-python theme-darcula jupyterlab_materialdarker lckr-jupyterlab-variableinspector

RUN jupyter labextension install jupyterlab-chart-editor


# Required for Dash 
RUN jupyter lab build 

    
# PYTHON PACKAGES with pip 
RUN pip3 install scikit-learn fastgpu nbdev pandas transformers tensorflow-addons \
     tensorflow torch pymongo torch emoji python-dotenv plotly rpy2

RUN echo 'install.packages("tidyverse")' > /tmp/packages.R && Rscript /tmp/packages.R

RUN apt update

RUN apt -y install zsh wget sudo nano

# Defining ARG variables passed from docker-compose
ARG UID
ARG GID
ARG USER

RUN echo ${UID}

RUN echo ${GID}

RUN echo ${USER}

RUN addgroup --gid $GID $USER 
RUN adduser --disabled-password --gecos '' --uid $UID --gid $GID $USER 

# Giving root permissions to $USER
RUN adduser $USER sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER $USER

WORKDIR /home/$USER/work

ENV SHELL=/bin/zsh
