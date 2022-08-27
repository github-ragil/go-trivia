# Triviapp

**Is a web application that will give you fun trivia related to today's date. The Application consists of REST API backend and SSR frontend. Both applications are written using GoLang.**

## Infrastructure
The Helm chart will deploy 2 services: Backend service and Frontend service. The backend service have ClusterIP network and run on port 8080. Hence, it can only be accessed from inside the cluster. This is useful to protect our backend API from being exposed to the public. The frontend service can have ClusterIP, NodePort, & LoadBalancer Network. Though you are most likely want to expose the frontend to the public, you probably don't want to use ClusterIP for this one. I use NodePort for the default. The frontend application can call the backend by providing the application container with environment variable BACKEND_URL. Assuming both application run in the same namespace, by default I use the name of backend service for the BACKEND_URL value and let the cluster DNS to connect them. If you have any domain for the application you can enable nginx ingress, make sure you have nginx ingress controller installed in your cluster.

## Helm Chart

You can easily deploy the application to the Kubernetes cluster using Helm Package Manager. The helm chart is included in this repository. To make your life even easier I also add Makefile. Hence, you can use make command to install, uninstall, plan, test, and etc

### Makefile Manual

This makefile is intended to make installing, uninstalling, scale up, scale down, & test Triviapp more easier and consistent.

In Order to run everything correctly,

- Make sure that you have kubectl & helm Installed

- The kubernetes cluster is up and running, you can try "kubectl get nodes" to find out

#### Command List

- **help** -- Sort of manual to help you proceed

- **install** -- Installing Triviapp using Helm Package Manager

- **upgrade** -- Upgrading Triviapp using Helm Package Manager

- **plan** -- Plan installation and show the generated kubernetes configuration

- **uninstall** -- Uninstalling Triviapp using Helm Package Manager

- **list** -- List all application installed by Helm Package Manager

- **kube-list** -- List all active pod, deployment, replicaset, and service in kubernetes cluster

- **test** -- Test connection to frontend and backend application, to make sure application installed properly

#### Parameter List

- **namespace** -- Designated namespace where Helm install the application [default:default]

- **appname** -- Prefix Name for Triviapp [default:lmnzr]

- **frontendtype** -- Service type for frontend application (ClusterIP,NodePort,LoadBalancer) [default:NodePort]

- **frontendcount** -- Replication count for frontend application [default:1]

- **backendcount** -- Replication count for backend application [default:1]

- **frontendhpa** --  Enable Horizontal Pod Autoscaler for Frontend Pod. 
                      You can configure your own autoscaling trigger in values.yaml. 
				      By default it is not enabled. [default:false]

- **backendhpa** -- Enable Horizontal Pod Autoscaler for Backend Pod. 
                    You can configure your own autoscaling trigger in values.yaml. 
				    By default it is not enabled. [default:false]

#### Usage Example

Simple Installation

```
make install
```

Installation With LoadBalancer Type

```
make install frontendtype=LoadBalancer
```

Scale Up Application

```
make upgrade frontendcount=3 backendcount=5
```

Scale Down Application

```
make upgrade frontendcount=1
```

Uninstall

```
make uninstall
```

## Backend Application

[More Info Here](https://github.com/lmnzr/go-triviapp/tree/master/backend)

## FrontEnd Application

[More Info Here](https://github.com/lmnzr/go-triviapp/tree/master/frontend)
