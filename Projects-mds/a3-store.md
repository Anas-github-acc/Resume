# a3.store - Distributed Key-Value Store

## Project Overview

**a3.store** is a distributed key-value database inspired by DynamoDB and Cassandra, built from scratch to explore distributed systems, replication, fault tolerance, consistency, service-to-service communication, and cloud deployment.

The system provides a simple `PUT`/`GET` interface while distributing data across multiple nodes. It supports configurable replication, quorum-based writes, gossip-based cluster membership, anti-entropy repair, local persistent storage, and Kubernetes/AWS deployment.

Live demo: https://a3store.vercel.app
GitHub: https://github.com/Anas-github-acc/a3.store

---

## What the System Does

A client can send a `PUT` or `GET` request to any node in the cluster.

For writes:

1. Client sends a `PUT` request to any KV node.
2. The node determines the replica nodes responsible for the key.
3. Data is synchronously replicated to the configured replication factor.
4. The write waits for the required quorum/replica acknowledgements.
5. If a replica is temporarily unavailable, the write can be placed into a hinted-handoff queue.
6. Background anti-entropy processes later reconcile divergent data.

For reads:

1. Client sends a `GET` request to any node.
2. The node retrieves the requested value from local storage / replicas.
3. Replication and repair mechanisms help maintain consistency between nodes.

---

## Core Architecture

### Cluster

Default development configuration:

* 3 KV nodes
* Replication factor: 2
* Each node has independent persistent storage
* Each node exposes a gRPC service
* Each node exposes a lightweight HTTP gossip endpoint

Example:

```text
             Client
                |
        +-------+-------+
        |               |
        v               v
     Node 1           Node 2
        | \             / |
        |  \           /  |
        |   \         /   |
        |    \       /    |
        v     v     v     v
     SQLite SQLite SQLite
        Node 1  Node 2  Node 3
                 |
               Node 3
```

### Node Internals

Each node contains:

* Main process/thread for lifecycle management
* gRPC thread pool for client and internal RPCs
* Gossip HTTP thread
* Gossip background loop
* Anti-entropy background loop
* SQLite storage engine using WAL mode

The gRPC service handles:

* `Put`
* `Get`
* `Replicate`
* `GetChunkHash`
* `FetchRange`

---

## Distributed Systems Mechanisms

### 1. Replication

Keys are replicated across multiple nodes according to a configurable replication factor.

Current default:

```text
Nodes = 3
Replication Factor = 2
```

This allows the system to tolerate node failures while keeping replicated data available.

### 2. Quorum-Based Writes

Writes are synchronously forwarded to replicas and wait for the configured quorum before being considered successful.

Important concepts:

* Replication factor
* Write quorum
* Replica acknowledgements
* Failure handling
* Consistency vs availability tradeoffs

### 3. Gossip Membership

Nodes discover and monitor peers through a decentralized gossip protocol.

Behavior:

* Nodes periodically send heartbeats.
* Membership information propagates between peers.
* Failed nodes are detected through missed heartbeats.
* No centralized membership coordinator is required.
* Cluster membership eventually converges across nodes.

Current gossip interval:

```text
~1 second
```

### 4. Anti-Entropy Repair

The keyspace is divided into **16 chunks**.

Instead of comparing the complete database between nodes:

1. Nodes calculate hashes for chunks.
2. Nodes exchange chunk hashes.
3. Matching chunks are skipped.
4. Mismatched chunks are identified.
5. Only divergent key ranges are fetched and synchronized.

Current repair interval:

```text
~30 seconds
```

This reduces unnecessary synchronization traffic compared with full database comparison.

### 5. Hinted Handoff

When a replica is temporarily unavailable during a write, the system can retain the pending replication information and retry delivery later.

This improves resilience during temporary node failures.

### 6. Persistent Storage

Each KV node uses:

```text
SQLite + WAL mode
```

Each node maintains its own local database/data directory.

WAL provides better support for concurrent reads/writes within the node.

---

# Metrics and Measurements

## Important Performance Metrics

The following metrics should be measured when benchmarking the system. **Do not claim numerical improvements on a resume unless they have actually been benchmarked.**

### Request Performance

* GET throughput - requests/second
* PUT throughput - requests/second
* Overall requests/second
* Average latency
* p50 latency
* p95 latency
* p99 latency
* Maximum latency
* Error rate
* Timeout rate

### Distributed-System Metrics

* Replication success rate
* Replication latency
* Replication failures
* Number of pending hinted-handoff entries
* Anti-entropy repair duration
* Number of repaired keys
* Number of divergent chunks
* Gossip convergence time
* Node failure detection time
* Recovery time after node restart

### Storage Metrics

