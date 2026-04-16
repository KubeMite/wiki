---
title: 'Run Matlab in Docker'
series: ["Matlab"]
draft: false
---

Docker can be used to build and run Matlab code.\
We can use the official Matlab Docker image to both use an IDE for working on Matlab code, compiling Matlab Code into a standalone application, and for running a standalone application

## Matlab With Desktop

This tutorial refers to running Matlab in a Docker image with a virtual desktop inside of the Docker image that is remotely accessible with VNC or a browser.\
This way of running Matlab provides both a desktop environment and a full IDE.

We can run Matlab with this command:

```sh
docker run --init -it --rm -p 5901:5901 -p 6080:6080 --shm-size=512M mathworks/matlab:<matlab-version> -vnc
```

Then we can access Matlab using VNC or the browser.

### VNC

We can connect to the Matlab Docker image using any VNC client (for example, [MobaXTerm](https://mobaxterm.mobatek.net/)). The session will access the server running the docker container in port 5901. The password will be `Matlab`.

### Browser

We will access the Matlab Docker image in the address `https://<server-ip-or-hostname>:6080`

- **server-ip-or-hostname:** the IP or hostname of the server running the Matlab Docker image.

## Matlab Without Desktop

This tutorial refers to running Matlab in a Docker image **without** a virtual desktop inside of the Docker image.\
This way of running Matlab only provides a full IDE, and is accessible **only** via a browser.

```sh
docker run --init -it --rm -p 8080:8080 --shm-size=512M mathworks/matlab:<matlab-version> -browser
```

We will access the Matlab Docker image in the address `https://<server-ip-or-hostname>:8080`

- **server-ip-or-hostname:** the IP or hostname of the server running the Matlab Docker image.

## Using a License Server

We can pass the environment variable `MLM_LICENSE_FILE` with the value `<license_server_port>@<license_server_address>` to the docker container in order to use a license server.

Matlab with desktop:

```sh
docker run -e MLM_LICENSE_FILE=<license_server_port>@<license_server_address> --init -it --rm -p 5901:5901 -p 6080:6080 --shm-size=512M mathworks/matlab:<matlab-version> -vnc
```

Matlab without desktop:

```sh
docker run -e MLM_LICENSE_FILE=<license_server_port>@<license_server_address> --init -it --rm -p 8080:8080 --shm-size=512M mathworks/matlab:<matlab-version> -browser
```

Official Matlab containers will run with the user **Matlab**. This is the user that needs to be allocated a license in the license server.

Each container will take 1 license even if multiple containers are running on the same server because the hostname of each container is different and each license is unique to a username and hostname.

## Running Multiple Containers On the Same Server

In order to run multiple Matlab containers on the same server, we will need to make sure to keep the ports unique for each container.
For example, if we want to run 2 containers on the same server, we will run the first using the command:

```sh
docker run -e MLM_LICENSE_FILE=<license_server_port>@<license_server_address> --init -it --rm -p 60000:5901 -p 60001:6080 --shm-size=512M mathworks/matlab:<matlab-version> -vnc
```

Then the second using the command:

```sh
docker run -e MLM_LICENSE_FILE=<license_server_port>@<license_server_address> --init -it --rm -p 60002:5901 -p 60003:6080 --shm-size=512M mathworks/matlab:<matlab-version> -vnc
```

Then we will access the first container using the address `https://<server-ip-or-hostname>:60000` and the seconds using the address `https://<server-ip-or-hostname>:60002`.

## Compiling Matlab Code Directly to a Docker Image in an Air Gapped Environment

This tutorial is relevant to Matlab versions R2022b and forward, since before this version there wasn't a command to compile a standalone application into a Docker image.

On the internet:

1. Run in Matlab the command `compiler.runtime.createInstallerDockerImage(<path-to-runtime-zip-files>)`
1. A couple of images were download to and created on the server.\
   Move the following images to the air gapped environment:

    ```sh
    # For example: containers.mathworks.com/matlab-runtime-utils/matlab-runtime-installer:r2022b-update-5
    containers.mathworks.com/matlab-runtime-utils/matlab-runtime-installer:<matlab-version>-update-<update-number>
    ```

    ```sh
    # For example: matlabruntimebase/r2022b/release/update5:latest
    matlabruntimebase/<matlab-version>/release/update<update-number>:latest
    ```

In the air gapped environment:

1. Install Docker, Matlab and Matlab Runtime (Matlab and Matlab runtime must be in the same version) on a Linux server.
1. Ensure that we have the following images on the machine (Matlab uses it to build the docker images):

    ```sh
    # For example: containers.mathworks.com/matlab-runtime-utils/matlab-runtime-installer:r2022b-update-5
    containers.mathworks.com/matlab-runtime-utils/matlab-runtime-installer:<matlab-version>-update-<update-number>
    ```

    ```sh
    # For example: matlabruntimebase/r2022b/release/update5:latest
    matlabruntimebase/<matlab-version>/release/update<update-number>:latest
    ```

1. Run the following code in Matlab:

    ```matlab
    % Compile to standalone application
    res = compiler.build.standaloneApplication('<file-to-run-on-container-start>', 'AdditionalFiles', '<additional-files>')

    % Docker compile options
    opts = compiler.package.DockerOptions(res, 'Imagename', '<image-name>')

    % Create docker image from standalone application with given options
    compiler.package.docker(res, Options, opts)
    ```

    - **file-to-run-on-container-start:** - Path to file that will run when the container starts. Arguments to the container will be passed as arguments to this file.
    - **additional-files:** - path (or a string array of paths) to additional files or folders that will be compiled into the docker image. We can pass `.` to specify all of the files and folders in the directory we are currently in (useful for compiling repositories).
    - **image-name:** - The docker image name that the Matlab code will be compiled to.

## Running Matlab with GPU in Docker

This tutorial is for compiling Matlab code to a Docker image with GPU support:

This documentation is only relevant for Matlab from version R2024b.

1. We first compile our code to an executable file:

    ```matlab
    compiler.build.standaloneApplication('<main-file>', 'additionalFiles', '<additional-files>', 'ExecutableName', 'app')
    ```

    - `main-file` - Path to file that will run when the container starts. Arguments to the container will be passed as arguments to this file.
    - `additional-files` - path (or a string array of paths) to additional files or folders that will be compiled into the docker image. We can pass a `.` to specify all of the files and folders in the directory we are currently in (useful for compiling repositories).
    - The above command will output all of the files specified as an executable file in the local folder.

1. Delete all of the other files from the folder other than the executable

1. Create the following Dockerfile in the folder:

    ```Dockerfile
    FROM containers.mathworks.com/matlab-runtime:<matlab-version>-full

    ENV LD_LIBRARY_PATH /opt/matlabruntime/<matlab-version>/runtime/glnxa64:/opt/matlabruntime/<matlab-version>/bin/glnxa64:/opt/matlabruntime/<matlab-version>/sys/os/glnxa64:/opt/matlabruntime/<matlab-version>/extern/bin/glnxa64
    ENV AGREE_TO_MATLAB_RUNTIME_LICENSE yes

    WORKDIR /app

    COPY . .

    ENTRYPOINT ["/app/app"]
    ```

1. Build the image:

    ```sh
    docker build . -t <image-name-and-tag>
    ```

1. Push the image:

    ```sh
    docker push <image-name-and-tag>
    ```

### Notes

- We can use the following command in Matlab to check if our Matlab can run on the GPU we are giving it:

    ```matlab
    canUseGPU
    ```

- We cab use the following command in Matlab to print all of the GPUs that are available to us:

    ```matlab
    gpuDeviceTable
    ```

- It is important to note the compatibility between Matlab versions to the GPU architecture version of the GPU we are giving Matlab.\
  We can use the [following link](https://www.mathworks.com/help/releases/R2024b/parallel-computing/gpu-computing-requirements.html) to see which GPU architecture version our Matlab version supports, and the [following link](https://en.wikipedia.org/wiki/List_of_Nvidia_graphics_processing_units) to see the GPU architecture of a GPU type.
