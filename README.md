Concepts
========

Glossary
--------

Concepts:
    
    Label                     Identifying key-value that is not directly part of the object syntax (e.g. projectname or version)
    Annotation                Non-Identifying key-value that is not directly part of the object syntax (e.g. last modify timestamp)         

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

Access Configuration:
   
    ServiceAccount            Definition of an account. Stores the access token in a Secret.

    Role                      Role definition (e.g. "kube-system/admin") with specific access privileges
    ClusterRole               Role for all namespaces of a cluster

    RoleBinding               Binds a Service Account to a Role (e.g. "kube-system/cluster-admin")
    ClusterRoleBinding        RoleBinding for all namespaces of a cluster

kubectl
=======

view
----
	
	kubectl version
	kubectl cluster-info
	kubectl config get-contexts …               # shows and configures Contexts and Clusters (-> kubectx)	
	kubectl api-resources / api-versions        # shows all API objects and their current versions
	kubectl explain pod.spec                    # shows the reference manual for the object "Pod" (or others)
	kubectl get all --all-namespaces -o wide    # the big overview ("all" is not really all and no longer documented!)
	kubectl get nodes
	kubectl get deployments
    kubectl get service -o wide
    kubectl get replicasets -o wide
	kubectl get pods
	kubectl get svc                             # alias for "kubectl get services"
    kubectl get services	                    # shows external port like 8080:32065/TCP	
    kubectl get endpoints                       # shows endpoint ip addressses; managed by services
	kubectl get events
	kubectl get ingress                         # shows Ingress objects; not included in "get all" 
	kubectl get service,ingress                 # shows both categories
	kubectl get networkpolices                  # shows network policies that limit access to Pods by e.g. labels
	kubectl get pod foo -o yaml --export        # shows Yaml without Container specific details
	kubectl get pod -l app=foo                  # selects Pod not by name but by Label
	kubectl get pod -L project,app              # shows only the Labels "project" and "app"
	kubectl get pod -l 'app in (foo,bar)'       # selects Pods with label "app" being either "foo" or "bar"
	kubectl config view
	kubectl describe deployment hello-node
    kubectl describe pods                                   # human readable information
    kubectl logs hello-server-6f5bdf948c-7ttsv              # Logs of this Pod 
    kubectl logs tmp -c b2                                  # Logs from Pod "tmp" Container "b2" (for multi-container Pods)
    kubectl exec -ti hello-server-6f5bdf948c-7ttsv bash     # Shell into this Pod

    # Show information using custom template
    kubectl get pod nginx1 -o jsonpath --template='{.metadata.name},{.metadata.annotations.description}{"\n"}'
    # Show information (node names for alle running pods) using JSON-Template with "\n" as separator
    kubectl get pods -o go-template='{range .items[*]}{.spec.nodeName}{"\n"}{end}'

    # Show really everything in the current namespace
    kubectl api-resources --namespaced=true -o name | paste -s -d, | xargs -I{} kubectl get {} --ignore-not-found --show-kind

    kubectl rollout status deployment nginx     # shows rollout status

edit
----

    # declarative
    kubectl apply -f foo.yaml

    # imperative
	kubectl create deployment hello-node --image=gcr.io/hello-minikube-zero-install/hello-node
	kubectl expose deployment hello-node --type=LoadBalancer --port=8080 [--target-port=18080] [--external-ip=...]

	curl http://192.168.99.100:32065/

    kubectl autoscale deployment hello-node --min=2 --max=10
    
    # Run a single command in a Pod (--restart=Never creates a Pod without a Deployment; --rm deletes if afterwards) 
    kubectl run tmp1 -it --rm --image=busybox --restart=Never --command -- env
    # Run a single command to access another Container on its internal IP
     ubectl run tmp7 -it --rm --restart=Never --image=busybox --command -- wget -qO-  http://172.17.0.18/
    # Generates Yaml for an action without executing it
    kubectl create namespace mynamespace --dry-run -o yaml
    # Updates image for container with name "nginx" in Pod or Deployment with name "nginx3"
    kubectl set image pod/nginx3       nginx=nginx:1.8.1
    kubectl set image deployment/nginx nginx=nginx:1.7.9
    # Edit object using JQ and reapply
    kubectl get pod nginx2 -o json | jq '.metadata.labels.app = "v2"' | kubectl apply -f -
    # Edit and remove labels
    kubectl label pods nginx2 app=v3 --overwrite
    kubectl label pods nginx2 app-
    # Add or remote annotation metadata from objects
    kubectl annotate pod nginx1 nginx2 nginx3 description="my descr" --overwrite
    kubectl annotate pod nginx{1..3} description-
    # Show revision history and undo last rollout (e.g. after changing the image version)
    kubectl rollout history deployment nginx
    kubectl rollout undo deployment/nginx
    # Delete all Deployments
    kubectl delete deployment --all
    # Immediately delete a pod
    kubectl delete pod --force --grace-period=0 foo

