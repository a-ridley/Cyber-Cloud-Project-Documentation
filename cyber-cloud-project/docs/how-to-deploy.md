---
id: how-to-deploy
title: How to Deploy the Documentation Site
---

Unfortunately, it's a manual process at the moment...

1. Make any of your changes locally using a handy-dandy IDE (VSCode)
2. Ensure none of your changes have broken the site and push your changes to the github repository.
3. Next, SSH into the logging node and go to the `/home/cyber-cloud-project-documentation` directory and remove `/build` folder. This ensures we don't have any old files left over when we copy over the new build folder.
4. Go to your VS Code terminal and run `npm run build` *(this will create a build folder in your working directory)*
5. Scp the `/build` folder to the logging node:

```bash
scp -P 2212 -r build/ root@10.40.216.102:/home/cyber-cloud-project-documentation/build
```

**Note: If any changes were made to the `docker-compose.yml` file or `dockerfile` make sure to scp those over as well.**

```bash
scp -P 2212 docker-compose.yml root@10.40.216.102:/home/cyber-cloud-project-documentation
```

## Building the new docker image/Stopping the Docker Container 
After the files have been copied over to the logging node you will need to stop the docker container. Then you will build the new image and start it up again.
Ensure you are in the directory that has the docker-compose.yml file: 

`/home/cyber-cloud-project-documentation` before running any of the following commands.


In order to stop the docker container run the following command `docker-compose down` on the logging node. 
Then run `docker-compose up --build -d` to build the new image and start it back up.


