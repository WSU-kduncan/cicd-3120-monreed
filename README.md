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


## Part 2 - GitHub Actions and DockerHub

