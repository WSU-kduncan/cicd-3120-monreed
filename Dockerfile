FROM httpd:2.4
COPY ./website/ /usr/local/apache2/htdocs/ 

#Website folder includes index.html containing inline CSS & Images folder. 
