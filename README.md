Kubernetes Playground
=====================

Preparation
-----------

source load-bash-completion

Create deployment
-----------------

Setup:

	minikube start
		minikube ip		# shows ip like 192.168.99.100
		minikube dashboard
		kubectl cluster-info
		kubectl get nodes

Deploy:

	kubectl create deployment hello-node --image=gcr.io/hello-minikube-zero-install/hello-node
		kubectl get deployments
		kubectl get pods
		kubectl get svc
		kubectl get events
		kubectl config view
		kubectl describe deployment hello-node

	kubectl expose deployment hello-node --type=LoadBalancer --port=8080 [--target-port=18080] [--external-ip=...]
		kubectl get services	# shows external port like 8080:32065/TCP

	curl http://192.168.99.100:32065/

Teardown:

	kubectl delete service hello-node
	kubectl delete deployment hello-node

	minikube stop
	minikube delete
	

Tutorials
---------

* https://kubernetes.io/docs/tutorials/hello-minikube/

