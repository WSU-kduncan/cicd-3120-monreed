## Part 1 - Dockerize it 
### Run Project Locally
1. Automatically able to use through `MobaXterm` after Windows download ...

    > ![image](https://user-images.githubusercontent.com/97551273/201990740-d816f3d9-dabe-4630-909a-80842ccf9d90.png)

2. `vim cicd-3120-monreed/DockerFile` > & append contents ...

    ```
    FROM httpd:2.4
    COPY ./website/ /usr/local/apache2/htdocs/
    ```
3. While in `cicd-3120-monreed/` run:
    * `docker build -t webserver .` to build container image from DockerFile, where ...
    
        * `-t` tags the image "webserver" 
    * `docker run -d --name httpd -p 80:80 webserver` to run container, where ...
    
        * `-d` runs in detached mode
        * `-p` specifies port to bind "80:80"
        * `--name` specifies container name "httpd"
        
4. Open browser and visit `localhost:80` to view homepage up and running.


## Part 2 - GitHub Actions and Dockerhub

1. #### To create a `public repository` in Dockerhub ... 

    > ![image](https://user-images.githubusercontent.com/97551273/202257389-1cbc0e49-3d7c-47b9-97ee-c4743fe3ab3f.png)

    > ![image](https://user-images.githubusercontent.com/97551273/202257476-2be0ecd3-84c8-43e1-8292-2d22bd55eaf6.png)
    
    > ![image](https://user-images.githubusercontent.com/97551273/202257839-9ce40170-d6b7-4770-9618-2e3fee925ce9.png)

    > ![image](https://user-images.githubusercontent.com/97551273/202257558-1c2d849f-2648-4af5-b1b5-6cb42549da62.png)

    > ![image](https://user-images.githubusercontent.com/97551273/202257616-bff818d2-1611-4864-8be1-e5ab456d8de2.png)
   
 ---

2. #### How to `authenticate` with Dockerhub via CLI using Dockerhub credentials ...

    > ![image](https://user-images.githubusercontent.com/97551273/202258168-32390020-c871-414f-882b-251bd39ff6c2.png)

    > ![image](https://user-images.githubusercontent.com/97551273/202258268-bf93758b-ef30-4336-9eb4-a1011b14e4a7.png)

  * Copy generated token ... 

  * On the command line, `docker login -u momankhoney` ...
      * Provide username & paste generated token as "password" when prompted    
  * Personally, to retain a level of security but reduce risk, I would recommend **Dockerhub** supporting some form of `2FA` so that the access token is not required to be entered each and every time the user wants to login on the CLI.  

---

3. #### How to push a `container` to Dockerhub ...
* `docker tag webserver:latest momankhoney/my-first-repo:latest` where **webserver** is my container image & **my-first-repo** is my public Dockerhub repository

* `docker push momankhoney/my-first-repo:latest` to push the latest container image over to my repository on **Dockerhub**

---

4. #### Configuring GitHub Secrets ... While in target repository: 

    > ![image](https://user-images.githubusercontent.com/97551273/202266191-a1459e09-7718-4dec-a60b-946b26012f16.png)

    > ![image](https://user-images.githubusercontent.com/97551273/202266461-8def93ec-4e15-44c6-8bf1-8d084404d839.png)

    > ![image](https://user-images.githubusercontent.com/97551273/202266628-8f60cd87-a6c2-4bfe-ae98-cd14749425c8.png)

  * Establish secrets `DOCKER_USERNAME` and `DOCKER_TOKEN` with respective contents. 

---

5. #### Behavior of GitHub Workflow
* *What it does ...*
    * This workflow builds and pushes images to Dockerhub, while authenticating with your Dockerhub username & Dockerhub access token.
    
    *  First, a `checkout` (v3) is carried out.  
    
    *  Then, optionally, I chose to have `ls` run to list the contents.
    
    *  Next, `login-action` (v2) is ran to log user into Dockerhub through the use of variables/secrets `DOCKER_USERNAME` & `DOCKER_TOKEN`.

    *  Then, Docker Buildx is configured using `setup-buildx-action` (v2). 

    *  Next, build and push actions are carried out using `build-push-action` (v3). This is done via the use of the content within file `./Dockerfile`, setting variable `push` to true, and tagging through the use of variables `DOCKER_USERNAME` and `/repo-name-here:latest`. 
* *When it does it ...*
    * `on: push:` meaning, this workflow is triggered whenever a `git push` is ran for this repository. 
    
* *Custom variables include ...* 

    * For this template to be used by someone else, variable names `DOCKER_USERNAME` and `DOCKER_TOKEN` may have to be adjusted to match what is in GitHub.
    * Additionally, the repository tag included in the very last line of the workflow file will need to be adjusted to match the individual user's repository. 

## Part 3 - Deployment 
### Description of Container Restart Script
* `docker stop site` - To end the running process of our current image, **site**.

* `docker rm site` - To safely remove the container image.

* `docker pull momankhoney/my-first-repo:latest` - To pull the newest/latest version of the target container from the target repository. 

* `docker run -d --restart unless-stopped -p 8080:80 --name site momankhoney/my-first-repo` - To run the latest version of the container on port 80 in detached mode with name "site". Flag `--restart` allows it to keep running while instance is active and `unless-stopped` tells it to keep going unless we actually tell it to "docker stop". 

    * **Optional:** add `docker ps -a` to output processes as they run to see what is happening when upon script execution. 
    
 * Notes // `refresh.sh` requires `chmod u+x` and will be executed like so: `sudo ./refresh.sh`
 
 ---

 ### Configuration of Webhook 
 
 1. **Install Go** 
* `wget https://dl.google.com/go/go1.19.3.linux-amd64.tar.gz` to download the Go installer file 
 
* `sudo tar -C /usr/local -xzf go1.19.3.linux-amd64.tar.gz` to extract what you just downloaded into /usr/local & create a fresh Go tree in /usr/local/go
 
* `export PATH=$PATH:/usr/local/go/bin` to add /usr/local/go/bin to the PATH environment variable

    * `go version` to confirm successful installation & verify version 
   
2. **Install Webhooks using Go**
* `go install github.com/adnanh/webhook@latest` to install the latest webhook version 
* `vim hooks.json` and append:
 ```
 [
  {
    "id": "redeploy-webhook",
    "execute-command": "/var/scripts/redeploy.sh",
    "command-working-directory": "/var/webhook"
  }
]
```
* `/home/ubuntu/go/bin/webhook -hooks /home/ubuntu/hooks.json -verbose` to run webhook
3. **On Dockerhub ...**
> ![image](https://user-images.githubusercontent.com/97551273/204439358-cc1e62af-7ecb-48ed-9afa-dcf08db0a268.png)

> ![image](https://user-images.githubusercontent.com/97551273/204439415-31b84b57-f82f-4915-bcda-3aa4ecd77fe9.png)

> ![image](https://user-images.githubusercontent.com/97551273/204439424-20a0f940-e2cc-4545-98d8-cceef0f2a3f2.png)

> ![image](https://user-images.githubusercontent.com/97551273/204439444-f29ae416-87b5-4af9-93ad-09faf9c15041.png)

> ![image](https://user-images.githubusercontent.com/97551273/204439530-af718a31-38fb-41e6-86a7-4eb23cce53d5.png)


#### On a separate terminal of the same instance, run:

* `sudo lsof | grep LISTEN` results below: 
```
sshd        659                             root    3u     IPv4              24017      0t0        TCP *:ssh (LISTEN)
sshd        659                             root    4u     IPv6              24028      0t0        TCP *:ssh (LISTEN)
systemd-r  5581                  systemd-resolve   13u     IPv4              43871      0t0        TCP localhost:domain (LISTEN)
webhook   20536                           ubuntu    6u     IPv6              66753      0t0        TCP *:9000 (LISTEN)
webhook   20536 20537 webhook             ubuntu    6u     IPv6              66753      0t0        TCP *:9000 (LISTEN)
webhook   20536 20538 webhook             ubuntu    6u     IPv6              66753      0t0        TCP *:9000 (LISTEN)
webhook   20536 20539 webhook             ubuntu    6u     IPv6              66753      0t0        TCP *:9000 (LISTEN)
webhook   20536 20540 webhook             ubuntu    6u     IPv6              66753      0t0        TCP *:9000 (LISTEN)
webhook   20536 20541 webhook             ubuntu    6u     IPv6              66753      0t0        TCP *:9000 (LISTEN)
webhook   20536 20542 webhook             ubuntu    6u     IPv6              66753      0t0        TCP *:9000 (LISTEN)
```
* `curl 34.194.112.9:9000/hooks/honey` to test if the webhook will catch the connection 

---

#### Create Systemd Service

* `cd /etc/systemd/system`
* `sudo vim webhook.service` & append:
```
[Unit]
Description=Webhook Service in Go 
After=multi-user.target 

[Service]
ExecStart=/home/ubuntu/go/bin/webhook -hooks /home/ubuntu/hooks.json
Type=simple

[Install]
WantedBy=multi-user.target                                                                                                
```
* `sudo systemctl daemon-reload` to refresh changes
* `sudo systemctl enable webhook.service` to enable your webhook uptime service 
* `systemctl status webhook.service` to check on the status of your service and see if it is active or not
* `sudo systemctl start webhook.service` to start your service 
