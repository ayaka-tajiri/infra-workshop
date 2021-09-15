
locals {
  # vpcのpublicでoutputしている値をこうやって呼び出せる？
  # ローカルバリュー
  infra_workshop_vpc_subnet_ids = [
    data.terraform_remote_state.vpc.outputs.infra-workshop-oharu-public-a.id,
    data.terraform_remote_state.vpc.outputs.infra-workshop-oharu-public-c.id,
    data.terraform_remote_state.vpc.outputs.infra-workshop-oharu-public-d.id,
    data.terraform_remote_state.vpc.outputs.infra-workshop-oharu-private-a.id,
    data.terraform_remote_state.vpc.outputs.infra-workshop-oharu-private-c.id,
    data.terraform_remote_state.vpc.outputs.infra-workshop-oharu-private-d.id
  ]

  # これはなんだ！
  infra-workshop_oidc_issuer = replace(aws_eks_cluster.infra-workshop.identity[0].oidc[0].issuer, "https://", "")
}

# このデータソースを使用して、柔軟なキーID入力で指定されたKMSキーに関する詳細情報を取得します。
# これは、入力としてARNをハードコーディングしなくても、キーエイリアスを参照するのに役立ちます。
# KMSキーってなんだ...！
data "aws_kms_key" "infra-workshop-oharu" {
  key_id = "alias/infra-workshop-oharu"
}

# 特定のIAMロールに関する情報をフェッチする
data "aws_iam_role" "eks-role" {
  name = data.terraform_remote_state.iam.outputs.eks-role
}

# 特定のIAMロールに関する情報をフェッチする
data "aws_iam_role" "eks-node-instance-role" {
  name = data.terraform_remote_state.iam.outputs.eks-node-instance-role
}

# EKSクラスターを管理する
# 一番大枠の概念。箱。VPCみたいなの
# クーバネーテスクラスターの中にノードが複数ある
# ノードがサーバー。クーブレットがコントロールしている。
# ノードの中にPodが複数ある
resource "aws_eks_cluster" "infra-workshop" {
  name     = "infra-workshop-oharu"
  version  = "1.21"
  # eksだったこのロール使っていいよ！
  role_arn = data.aws_iam_role.eks-role.arn

  # 必須。クラスターに関連付けられたVPCの構成ブロック。 Amazon EKS VPCリソースには、Kubernetesと適切に連携するための特定の要件があります
  # ネットワークの設定。どこにnodeを立てるか説明する。EC2の言語で説明する
  # AWSのサービスでもあるけどEC2の中にもある
  # コントロールプレインがどこに繋ぐための設定？？？
  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs     = ["0.0.0.0/0"]

    # EKSのクラスタのシステムノードをどこに設定するか？
    # プライベートパブリック両方含むものを設定する必要がある
    subnet_ids = local.infra_workshop_vpc_subnet_ids

    security_group_ids = [
      data.terraform_remote_state.vpc.outputs.sg_internal.id
    ]
  }

  # 暗号化構成ブロック。シークレットの暗号化設定
  encryption_config {
    resources = ["secrets"]

    provider {
      key_arn = data.aws_kms_key.infra-workshop-oharu.arn
    }
  }

  # ログタイプ
  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

  depends_on = [data.aws_iam_role.eks-role]
}

# IAM OpenIDConnectプロバイダー
# 本人認証認可のしくみ。2つの世界の認証情報がある
# クーバネーテスの認証情報
# AWS側の認証情報
# AWS側の認証情報をクーバネティスの認証情報に橋渡しをする必要がある。（EKSが一貫して発行する）
# 関連するロールでもこれを使う必要がある
# プロバイダーとイシュアーの2つがある
resource "aws_iam_openid_connect_provider" "infra-workshop-k8s" {
  url             = aws_eks_cluster.infra-workshop.identity[0].oidc[0].issuer
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da2b0ab7280"]
}

# EKSノードグループを管理します。
# EKSノードグループは、EKSと互換性のあるKubernetesワーカーノードの自動スケーリンググループをプロビジョニングし、オプションで更新できます
# ノードがどのくらい必要なの？インスタンスタイプは？など
resource "aws_eks_node_group" "infra-workshop-general-t2-medium" {
  cluster_name    = aws_eks_cluster.infra-workshop.name
  # ノードグループごとに名前をつけれる？
  node_group_name = "infra-workshop-general-t2-medium"
  # ノードが実行する諸々のオペレーションをこのロールで動かす
  # EKSからのimage取得、新規のノードの立ち上げ
  node_role_arn   = data.aws_iam_role.eks-node-instance-role.arn
  # ノードは外部から接続する必要がないから、プライベートサブネット
  subnet_ids = [
    data.terraform_remote_state.vpc.outputs.infra-workshop-oharu-private-a.id,
    data.terraform_remote_state.vpc.outputs.infra-workshop-oharu-private-c.id,
    data.terraform_remote_state.vpc.outputs.infra-workshop-oharu-private-d.id
  ]

  # AWSの実際のインスタンスの設定が入る
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

  # キーペアは手動でec2に作成
  remote_access {
    ec2_ssh_key               = "oharu_dev"
    source_security_group_ids = []
  }

  # このリソースを評価する前に、depends_on を評価してね？
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

  # OpenIDの認証情報管理はAWSで一元化しているよ
  vars = {
    openid_connect_provider_arn = aws_iam_openid_connect_provider.infra-workshop-k8s.arn
    oidc_issuer                 = local.infra-workshop_oidc_issuer
  }
}

resource "aws_iam_role" "external-dns-infra-workshop" {
  name               = "oharuInfraWorkshopKubernetesDNS"
  assume_role_policy = data.template_file.external-dns-infra-workshop.rendered
}

resource "aws_iam_role_policy" "external-dns-infra-workshop" {
  name   = "oharuExternalDNS"
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
  name               = "oharuInfraWorkshopCertManager"
  assume_role_policy = data.template_file.cert-manager-infra-workshop.rendered
}

resource "aws_iam_role_policy" "cert-manager-infra-workshop" {
  name   = "oharuCertManager"
  role   = aws_iam_role.cert-manager-infra-workshop.name
  policy = file("policies/cert-manager.json")
}
