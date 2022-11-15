## Part 1 - Dockerize it 
### Run Project Locally
1. Automatically able to use through MobaXterm after Windows download ...

    > ![image](https://user-images.githubusercontent.com/97551273/201990740-d816f3d9-dabe-4630-909a-80842ccf9d90.png)

2. `vim DockerFile` > & append contents ...

    ```
    FROM ubuntu
    RUN apt update
    RUN apt install -y apache2
    RUN apt install -y apache2-utils
    RUN apt clean
    EXPOSE 80
    CMD [“apache2ctl”, “-D”, “FOREGROUND”]
    ```
 
3. `docker run --name mywebserver -d -p 80:80 webserver-image` to run the container image, where ...
    - `-d` runs in detached mode
    - `-p` to specify which port we want available / to bind to
    
4. 
