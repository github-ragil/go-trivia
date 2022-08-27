frontendcount = 1
backendcount = 1
frontendhpa = false
backendhpa = false
namespace = default
frontendtype = NodePort
appname = lmnzr

define README
Welcome To Triviapp Helm Makefile
By lmnzr (azuresky102@gmail.com)

This makefile is intended to make installing, uninstalling, scale up, scale down, & test
Triviapp more easier and consistent.

- In Order to run everything correctly make sure you have kubectl & helm Installed
- The kubernetes cluster is up and running, you can try "kubectl get nodes" to find out

Command list
+ help       Sort of manual to help you proceed
+ install    Installing Triviapp using Helm Package Manager
+ upgrade    Upgrading Triviapp using Helm Package Manager (makesure application installed already)
+ plan       Plan installation and show the generated kubernetes configuration
+ uninstall  Uninstalling Triviapp using Helm Package Manager
+ list       List all application installed by Helm Package Manager
+ kube-list  List all active pod, deployment, replicaset, and service in kubernetes cluster
+ test       Test connection to frontend and backend application, Makesure application installed properly

Parameter list
~ namespace      Designated namespace where Helm install the application [default : default]
~ appname        Prefix Name for Triviapp [default : lmnzr]
~ frontendtype   Service type for frontend application (ClusterIP,NodePort,LoadBalancer) [default : NodePort]
~ frontendcount  Replication count for frontend application [default : 1]
~ backendcount   Replication count for backend application [default : 1]
~ frontendhpa    Enable Horizontal Pod Autoscaler for Frontend Pod. 
                 You can configure your own autoscaling trigger in values.yaml. 
				 By default it is not enabled. [default : false]
~ backendhpa     Enable Horizontal Pod Autoscaler for Backend Pod. 
                 You can configure your own autoscaling trigger in values.yaml. 
				 By default it is not enabled. [default : false]

Example
--Simple Installation--
make install

--Installation With LoadBalancer Type--
make install frontendtype=LoadBalancer

--Scale Up Application--
make upgrade frontendcount=3 backendcount=5

--Scale Down Application--
make upgrade frontendcount=1

--Simple Uninstall--
make uninstall

endef
export README

install:
	@ helm install $(appname) ./triviapp --set backend.replicaCount=$(backendcount) \
        --set frontend.replicaCount=$(frontendcount) --set frontend.service.type=$(frontendtype) \
		--set frontend.hpa.enabled=$(frontendhpa) --set backend.hpa.enabled=$(backendhpa) \
        --namespace $(namespace) || (echo "App Already Installed, Running Upgrade Instead" && make upgrade)
upgrade:
	@ helm upgrade $(appname) ./triviapp --set backend.replicaCount=$(backendcount) \
        --set frontend.replicaCount=$(frontendcount) --set frontend.service.type=$(frontendtype) \
		--set frontend.hpa.enabled=$(frontendhpa)  --set backend.hpa.enabled=$(backendhpa) \
        --namespace $(namespace)
plan:
	@ helm install --debug --dry-run $(appname) ./triviapp\
        --set backend.replicaCount=$(backendcount) --set frontend.replicaCount=$(frontendcount)\
		--set frontend.hpa.enabled=$(frontendhpa)  --set backend.hpa.enabled=$(backendhpa) \
        --set frontend.service.type=$(frontendtype) --namespace $(namespace)
uninstall:
	@ helm uninstall $(appname) --namespace $(namespace)
list:
	@ helm ls --namespace $(namespace)
kube-list:
	@ kubectl get all  --namespace $(namespace)
help:
	@ echo "$$README"
test:
	@ helm test $(appname) --namespace $(namespace)
