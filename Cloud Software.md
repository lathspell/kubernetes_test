Glossary
========

_Proxy (generic)_

A service that provides cross-cutting functions that many micro services need so that they themselves can stay slim. Examples are

- Authentication (OAuth2)
- Authorization (ACLs, Policy Enforment, filter invalid requests)
- Accounting
- Monitoring (telemetry/metrics, logging, tracing headers)
- Dynamic Routing (Loadbalancing, A/B-Testing, Failover, URL-Rewriting)

_API-Gateway_

Proxies running between the Ingress and the Services ("north-south").
Usually for HTTPS termination and Authentication. 
Exposes API URLs to the outside.

_Service Mesh_

Little proxies running as Sidecards and mainly for inter-service communication ("east-west").
A design where all services are accessed through Proxies (data plane) which 
are configured by a central controller (control plane).
Each services usually has a little proxy as Sidecar running so no "central" single-point-of-failure proxy!
Authorization is usually not done using app specific username/passwords but
with "service identitites".

Software
========

Lists
-----

* https://jimmysong.io/awesome-cloud-native/
* https://epsagon.com/blog/cncf-tools-overview-are-you-cloud-native/

Meta-Orchestrierung
-------------------

Rancher
* Management of multiple Kubernetes installations. 

Infrastructure
--------------

CoreDNS
* Kubernetes default internal DNS server

etcd
* Distributed key-value store

Ingres Controller / Loadbalancers / API-Gateways / Service-Proxies / Service Mesh
----------------------------------------------------------

nginx

* General purpose proxy server, good as HTTP server and HTTP reverse proxy.
  Can also talk to Istio Mixer.

Eureka (Netflix)

* Service registry and programmable load balancer (for AWS?)

Kong

* Reverse Proxy / API Gateway
    - load balancing
    - TLS
    - authentication, OAuth2
    - metrics
    - logging
    - health checks / circuit breakers

Traefik
* Reverse Proxy.
    - load balancing
    - Let's Encrypt automatically
    - circuit breakers and automatic retry
    - metrics
    - access logs
    - web UI
    - kein OAuth2

Caddy
* Webserver und reverse proxy
    - easy to setup
    - automatic HTTPS with Let's Encrypt

Keycloak Gatekeeper
* Reverse Proxy für OAuth2

Envoy
* Proxy server. Part of Istio.

Istio
* Service Mesh.
    - Envoy is the HTTP proxy (data-plane)
    - Pilot does the configuration (control-plane)
    - Mixer helps to make policy decisions

Consul
* Service Mesh.
    - service discovery
    - automatic TLS certificates
    - health checking
    - dynamic routing

linked
* Proxy server. Can also talk to Istio Mixer

Zuul (Netflix)
* Proxy server.
    - dynamic routing
    - monitoring
    - reiliency
    - security
    - no automatic TLS?

SPIFFE / Spire
* Secure Production Identity Framework for Everyone. Aims to help
 identiy software systems without the need of application level
 authentication.
    - Spire is the API library.
    - See https://spiffe.io/

Metrics / Statistics / Logging
------------------------------

Prometheus
* Metrics collector (pull-only) and visualization for time series.
    - Grafana is used for visualization
    - Alertmanager can notify external services
    - Push Gateway can be used for short-lived cronjobs (careful!)
    - Uses multi-dimensional data model with own storage and PromQL query language.
    - Has service discovery features to detect new hosts.
    - See https://prometheus.io/
