---
id: how-to-deploy
title: How to Deploy the Documenation Site
---

Unfortnately, it's a manual process at the moment...

* Make any of your changes locally using a handy-dandy IDE (VSCode)
* Ensure none of your changes have broken the site and push your changes to the github repository.
* Next SSH into the logging node and go to the `/home/cyber-cloud-project-documentation` directory and remove `/build` folder. This ensures we don't have any old files left over when we copy over the new build folder.
* Go to your VS Code terminal and run `npm run build` *(this will create a build folder)*
* Scp the `/build` folder to the logging node. `scp -P 2212 -r build/ root@10.40.216.102:/home/cyber-cloud-project-documentation/build`

**Note: If any changes were made to the `docker-compose.yml` file or `dockerfile` make sure to scp those over as well.**

## Starting/Stopping the Docker Container 
After the files have been copied over to the logging node run the following command `docker-compose down`on the logging node in order to stop the docker container. And then run `docker-compose up -d` to start it back up.


