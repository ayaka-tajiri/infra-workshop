locals {
  infra_workshop_vpc_subnet_ids = [
    data.terraform_remote_state.vpc.outputs.infra-workshop-tajiri-public-a.id,
    data.terraform_remote_state.vpc.outputs.infra-workshop-tajiri-public-c.id,
    data.terraform_remote_state.vpc.outputs.infra-workshop-tajiri-public-d.id,
    data.terraform_remote_state.vpc.outputs.infra-workshop-tajiri-private-a.id,
    data.terraform_remote_state.vpc.outputs.infra-workshop-tajiri-private-c.id,
    data.terraform_remote_state.vpc.outputs.infra-workshop-tajiri-private-d.id
  ]

  infra-workshop_oidc_issuer = replace(aws_eks_cluster.infra-workshop.identity[0].oidc[0].issuer, "https://", "")
}

data "aws_kms_key" "infra-workshop-tajiri" {
  key_id = "alias/infra-workshop-tajiri"
}

data "aws_iam_role" "eks-role" {
  name = data.terraform_remote_state.iam.outputs.eks-role
}

data "aws_iam_role" "eks-node-instance-role" {
  name = data.terraform_remote_state.iam.outputs.eks-node-instance-role
}

resource "aws_eks_cluster" "infra-workshop" {
  name     = "infra-workshop-tajiri"
  version  = "1.21"
  role_arn = data.aws_iam_role.eks-role.arn

  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs     = ["0.0.0.0/0"]

    subnet_ids = local.infra_workshop_vpc_subnet_ids

    security_group_ids = [
      data.terraform_remote_state.vpc.outputs.sg_internal.id
    ]
  }

  encryption_config {
    resources = ["secrets"]

    provider {
      key_arn = data.aws_kms_key.infra-workshop-tajiri.arn
    }
  }

  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

  depends_on = [data.aws_iam_role.eks-role]
}

resource "aws_iam_openid_connect_provider" "infra-workshop-k8s" {
  url             = aws_eks_cluster.infra-workshop.identity[0].oidc[0].issuer
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da2b0ab7280"]
}

resource "aws_eks_node_group" "infra-workshop-general-t2-medium" {
  cluster_name    = aws_eks_cluster.infra-workshop.name
  node_group_name = "infra-workshop-general-t2-medium"
  node_role_arn   = data.aws_iam_role.eks-node-instance-role.arn
  subnet_ids = [
    data.terraform_remote_state.vpc.outputs.infra-workshop-tajiri-private-a.id,
    data.terraform_remote_state.vpc.outputs.infra-workshop-tajiri-private-c.id,
    data.terraform_remote_state.vpc.outputs.infra-workshop-tajiri-private-d.id
  ]
  disk_size     = 50
  capacity_type = "SPOT"
  instance_types = [
    "t2.medium"
  ]

  scaling_config {
    desired_size = 1
    max_size     = 10
    min_size     = 1
  }

  remote_access {
    ec2_ssh_key               = "tajiri_dev"
    source_security_group_ids = []
  }

  depends_on = [
    data.aws_iam_role.eks-node-instance-role
  ]

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}

data "template_file" "external-dns-infra-workshop" {
  # Reference: https://docs.aws.amazon.com/eks/latest/userguide/create-service-account-iam-policy-and-role.html
  template = file("${path.module}/policies/external-dns-trust.template.json")

  vars = {
    openid_connect_provider_arn = aws_iam_openid_connect_provider.infra-workshop-k8s.arn
    oidc_issuer                 = local.infra-workshop_oidc_issuer
  }
}

resource "aws_iam_role" "external-dns-infra-workshop" {
  name               = "InfraWorkshopKubernetesDNS"
  assume_role_policy = data.template_file.external-dns-infra-workshop.rendered
}

resource "aws_iam_role_policy" "external-dns-infra-workshop" {
  name   = "ExternalDNS"
  role   = aws_iam_role.external-dns-infra-workshop.name
  policy = file("policies/external-dns.json")
}

data "template_file" "cert-manager-infra-workshop" {
  template = file("${path.module}/policies/cert-manager-trust.template.json")

  vars = {
    openid_connect_provider_arn = aws_iam_openid_connect_provider.infra-workshop-k8s.arn
    oidc_issuer                 = local.infra-workshop_oidc_issuer
  }
}

resource "aws_iam_role" "cert-manager-infra-workshop" {
  name               = "InfraWorkshopCertManager"
  assume_role_policy = data.template_file.cert-manager-infra-workshop.rendered
}

resource "aws_iam_role_policy" "cert-manager-infra-workshop" {
  name   = "CertManager"
  role   = aws_iam_role.cert-manager-infra-workshop.name
  policy = file("policies/cert-manager.json")
}

