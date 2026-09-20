# Multi-Region AWS Infrastructure with Global Accelerator & ECS

This project provisions a resilient, multi-region architecture using Terraform with an S3 backend and GitHub Actions, deploying an Amazon ECS Fargate application across two AWS regions (`us-east-1` and `us-west-2`) fronted by an AWS Global Accelerator.

---

## 🏗️ Architecture & Workflow Diagram

```mermaid
graph TD
    subgraph Client_Layer ["Client & Global Entry"]
        User([Client / Browser]) -->|Global IP: a94e92d27d47adec8| GA[AWS Global Accelerator]
    end

    subgraph AWS_Cloud ["AWS Global Infrastructure"]
        subgraph Region_A ["Region: us-east-1"]
            ALB_A[ALB: us-east-1] --> ECS_A[ECS Fargate: Prod Service]
        end
        
        subgraph Region_B ["Region: us-west-2"]
            ALB_B[ALB: us-west-2] --> ECS_B[ECS Fargate: Prod Service]
        end
    end

    %% Network Routing Associations
    GA -->|Active / Weight 128| ALB_A
    GA -->|Standby / Weight 128| ALB_B