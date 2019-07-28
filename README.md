Concepts
========

Glossary
--------

Workloads:

  Ingres Controller         Kubern

  Pod                       Kubernetes unit, usually a Container with Volumes and Sidecars
    Container               Based on e.g. a Docker image; usually only one per pod
    Volume                  Some kind of storage
    Sidecar                 HTTP-Proxy or similar

Configurations:

  Service                   Definition of an externally accessible port and load balancing.

  Deployment                Definition of a Replica Set and Pod

  Replica Set               Defines how many instances have to exist

  Daemon Set                Defines that all nodes should run a specific Pod.
                            Used for infrastructure Pods like glusterd, logstash or collectd.

  Config Map                Defines where other configurations can get config values from.
  
  Secret                    Storage for secrets.



Free-Tier GCP
=============

* GCP Free Tier limitations: https://cloud.google.com/free/docs/gcp-free-tier#always-free
* Beware: HTTP Load Balancing is *not* free, use custom NGINX: https://cloud.google.com/compute/pricing?hl=de#lb
* Beware: "f1-micro" nodes only have 600MB RAM with only ca. 100 MB available when using coreos and starting more than one Java app will crash them!

    gcloud beta container --project "kubernetes-2019b-43758" clusters create "free-tier" \
        --region "us-east1" \
        --no-enable-basic-auth \
        --cluster-version "1.12.8-gke.10" \
        --machine-type "f1-micro" \
        --image-type "COS" \
        --disk-type "pd-standard" \
        --disk-size "100" \
        --metadata disable-legacy-endpoints=true \
        --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" \
        --preemptible \
        --num-nodes "1" \
        --enable-stackdriver-kubernetes \
        --enable-ip-alias \
        --network "projects/kubernetes-2019b-43758/global/networks/default" \
        --subnetwork "projects/kubernetes-2019b-43758/regions/us-east1/subnetworks/default" \
        --default-max-pods-per-node "110" \
        --addons HorizontalPodAutoscaling \
        --enable-autoupgrade \
        --enable-autorepair \
        --maintenance-window "04:00"
    
    gcloud beta container clusters get-credentials free-tier --region us-east1 --project kubernetes-2019b-43758

Console login to node using:

    gcloud beta compute --project "kubernetes-2019b-43758" ssh --zone "us-east1-d" "gke-free-tier-default-pool-7240688e-wlrp"
  
Cluster Hibernating
-------------------

To save costs, a cluster can be hibernates by defining that each Zone has 0
instead of 1 Compute Engine Virtual Machine.  That can be done by editing the
(usually three) Compute Engine Instance Group definitions (e.g.
gke-free-tier-default-pool-7240688e-65g8) on

    https://console.cloud.google.com/compute/instanceGroups/details/us-east1-d/gke-free-tier-default-pool-7240688e-grp?project=kubernetes-2019b-43758&edit=true&tab=members

Kubernetes Playground
=====================

Preparation
-----------

    source load-bash-completion
   or
    source <(kubectl completion bash)

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
        kubectl get service -o wide
        kubectl get replicasets -o wide
		kubectl get pods
		kubectl get svc
		kubectl get events
		kubectl config view
		kubectl describe deployment hello-node

	kubectl expose deployment hello-node --type=LoadBalancer --port=8080 [--target-port=18080] [--external-ip=...]
		kubectl get services	# shows external port like 8080:32065/TCP

	curl http://192.168.99.100:32065/

    kubectl autoscale deployment hello-node --min=2 --max=10

Teardown:

	kubectl delete service hello-node
	kubectl delete deployment hello-node

	minikube stop
	minikube delete
	
View
----

  kubectl version
  kubectl get all --all-namespaces          <-- the big overview
  kubectl get nodes

  kubectl get pods
  kubectl describe pods
  kubectl logs hello-server-6f5bdf948c-7ttsv            - Logs
  kubectl exec -ti hello-server-6f5bdf948c-7ttsv bash   - Shell

Proxy
-----

  kubectl proxy                 - Open port 8001 to Kubernetes REST API 

    GET localhost:8001/logs/kube-apiserver.log
    GET localhost:8001/healthz/ping
    ...
    GET localhost:8001/api/v1/namespaces/default/pods/hello-server-6f5bdf948c-7ttsv/            - POD status
    GET localhost:8001/api/v1/namespaces/default/pods/hello-server-6f5bdf948c-7ttsv/proxy/      - HTTP without Loadbalancer

Tutorials
---------

* https://kubernetes.io/docs/tutorials/hello-minikube/

Links
=====
* https://www.digitalocean.com/products/kubernetes/
