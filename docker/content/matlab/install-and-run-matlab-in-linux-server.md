---
title: 'Install and Run Matlab in Linux Server'
series: ["Matlab"]
draft: false
---

This tutorial details how to install and run [Matlab](https://www.mathworks.com/) on an air-gapped server, and how to compile Matlab code into a standalone application and run it

This documentation has been tested to work in Linux version R2022b and R2024b

## Installing Matlab on Linux in an Air Gapped Environment

This tutorial refers to a full matlab install with an IDE.

In the internet:

1. Download Matlab from the Mathworks website with the intended version with a user of someone who has access to the Matlab version (students have free access).
1. Run the download.
1. In `advanced options` choose `I want to download without installing`. Then choose Linux and the destination to download the installation.
1. Assuming we downloaded both windows and Linux install: In the installation folder, unzip the file `Matlab_<version>_glnxa64.zip` and overwrite the files in the existing folder. This will cause the installation to only work on Linux. If we want it to work on windows, we can unzip the file `Matlab_<version>_win64.zip` and overwrite the files in the existing folder.
1. Transfer the installation to the air gapped network.

In the air gapped network:

1. Move the installation to the server we want to install on
1. Run `sudo ./install` in the installation folder
1. Follow the directions on the screen that pops up
1. After the installation is completed, run the command `/usr/local/bin/Matlab` to run Matlab.

## Installing Matlab Runtime on a Linux Server in an Air Gapped Environment

This tutorial refers to the Matlab runtime which is used purely for running standalone Matlab applications.

In the internet:

1. Download Matlab runtime from the Mathworks website (no account needed): [https://www.mathworks.com/products/compiler/matlab-runtime.html](https://www.mathworks.com/products/compiler/matlab-runtime.html)
1. Transfer the installation to the air gapped network.

In the air gapped network:

1. Unzip the folder
1. Install with the command `sudo ./install` and follow the directions in the screen that pops up
1. Add to the environment variables the following variable:

    ```sh
    LD_LIBRARY_PATH=/usr/local/MATLAB/MATLAB_Runtime/<matlab_version>/runtime/glnxa64:/usr/local/MATLAB/MATLAB_Runtime/<matlab_version>/bin/glnxa64:/usr/local/MATLAB/MATLAB_Runtime/<matlab_version>/sys/os/glnxa64:/usr/local/MATLAB/MATLAB_Runtime/<matlab_version>/extern/bin/glnxa64:/usr/local/MATLAB/MATLAB_Runtime/<matlab_version>/sys/opengl/lib/glnxa64
    ```

## Compiling Matlab Code to a Standalone File

We can compile Matlab code to a standalone executable that doesn't require a license to run.

Compiling for a specific Matlab version for a specific operating system requires running the compile on the specific Matlab version on the specific operating system.

```matlab
mcc('-m', '<main-file>', '-C', '-a', '<files-to-add>', '-d', '<output-directory>', '-o', "<output-file-name>")
```

- **main-file:** file that will be executed on program run
- **files-to-add:** files that will also be compiled into standalone application. Can be relative (`.` to include everything in directory)
- **output-directory:** directory that standalone application will be created in
- **output-file-name:** - name of the file of the standalone application

The executable will be created with additional files in the folder. These files are important to running the executable, if they are not in the same folder, the file won't run.

## Running a Matlab Standalone File

To run the executable file, we will use the following command on a server which has Matlab runtime installed on it:

```sh
<path-to-executable-file> [optional-arguments-set-by-compiled-matlab-script]
```

On Linux there will be an additional file called `run_<standalone_application_name>.sh`. It is preferred to use it, but we can call the executable file directly if the additional file doesn't work.

It is imperative to set the environment variables as specified in the previous section.
