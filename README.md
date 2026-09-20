# Multi-Region AWS Infrastructure with Global Accelerator & ECS

A production-grade, highly resilient multi-region infrastructure project designed for seamless failover. This project provisions a modular environment using Terraform with an S3 backend and GitHub Actions, deploying an Amazon ECS Fargate application across two AWS regions (`us-east-1` and `us-west-2`) fronted by an AWS Global Accelerator.

---

## 🏗️ System Architecture

The blueprint below represents the multi-region entry point and traffic routing distribution across your infrastructure.

```mermaid
flowchart TD
    A["User Terminal / GitHub Actions"]

    GA["AWS Global Accelerator<br/>a94e92d27d47adec8"]

    subgraph AWS_Cloud["AWS Global Infrastructure"]
        subgraph Region_East["Region: us-east-1"]
            ALB_East["Application Load Balancer"]
            ECS_East["ECS Fargate: Prod Service"]
        end

        subgraph Region_West["Region: us-west-2"]
            ALB_West["Application Load Balancer"]
            ECS_West["ECS Fargate: Prod Service"]
        end
    end

    A -->|"Terraform Deploy / Manage"| GA

    GA -->|"Active / Weight 128"| ALB_East
    GA -->|"Standby / Weight 128"| ALB_West

    ALB_East --> ECS_East
    ALB_West --> ECS_West
```

## 🔄 Traffic Routing & Failover

The sequence below illustrates normal traffic flow through AWS Global Accelerator and the automatic regional failover process.

```mermaid
sequenceDiagram
    autonumber

    participant Client as "Client / Browser"
    participant GA as "AWS Global Accelerator"
    participant RegionA as "Region A (us-east-1)"
    participant RegionB as "Region B (us-west-2)"

    Note over Client,RegionB: Normal Operation Phase - Traffic Routing

    Client->>GA: HTTP Request - Global DNS
    GA->>RegionA: Route Traffic - Active Endpoint
    RegionA-->>Client: HTTP 200 OK - Response

    Note over Client,RegionB: Failover Simulation Phase - Outage Handling

    RegionA--xRegionA: Simulate Outage - Tasks Scaled to 0
    GA->>RegionA: Health Check Fails - Unhealthy Endpoint
    GA->>RegionB: Automatically Reroute Traffic - Standby Endpoint

    Client->>GA: Next HTTP Request
    GA->>RegionB: Route Traffic to Secondary Region
    RegionB-->>Client: HTTP 200 OK - Seamless Failover
```