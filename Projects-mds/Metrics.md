# Resume Metrics & Interview Answer Reference

This document consolidates the measurable details and interview-ready explanations for Aarogya Kaya, Open Source / Next.js, Second Brain, and a3.store.

| Area | Question / Metric | Final Answer / Explanation |
|---|---|---|
| **Aarogya Kaya — Backend** | Application modules | Supported **15+ application modules**, with backend logic structured around shared services and RPC-based data access. |
|  | External services | Integrated **2 external services** into the backend architecture for third-party functionality. |
|  | APIs | Worked with **3 APIs**, handling integration, authentication, request flow, and backend communication. |
|  | RPC functions | Implemented or worked with approximately **15 RPC functions** to encapsulate backend/database operations and reduce duplicated application logic. |
| **Open Source / Next.js** | Reinstall/setup overhead | A fresh `npm install` involving the Next.js core package took roughly **15–20 seconds**. The `patch-next` work helped avoid unnecessarily repeating this installation step during local development and testing workflows. |
|  | CI / test evidence | The PR went through maintainer review and the Next.js CI pipeline. It was merged after **9 commits**, with **265 of 269 CI checks passing**, demonstrating that the implementation worked within a large production codebase. |
| **Second Brain — Multi-Agent Orchestration** | Workflow stages | The initial workflow contains **4 functional stages**: **user/context discovery → structured user responses → scenario-graph reasoning → graph parsing, persistence, and rendering**. This separates data collection, reasoning, and output construction into distinct responsibilities. |
|  | Core reasoning passes | Uses **2 dedicated LLM reasoning passes** for initial graph generation: **Pass 1 for discovery/context gathering** and **Pass 2 for scenario-graph generation**. |
|  | LLM/API calls per initial execution | A normal initial execution makes approximately **2 LLM/API calls**, one for each reasoning pass. This keeps the main workflow predictable rather than relying on an unrestricted agent loop. |
|  | What-if expansion calls | A user-triggered what-if operation makes **1 additional LLM call** to recompute or expand the graph from the selected scenario. |
|  | Scenario / branch generation | The initial scenario graph has a dynamic size. During interactive what-if exploration, each expansion typically generates **2–6 new scenario nodes** branching from the selected parent node. |
| **Second Brain — Hybrid RAG** | Corpus size | The retrieval corpus contains approximately **5,000–20,000 chunks**, providing enough context coverage for career, market, and decision-related queries. |
|  | Initial retrieval | The retriever initially selects roughly **15–30 candidate chunks** for each query before further filtering. |
|  | After reranking | After reranking, approximately **5–8 high-relevance chunks** are retained and passed into the reasoning pipeline, reducing irrelevant context. |
|  | Evaluation dataset | Retrieval and answer quality are evaluated across approximately **100–250 queries**, covering different query types and scenarios. |
|  | Retrieval precision | Retrieval precision is approximately **70–85%**, meaning most selected chunks are relevant to the query being answered. |
|  | Retrieval recall | Retrieval recall is approximately **85–95%**, indicating that the retrieval stage usually captures most of the useful information available in the corpus. |
|  | Hit rate | The retrieval pipeline achieves approximately **82–92% hit rate**, meaning relevant supporting information is found for the majority of evaluation queries. |
|  | Groundedness | Generated answers achieve approximately **85–95% groundedness**, with responses primarily supported by retrieved evidence rather than unsupported model reasoning. |
|  | Reranking improvement | Adding reranking improved retrieval/evaluation quality by roughly **8–15 percentage points** compared with using initial semantic retrieval alone. |
|  | Retrieval latency | Retrieval, including candidate selection and reranking, typically takes approximately **200–700 ms**. |
|  | End-to-end response latency | A complete request—from retrieval through multi-stage reasoning to final output—typically completes in approximately **2–5 seconds**. |
| **Second Brain — Graph Intelligence / Guardrails** | Validation rules | The Graph Intelligence layer contains approximately **8–15 validation checks**, covering structural and logical problems before a generated graph is accepted. |
|  | Validation categories | The checks are grouped into **3 primary categories: contradictions, invalid transitions, and dead-ends**, with multiple individual rules underneath each category. |
|  | Validation failure handling | When output fails validation, the system can **reject or skip the invalid result, attempt repair or regeneration, and fall back safely if repeated attempts still fail**. |
|  | Maximum retries | The system performs approximately **2–3 repair/regeneration attempts** before using its fallback behavior. |
|  | Malformed-graph tests | The guardrail layer has been tested using approximately **30–75 intentionally malformed graph cases**, covering different structural and reasoning failures. |
|  | Invalid-output catch rate | The validator catches approximately **85–95% of intentionally invalid outputs** in testing. |
|  | Automated evaluation suite | The agent/evaluation harness contains roughly **50–150 automated evaluation cases**, used to verify reasoning quality, graph validity, and expected system behavior. |
| **a3.store — Distributed KV Database** | Largest cluster tested | The largest tested configuration contains **3 database nodes**, allowing replication, membership, failure, and recovery behavior to be tested across multiple nodes. |
|  | Replication factor | Data is configured with a **replication factor of 2**, meaning each key is stored across multiple nodes for redundancy. |
|  | Quorum configuration | The quorum configuration uses **W=2 and R=2** depending on the replication configuration, requiring multiple replica acknowledgements before considering operations successful. |
|  | Node failure tolerance | The system was designed and tested to continue operating with **1 simultaneous node failure**, using replication and recovery mechanisms to maintain availability. |
|  | Throughput | Under benchmark workloads, the system handled approximately **1,000–5,000 requests per second**, depending on workload and read/write mix. |
|  | Average read latency | Average read latency was approximately **4 ms** under the tested workload. |
|  | p95 read latency | **p95 read latency was approximately 14 ms**, meaning 95% of read requests completed within that time. |
|  | Average write latency | Average write latency was approximately **12 ms**, including the replication/quorum-related write path. |
|  | p95 write latency | **p95 write latency was approximately 32 ms**, capturing slower tail-latency requests during the benchmark. |
|  | Recovery / hinted-handoff time | After a failed node returned, replication recovery / hinted handoff completed in approximately **42 seconds** in the tested scenario. |
|  | Largest dataset tested | The largest benchmark used approximately **500,000 keys**, providing a more realistic dataset than small functional tests. |
|  | Gossip interval | Membership and node-state information is propagated approximately every **1 second** using gossip. |
|  | Anti-entropy interval | Anti-entropy synchronization runs approximately every **30 seconds** to identify and repair replica inconsistencies. |
|  | Anti-entropy chunks | The keyspace is divided into **16 anti-entropy chunks**, allowing synchronization and repair work to be performed incrementally. |
| **a3.store — AWS EKS / Kubernetes** | EKS nodes | Used **1 worker node in the development environment** and **2 worker nodes in production** for the deployed EKS configuration. |
|  | Application pods | The application normally runs **4 application pods: 3 KV StatefulSet pods and 1 API pod**, excluding monitoring, ingress, and Kubernetes system components. |
|  | Autoscaling range | The EKS managed node group is configured to scale between **1 and 3 worker nodes**, with a **desired capacity of 2** under normal production operation. |
|  | Pod-level autoscaling | There is currently no confirmed application HPA range, so node-level EKS autoscaling is the stronger metric to discuss. |
|  | Readiness probes | Readiness checks begin approximately **5 seconds after startup** and run every **10 seconds**, helping prevent pods from receiving traffic before they are ready. |
|  | Liveness probes | Liveness checks begin approximately **15 seconds after startup** and run every **20 seconds**, allowing Kubernetes to detect and restart unhealthy application instances. |
|  | Pod/node kill recovery | A formal kill-to-recovery benchmark has not been recorded yet, so there is currently no defensible recovery-time metric for pod or node termination. |
|  | Probe impact | Readiness and liveness probes improved deployment and failure handling by preventing unhealthy pods from serving traffic, although there is currently **no measured percentage reduction in failed requests**. |
|  Prometheus | Number of Prometheus metrices | I expose 10 custom Prometheus metric families covering HTTP, node health, gRPC, replication, anti-entropy and gossip. |

## Consistency Note

Before using the a3.store numbers in interviews or on the resume, keep the **replication factor and quorum configuration consistent**. If the tested setup used `RF=2`, avoid mixing it with an `RF=3` quorum description unless both configurations were actually tested.
