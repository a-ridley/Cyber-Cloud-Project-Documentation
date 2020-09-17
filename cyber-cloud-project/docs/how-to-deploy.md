---
id: how-to-deploy
title: How to Deploy the Documenation Site
---

Unfortnately, it's a manual process at the moment...

* Make any of your changes locally using a handy-dandy IDE.
* Ensure none of your changes have broken the site and push your changes to the github repository.
* Next, run `npm run build` (this will create a build folder)
* Secure copy the `/build` folder to the logging node (Remote ssh address: 10.40.216.102:2212)

Note: If any changes were made to the `docker-compose.yml` file or `dockerfile` make sure to scp those over as well.

## Starting/Stopping the Docker Container 
After the files have been copied over to the logging node run the following command `docker-compose down`on the logging node in order to stop the docker container. And then run `docker-compose up -d` to start it back up.


