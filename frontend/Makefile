moduleowner = github.com/lmnzr/
packagename = triviafrontend

define README
Welcome To Triviapp Application Makefile
By lmnzr (azuresky102@gmail.com)

If you are like me, you will be frustrated by how many times you use the up button to find that command line you use 
to build the application previously. The Makefile comes to the rescue. Now Building, Running, Dockerize, 
and Deploying the application is easier thanks to the make command.

In Order to run everything correctly,
- Make sure you have go and docker installed properly.
- The user have correct permission to write and delete file.
- Login docker to the image repository

Example
--Starting project--
make init

--Get dependencies--
make update

--Run the Application--
make run

--Cleanup Build Result--
make clean

--Dockerize the Application--
make docker

--Run the Dockerize Application--
make docker-run

--Dockerize then Push the Image to Image Registry--
make docker-push

endef
export README


# Build And Development
init:
	@ go mod init $(moduleowner)$(packagename)
	@ go mod vendor 
update:
	@ go mod vendor
clean:
	@ sudo rm -rf $(packagename).bin $(packagename).exe cover.txt cover.html cover.out build
run:
	@ go build -o ./build/$(packagename).bin $(moduleowner)$(packagename)/cmd/$(packagename)  && ./build/$(packagename).bin	  
docker: 
	@ docker build -t lmnzr/$(packagename):latest .
docker-push: 
	@ docker build -t lmnzr/$(packagename):latest . && docker push lmnzr/$(packagename):latest
docker-run: 
	@ docker run -p 8090:8090 -e BACKEND_URL=http://172.17.0.3:8080 lmnzr/$(packagename):latest
help:
	@ echo "$$README"