# Triviapp

**Is a web application that will give you fun trivia related to today's date. The Application consists of REST API backend and SSR frontend. Both applications are written using GoLang.**

## Frontend Application

The frontend application makes a call to the backend application and then renders the view to be served to the client. 

### Makefile Manual

If you are like me, you will be frustrated by how many times you use the up button to find that command line you use to build the application previously. The Makefile comes to the rescue. Now Building, Running, Dockerize, and Deploying the application is easier thanks to the make command.

In Order to run everything correctly,

- Make sure you have go and docker installed properly.

- The user have correct permission to write and delete file.

- Login docker to the image repository

#### Usage Example

Starting project

```
make init
```

Get dependencies

```
make update
```

Run the Application

```
make run
```

Cleanup Build Result

```
make clean
```

Dockerize the Application

```
make docker
```

Run the Dockerize Application

```
make docker-run
```

Dockerize then Push the Image to Image Registry

```
make docker-push
```