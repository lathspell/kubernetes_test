Glossary
========

Proxy
    A service that provides cross-cutting functions that many micro services
    need so that they themselves can stay slim. Examples are
    - Authentication (OAuth2)
    - Authorization (ACLs, Policy Enforment)
    - Accounting
    - Monitoring (number of requests and response times, telemetry/metrics, logging)
    - Dynamic Routing (Loadbalancing, A/B-Testing, Failover, URL-Rewriting)

Service Mesh
    A design where all services are accessed through Proxies (data plane) which
    are configured by a central controller (control plane).
    

Software
========

Infrastructure
--------------

CoreDNS
    Kubernetes default internal DNS server

Ingres Controller / Loadbalancers / Proxies / Service Mesh
----------------------------------------------------------

nginx
    General purpose proxy server, good as HTTP server and HTTP reverse proxy.
    Can also talk to Istio Mixer.

Envoy
    Proxy server. Part of Istio.

Istio
    Service Mesh.
    - Envoy is the HTTP proxy (data-plane)
    - Pilot does the configuration (control-plane)
    - Mixer helps to make policy decisions

linked
    Proxy server. Can also talk to Istio Mixer

SPIFFE / Spire
    Secure Production Identity Framework for Everyone. Aims to help
    identiy software systems without the need of application level
    authentication.
    Spire is the API library.
    See https://spiffe.io/

Metrics / Statistics / Logging
------------------------------

Prometheus
    Metrics collector (pull-only) and visualization for time series.
    - Grafana is used for visualization
    - Alertmanager can notify external services
    - Push Gateway can be used for short-lived cronjobs (careful!)
    Uses multi-dimensional data model with own storage and PromQL
    query language.
    Has service discovery features to detect new hosts.
    See https://prometheus.io/