* SQLite read latency
* SQLite write latency
* Database size per node
* Keys stored per node
* WAL size
* Disk I/O
* Storage growth rate

### Infrastructure Metrics

* CPU utilization per node
* Memory utilization per node
* Network bandwidth
* Network packets
* Pod/container restarts
* Kubernetes node utilization
* EKS pod scheduling
* Autoscaling events
* Availability during rolling deployments

---

# Recommended Benchmark Experiments

To generate quantitative resume bullets, benchmark the following scenarios.

### Experiment 1 - Single Node

Measure:

```text
1 node
RF = 1
```

Record:

* GET throughput
* PUT throughput
* p50/p95/p99 latency

### Experiment 2 - Distributed Replication

Measure:

```text
3 nodes
RF = 2
```

Compare against the single-node baseline.

Measure:

* Throughput
* Latency
* Replication overhead
* CPU/network overhead

### Experiment 3 - Node Failure

During continuous writes:

1. Start a 3-node cluster.
2. Stop one node.
3. Continue sending requests.
4. Measure request success rate.
5. Measure recovery after the node returns.

Record:

* Failure detection time
* Successful requests during failure
* Replication recovery time
* Data consistency after recovery

### Experiment 4 - Anti-Entropy

Create intentional divergence between replicas.

Measure:

* Number of divergent chunks
* Repair duration
* Number of keys repaired
* Network traffic during repair
* Time until replicas converge

### Experiment 5 - Horizontal Scaling

Compare:

```text
1 node
3 nodes
5 nodes
```

Measure:

* Requests/sec
* Latency
* CPU utilization
* Network utilization
* Scaling efficiency

### Experiment 6 - Kubernetes Scaling

Deploy on EKS and measure:

* Pod startup time
* Autoscaling response
* Request throughput
* p95/p99 latency
* Node CPU/memory utilization
* Availability during rolling updates

---

# Observability

The project includes observability using:

* Prometheus
* Grafana

Monitor:

* Node health
* Pod health
* CPU
* Memory
* Request traffic
* Database/storage behavior
* Cluster behavior
* Replication
* Distributed-system background processes

The Kubernetes deployment also uses:

* Readiness probes
* Liveness probes
* PodDisruptionBudgets
* NetworkPolicies
* Cluster Autoscaler

---

# Technology Stack

## Backend

* Python
* gRPC
* Protocol Buffers
* SQLite
* SQLite WAL

## Distributed Systems

* Gossip protocol
* Replication
* Quorum-based writes
* Consistent hashing / keyspace partitioning
* Anti-entropy
* Chunk hashing
* Hinted handoff
* Eventual consistency
* Failure detection
* Self-healing data repair

## Client

* Node.js
* JavaScript
* gRPC client

## Containers

* Docker
* Docker networking
* Persistent volumes

## Kubernetes

* Kubernetes
* Amazon EKS
* Traefik
* NodePort
* NetworkPolicies
* PodDisruptionBudgets
* Readiness probes
* Liveness probes
* Cluster Autoscaler

## AWS

* EKS
* EC2 worker nodes
* EBS persistent volumes
* RDS metadata storage
* Network Load Balancer
* NAT Gateway
* VPC
* Public/private subnets
* Multiple Availability Zones
* Security Groups

## Infrastructure as Code

* Terraform
* Kubernetes manifests
* AWS infrastructure configuration

## Observability

* Prometheus
* Grafana

---

# AWS Deployment Architecture

The production-style deployment is designed around AWS EKS.

```text
                         Internet
                            |
                         Gateway
                            |
                    Network Load Balancer
                            |
                    Private Subnet / EKS
                            |
                     Traefik Controller
                            |
                       API Service
                            |
                +-----------+-----------+
                |           |           |
              KV Node     KV Node     KV Node
                |           |           |
              EBS         EBS         EBS
                |
              RDS
```

### Inbound Traffic

```text
User
  |
  v
Network Load Balancer
  |
  v
EKS Worker Node
  |
  v
Traefik
  |
  v
API Service
  |
  v
KV Nodes
  |
  v
Persistent EBS Storage
```

### Outbound Traffic

Pods in private subnets can access external services through:

```text
Private Subnet
      |
      v
NAT Gateway
      |
      v
Internet / External Services
```

### AWS Reliability Features

The deployment includes:

* Multiple availability zones
* Private subnets for workloads
* Network Load Balancer
* Kubernetes scheduling
* Persistent EBS storage
* Security Groups
* NetworkPolicies
* Readiness/liveness probes
* PodDisruptionBudgets
* Cluster Autoscaler
* Prometheus/Grafana monitoring

---

# Deployment Options

## Local Docker