configuration
-------------
* environment variables can be specified as literals
* environment variables can be taken from configmaps as individual values (env/valueFrom/configMapKeyRef)
* environment variables can be loaded as bulk from a file (envFrom/configMapRef)

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

Kubernetes with Minikube
========================

CLI
---

Setup

    source <(kubectl completion bash)
    minikube config set memory 4096         # change memory from 2GB to 4GB
    minikube config set cpu 4               # change cpus from 1 to 4
	minikube start
    eval $(minikube docker-env)             # Docker images should be build and stored in the Minikube Docker instance
	
Status:

	minikube ip		# shows ip like 192.168.99.100
	minikube dashboard

Teardown:

	kubectl delete service hello-node
	kubectl delete deployment hello-node

	minikube stop
	minikube delete

Network Access
--------------

A Pod (i.e. a Docker container) can listen on as many ports as it wants, only the "exposed" are reachable by other
containers. They are not reachable by other apps on the Host though. For that they have to declare a port forwarding
(docker -p 8080:80).

Kubernetes normally uses more than one host nodes though so the port must not only forwarded to localhost:1234 but to the
external IP of that host node. This is done using a Service, e.g. one with type NodePort.

Applications outside the Kubernetes Cluster still do not see this port as the whole cluster network is fenced off to
the outside. Additionally the outsider would not know which Kubernetes host node currently has an instance of the service
running. A Service of type LoadBalancer is needed here which takes care of forwarding to the port on the right node.
Each service has a unique IP address inside the cluster and LoadBalancer services can additionally use a specific external
IP to bind on.

With Minikube which always only has one node there are several possibilities:
1. Using a NodePort service and forward using a high port (30000-32767) on the Minikube IP. This port range is passed
   through 1:1 to the host node.
   
         $ kubectl get services
         NAME                    TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                         AGE
         f1b                     NodePort    10.104.40.33     <none>        80:32533/TCP                    16m
         $ http $(minikube ip):32533
         
2. Use the "minikube tunnel" command. The real port (e.g. 8080) is then available on the IP listed in 
   "kubectl get service" as "Cluster-IP". Every service has its own IP though! This command also enables
   the use of the LoadBalancer service type. Its "External-IP" is the same as the internal one, though.
   
3. Use "kubectl port-forward service/organizationservice 18080:8080" to forward localhost:18080 to port 8080 of
   any Pod in that service. The port-forwarding is not a Kubernetes object but a CLI feature.

4. Use Minikube "ingress" add-on and an Ingres service type. This will put an Nginx or similar proxy, running in
   a Pod itself, between the outside world and the internally accessible cluster IPs. Only for HTTP traffic though.

Kubectl Proxy
-------------

  kubectl proxy                 - Open port 8001 to Kubernetes REST API 

    GET localhost:8001/logs/kube-apiserver.log
    GET localhost:8001/healthz/ping
    ...
    GET localhost:8001/api/v1/namespaces/default/pods/hello-server-6f5bdf948c-7ttsv/            - Pod status
    GET localhost:8001/api/v1/namespaces/default/pods/hello-server-6f5bdf948c-7ttsv/proxy/      - HTTP to that Pod without Loadbalancer

Docker Images
-------------

Kubernetes does not know about any Docker daemons running locally on the desktop.
Minikube can give the local docker CLI access to the Kubernetes docker daemon though.
All images have to be rebuild (or otherwise pushed to this Docker instance).

  eval $(minikube docker-env)
  docker build …
  kubectl run … --image-pull-policy=Never

Tutorials
---------

* https://kubernetes.io/docs/tutorials/hello-minikube/

Links
=====

Tools
-----
* Komposer - Can convert Docker Compose docker-compose.yml to Kubernetes or Helm chars (although ugly ones)
* kube-ps1 - shows context and namespace in prompt (https://github.com/jonmosco/kube-ps1)
* kubectx / kubens - fast switching between contexts and namespaces (https://github.com/ahmetb/kubectx)
* kubespy - watch resource changes in realtime (https://github.com/pulumi/kubespy)
* squash - attach debugger (gdb, Go/Java/Python) to any process running in a Pod
* kubed-sh - runs scripts inside a pod and hot-reloads them after changes (https://kubed.sh/)
* stern - logfile watching in "tail -f" style for multiple Pods (https://github.com/wercker/stern)

Provider
--------
* https://www.digitalocean.com/products/kubernetes/
