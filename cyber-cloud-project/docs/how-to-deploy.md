---
id: how-to-deploy
title: How to Deploy the Documentation Site
---

Unfortunately, it's a manual process at the moment...

1. Make any of your changes locally using an IDE (VSCode). See your changes by running `npm run start` on the vs-code terminal. A web browser should automatically open saying `localhost:port#`
2. Ensure none of your changes have broken the site by running `npm run start,` and ensure it compiles successfully and you can see your changes on the site.
3. Go to your VS Code terminal and run `npm run build` *(this will create a build folder in your working directory)*
4. If it built successfully, push your local changes to the github repository.
5. Next, SSH into the logging node and go to the `/home/cyber-cloud-project-documentation` directory and remove `/build` folder. This ensures we don't have any old files left over when we copy over the new build folder.
6. Open a new terminal on your personal laptop and navigate to your working directory and then Scp the `/build` folder to the logging node:

```bash
scp -P 2212 -r build/ root@10.40.216.102:/home/cyber-cloud-project-documentation/build
```

:::important

**If any changes were made to the `docker-compose.yml` file or `dockerfile` make sure to scp those over as well.**
:::

```bash
scp -P 2212 docker-compose.yml root@10.40.216.102:/home/cyber-cloud-project-documentation
```

## Building the new docker image/Stopping the Docker Container 
After the files have been copied over to the logging node you will need to stop the docker container. Then you will build the new image and start it up again.
Ensure you are in the directory that has the docker-compose.yml file: 

`/home/cyber-cloud-project-documentation` before running any of the following commands.


In order to stop the docker container run the following command `docker-compose down` on the logging node. 
Then run `docker-compose up --build -d` to build the new image and start it back up.


