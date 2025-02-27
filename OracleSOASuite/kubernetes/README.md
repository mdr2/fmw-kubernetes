### Oracle SOA Suite on Kubernetes

The WebLogic Kubernetes operator (the “operator”) supports deployment of Oracle SOA Suite components such as Oracle Service-Oriented Architecture (SOA), Oracle Service Bus, and Oracle Enterprise Scheduler (ESS). Currently the operator supports these domain types:

* `soa`: Deploys a SOA domain with Oracle Enterprise Scheduler (ESS)
* `osb`: Deploys an Oracle Service Bus domain
* `soaosb`: Deploys a domain with SOA, Oracle Enterprise Scheduler (ESS), and Oracle Service Bus

***
The current supported production release is [21.3.2](https://github.com/oracle/fmw-kubernetes/releases).
***

In this release, Oracle SOA Suite domains are supported using the “domain on a persistent volume”
[model](https://oracle.github.io/weblogic-kubernetes-operator/userguide/managing-domains/choosing-a-model/) only, where the domain home is located in a persistent volume (PV).

The operator has several key features to assist you with deploying and managing Oracle SOA Suite domains in a Kubernetes environment. You can:

* Create Oracle SOA Suite instances in a Kubernetes persistent volume (PV). This PV can reside in an NFS file system or other Kubernetes volume types.
* Start servers based on declarative startup parameters and desired states.
* Expose the Oracle SOA Suite services and composites for external access.
* Scale Oracle SOA Suite domains by starting and stopping Managed Servers on demand, or by integrating with a REST API to initiate scaling based on WLDF, Prometheus, Grafana, or other rules.
* Publish operator and WebLogic Server logs to Elasticsearch and interact with them in Kibana.
* Monitor the Oracle SOA Suite instance using Prometheus and Grafana.

#### Getting started

Refer the following documentation link for detailed information about deploying Oracle SOA Suite domains on Kubernetes.  
[Documentation](https://oracle.github.io/fmw-kubernetes/soa-domains/)

