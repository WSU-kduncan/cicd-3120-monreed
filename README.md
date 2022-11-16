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

1. To create a `public repository` in DockerHub ... 

    > ![image](https://user-images.githubusercontent.com/97551273/202257389-1cbc0e49-3d7c-47b9-97ee-c4743fe3ab3f.png)

    > ![image](https://user-images.githubusercontent.com/97551273/202257476-2be0ecd3-84c8-43e1-8292-2d22bd55eaf6.png)
    
    > ![image](https://user-images.githubusercontent.com/97551273/202257839-9ce40170-d6b7-4770-9618-2e3fee925ce9.png)

    > ![image](https://user-images.githubusercontent.com/97551273/202257558-1c2d849f-2648-4af5-b1b5-6cb42549da62.png)

    > ![image](https://user-images.githubusercontent.com/97551273/202257616-bff818d2-1611-4864-8be1-e5ab456d8de2.png)
