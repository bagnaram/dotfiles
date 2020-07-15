# Dotfiles

![Screenshot of my desktop](https://bagnaram.github.io/img/desktop.png) 

Dotfiles is a central location that you can store all configuration for most
software that supports configuration in the home directory. Thi

# General Requirements

The following software packages must be installed:

* git
* make

# Installation

1. First clone this reporitory.

     ```shell
     git clone https://github.com/bagnaram/dotfiles.git
     ```
     
2. Enter this directory and pull each of the sub-modules.
 
     ```shell
     git submodule update --recursive --remote
     ```
     
3. You can either install all of the modules specified in this dotfiles repo.
    It will create symlinks to all the configuration files within the dotfiles

     ```shell
     make all
     ```

4. You can also specify individual dotfiles with

     ```shell
     make mutt
     make vim
     make ...
     ```

**To customize:**

Simply modify the files within the dotfiles directory
