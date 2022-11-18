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
