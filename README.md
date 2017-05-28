# Docker Image for FastSolve
This Docker image provides the development environment for FastSolve with Ubuntu 16.04 environment. It runs the lightweight LXDE Windows Manager, with Octave 4.0.2, Python 3.5.2  (with NumPy, SciPy, Pandas and Spyder), Jupyter Notebook and Atom preinstalled. The X Windows will display in your web browser in full-screen mode. You can use this Docker image on 64-bit Linux, Mac or Windows. It allows you to use the same programming environment regardless which OS you are running on your laptop or desktop.

[![Build Status](https://travis-ci.org/fastsolve/docker-desktop.svg)](https://travis-ci.org/fastsolve/docker-desktop) [![](https://images.microbadger.com/badges/image/fastsolve/desktop.svg)](https://microbadger.com/images/fastsolve/desktop)

## Preparation
Before you start, you need to first install Python and Docker on your computer by following the steps below.

### Installing Python
If you use Linux or Mac, Python is most likely already installed on your computer, so you can skip this step.

If you use Windows, you need to install Python if you have not yet done so. The easiest way is to install `Miniconda`, which you can download at https://repo.continuum.io/miniconda/Miniconda3-latest-Windows-x86_64.exe. You can use the default options during installation.

### Installing Docker
Download the Docker Community Edition for free at https://www.docker.com/community-edition#/download and then run the installer. Note that you need administrator's privilege to install Docker. After installation, make sure you launch Docker before proceeding to the next step.

**Notes for Windows Users**
1. Docker only supports 64-bit Windows 10 Pro or higher. If you have Windows 8 or Windows 10 Home, you need to upgrade your Windows operating system before installing Docker. Stony Brook students can get Windows 10 Education free of charge at https://stonybrook.onthehub.com. Note that the older [Docker Toolbox](https://www.docker.com/products/docker-toolbox) supports older versions of Windows, but it should not be used.
2. When you use Docker for the first time, you must change its settings to make the C drive shared. To do this, right-click the Docker icon in the system tray, and then click on `Settings...`. Go to `Shared Drives` tab and check the C drive.

## Running the Docker Image

### Running the Docker Image on Windows
To run the docker image, start `Windows PowerShell` on Windows. Using the `cd` command to change to the working directory where you will store your codes and data. Then run the following two commands:
```
curl https://raw.githubusercontent.com/compdatasci/docker-desktop/fastsolve/fastsolve_desktop.py -outfile fastsolve_desktop.py
python fastsolve_desktop.py -p
```
This will download and run the Docker image and then launch your default web browser to show the desktop environment. The `-p` option above is optional, and it instructs the Python script to pull and update the image to the latest version.

### Running the Docker Image on Linux or Mac
To run the docker image, start a terminal. Using the `cd` command to change to the working directory where you will store your codes and data, and then run the two commands:
```
curl -s -O https://raw.githubusercontent.com/compdatasci/docker-desktop/fastsolve/fastsolve_desktop.py
python fastsolve_desktop.py -p
```
This will download and run the Docker image and then launch your default web browser to show the desktop environment. The `-p` option above is optional, and it instructs the Python script to pull and update the image to the latest version.

### Running the Docker Image as Jupyter-Notebook Server
Besides using the Docker Image as an X-Windows desktop environment, you can also use it as a Jupyter-Notebook server with the
default web browser on your computer. Simply replace `fastsolve_desktop.py` with `fastsolve_jupyter.py` in the preceding commands. That is, on Windows run the commands
```
curl https://raw.githubusercontent.com/compdatasci/docker-desktop/fastsolve/fastsolve_jupyter.py -outfile fastsolve_jupyter.py
python fastsolve_jupyter.py -p
```
or on Linux and Mac run the commands
```
curl -s -O https://raw.githubusercontent.com/compdatasci/docker-desktop/fastsolve/fastsolve_jupyter.py
python fastsolve_jupyter.py -p
```
in the PowerShell or terminal prompt, in the directory where your Jupyter notebooks are stored.

### Running the Docker Image Offline
After you have download the Docker image using the `curl` and `python` commands above, you can run the image offline without internet connection using the following command:
```
python fastsolve_desktop.py
```
or
```
python fastsolve_jupyter.py
```
in the directory where you ran the `curl` command above.

### Stopping the Docker Image
To stop the Docker image, press Ctrl-C twice in the terminal (or Windows PowerShell on Windows) on your host computer where you started the Docker image, and close the tab for the desktop in your web browser.

## Entering Full-Screen Mode
After starting the Docker image, you can change your web browser to full-screen mode so that the desktop environment would occupy the whole screen.

On Windows, you are recommended to use `Microsoft Edge` for proper display in full-screen mode. You can toggle the full-screen mode by pressing Win+Shift+Enter (hold down the Windows and Shift keys, and press Enter). On Mac, you can use `Safari` or `Google Chrome`, for which you can toggle the full-screen mode by pressing Ctrl-Cmd-f (hold down Ctrl and Cmd keys and press f). On Linux, you are recommended to use `Firefox`, for which you can toggle the full-screen mode using the F11 (or Fn-F11) key.

If your default browser is different from the above, you can manually copy and paste the URL into these browsers.

## Tips and Tricks
1. When using the Docker image, only the files under `$HOME/shared` and `$HOME/.config` are persistent. The former maps to the working directory on your host where you started the docker image, and the latter contains the configuration files of the desktop environment. Any change to the files in other directories will be lost when you stop the Docker image. Make sure you save all your source codes in the `$HOME/shared`.
2. By default, Docker uses two CPU cores and 2GB of memory for its images. This is sufficient for doing homework for this class. If you want to run large jobs, go to the `Advanced` tab in `Settings` (or `Preferences` for Mac) and increase the amount of memory dedicated to Docker.
3. You can copy and paste between the host and the Docker image through the `Clipboard` box in the left toolbar, which is synced automatically with the clipboard of the Docker image. To copy from the Docker image to the host, first select the text in the Docker image, and then go to the `Clipboard` box to copy. To copy from host to the Docker image, first paste the text into the `Clipboard` box, and then paste the text in the Docker image.