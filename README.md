# SNES Classifier Overview

In the online class [Practical Deep Learning for Coders 2019](https://www.fast.ai/2019/01/24/course-v3/), we learned how to create a world-class image classifer model for the [Oxford-IIIT Pet Dataset](http://www.robots.ox.ac.uk/~vgg/data/pets/), which contains 37 different categories of pets.

I wondered if I could use the same techniques to create **a model that could examine a video game screenshot and determine which of ~600 Super Nintendo games it belonged to**.  Would 600 categories be too much?  Would transfer learning from ImageNet work on game screenshots which don't even exist in the real world?

It ended up working surprisingly well, with an accuracy of 94%.  This repository contains:
  * All of the scripts I used to collect the training data from youtube
  * The notebooks I used to create the model
  * My trained model
  * A web front-end
  * Dockerfiles for running the web front-end and inference using CPU
  * A systemd service definition for running the web from
  * Ansible role to clone this repository and set up the systemd service.


## Online Demo

Visit https://snes.matthewreishus.com


## To: Run The Web App
```
cd 04-web
docker-compose up
```
Then use a web browser to visit `localhost:8080`.  Warning, this will create 6-8 gigs of docker images, since it will create a pytorch installation used for inference.

### Bonus

In the `05-ansible` directory, there is an ansible role that automatically installs a service that keeps the webapp running.  If you don't want to use ansible, there is a systemd service definition in `05-ansible/roles/snes-classifier/files/docker-snes-classifier.service`.

## To: Download the data and create the model

Follow the directions in the `01-find-longplay-urls` and `02-create-screenshots` directories to build a library of about ~150 screenshots per SNES game.  This is done by downloading "longplay videos" from youtube and extracting screenshots from the videos.

Follow along with the jupyter notebook in `03-model-resnet50` to create and export the model.  There is no automated way to create the model, it is only done through the jupyter notebook.
