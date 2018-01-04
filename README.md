## Dockerization of a whole Linux server within one single container

The server to be Dockerized is an Ubuntu 16.04 server dedicated to web scraping with basically the following applications:

* Ubuntu 16.04
* Nginx
* Postgresql 9.3
* Python/Django
* Python virtualenvs
* Gunicorn
* Celery
* RabbitMQ
* Scrapy/Scrapyd

More information about why I had to do that and the strategy behind it [in the blog post](https://juliensalinas.com/en/dockerize-whole-linux-server/).