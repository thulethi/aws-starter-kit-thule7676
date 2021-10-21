from diagrams import Cluster, Diagram, Edge
from diagrams.aws.compute import ECR, ECS, Lambda
from diagrams.aws.database import RDS, Dynamodb
from diagrams.aws.network import ELB, CloudFront, Route53
from diagrams.aws.security import ACM, IAM, KMS
from diagrams.aws.storage import S3
from diagrams.generic.blank import Blank
from diagrams.onprem.ci import CircleCI
from diagrams.onprem.client import User, Users
from diagrams.onprem.iac import Terraform
from diagrams.onprem.vcs import Github

with Diagram(name="training infrastructure", filename="infra", show=False) as diagram:

    dev = User("developer")

    tf = Terraform()
    repo = Github("repository")
    ci = CircleCI("circle")

    with Cluster("shared"):
        iam = IAM("netguru-circleci")
        state = S3("bucket: state")
        lock = Dynamodb("dynamo: locks")
        [state, lock] << tf

    with Cluster("env: staging") as stage:
        bl = Blank()

        with Cluster("region: global / base"):
            dns_zone = Route53("project zone")
            dns_api = Route53("api.*")
            dns_www = Route53("www.*")

        with Cluster("region: eu-central-1 / backend"):
            acm_ecs = ACM("tls")

            with Cluster("ecs cluster"):
                alb = ELB("alb\ntcp/80 tcp/443")

                with Cluster("ecs service: backend"):
                    ecr = ECR("ecr")
                    web = ECS("service\ntcp/3000")

                web << ecr
                dns_api >> alb >> Edge(label="80:3000") >> web
                alb << acm_ecs

        with Cluster("region: us-east-1 / frontend"):
            s3 = S3("bucket: frontend")
            cf = CloudFront("distribution")
            auth = Lambda("lambda: basic auth")
            acm_cf = ACM("tls")

            dns_www >> cf >> s3
            cf << Edge(forward=True, reverse=True) << auth
            cf << acm_cf

    Users("users") >> [dns_api, dns_www]

    [s3, ecr] << ci << [repo, iam]
    [tf, repo] << dev