A 3-node cluster can be launched locally using Docker.

```text
Docker Network
      |
 +----+----+----+
 |    |    |    |
Node1 Node2 Node3
```

Each node gets:

* Its own container
* Its own data directory/volume
* Its own gRPC port
* Its own gossip port

## Minikube

The cluster can also be tested locally using Kubernetes/Minikube.

## AWS EKS

The project includes infrastructure and Kubernetes configuration for AWS deployment.

Relevant repository directories:

```text
infra/
terraform/
k8s/
```

---

# Configuration

Important runtime configuration includes:

```text
NODE_NUM
GRPC_PORT
GOSSIP_PORT
PEERS
GOSSIP_PEERS
REPLICATION_FACTOR
DATA_DIR
ANTI_ENTROPY_INTERVAL
DEBUG_LOG
```

The architecture is configurable rather than hard-coded to a fixed cluster size.

---

# Features Relevant to Resume

Strong technical areas demonstrated by this project:

* Built a distributed key-value database from scratch.
* Designed a multi-node replicated storage architecture.
* Implemented gRPC-based client-to-node and node-to-node communication.
* Implemented gossip-based decentralized membership.
* Implemented replica synchronization and quorum-based writes.
* Implemented anti-entropy using chunk-level hashing.
* Implemented failure recovery / hinted handoff.
* Used SQLite WAL for persistent node-local storage.
* Designed background concurrency for gossip and anti-entropy.
* Containerized the distributed cluster with Docker.
* Deployed distributed workloads on Kubernetes/AWS EKS.
* Designed AWS networking with public/private subnets and NAT.
* Added NetworkPolicies for inter-service communication control.
* Added readiness/liveness probes and PodDisruptionBudgets.
* Configured Kubernetes Cluster Autoscaler.
* Added Prometheus/Grafana observability.
* Used Terraform for infrastructure provisioning.
* Designed the system around fault tolerance, replication, consistency, and recovery.

---

# Resume Bullet Generation Guidance

When generating resume bullets from this project:

## Prioritize

1. Quantifiable performance
2. Distributed systems concepts
3. Reliability/fault tolerance
4. Architecture complexity
5. Cloud/Kubernetes deployment
6. Observability
7. Infrastructure automation
8. Concrete engineering decisions

## Prefer bullets structured as

```text
Action + What was built + Technical mechanism + Measurable result
```

Example structure:

> Engineered a distributed key-value store with gRPC-based replication, gossip membership, and quorum writes across a 3-node cluster, enabling fault-tolerant data access with configurable replication.

For measured results:

> Optimized distributed read/write performance by implementing [technique], improving throughput from X to Y req/s and reducing p99 latency by Z%.

For Kubernetes:

> Deployed the distributed database on AWS EKS using Terraform and Kubernetes, adding autoscaling, health probes, NetworkPolicies, and persistent EBS storage for resilient workloads.

For observability:

> Implemented Prometheus/Grafana observability for cluster and node health, tracking request latency, throughput, resource utilization, replication, and recovery behavior.

**Important:** Only use numerical claims after running and recording the corresponding benchmark.

---

# Keywords for ATS / Technical Interviews

```text
Distributed Systems
Distributed Database
Key-Value Store
Python
gRPC
Protocol Buffers
Replication
Quorum
Consistency
Eventual Consistency
Fault Tolerance
Gossip Protocol
Failure Detection
Anti-Entropy
Consistent Hashing
Hinted Handoff
Data Replication
Self-Healing
SQLite
WAL
Docker
Kubernetes
Amazon EKS
AWS
Terraform
Traefik
Network Load Balancer
NAT Gateway
EBS
RDS
NetworkPolicies
Cluster Autoscaler
Prometheus
Grafana
Observability
Infrastructure as Code
High Availability
Horizontal Scaling
```

---

# What Should NOT Be Claimed Without Measurement

Do not invent or assume:

* Requests per second
* Percentage latency reduction
* Percentage availability
* Number of users
* Production traffic
* Cost savings
* Specific uptime/SLA
* Specific scalability limits
* Specific failure recovery time
* Specific benchmark improvements
* "Millions of requests"
* "Production-ready" unless actually operated as such

Use the architecture and implemented features as qualitative evidence, and use benchmark results for quantitative resume claims.

---

# Primary Resume Angle

The strongest positioning for this project is:

**"Built a distributed database from scratch and deployed it as a cloud-native distributed system."**

The project demonstrates practical understanding of:

```text
Distributed Systems
        +
Backend Engineering
        +
Cloud Infrastructure
        +
Kubernetes
        +
Observability
        +
Fault Tolerance
```

This should be emphasized over describing it simply as a "key-value store."
