# For AWS managed cluster
resource "aws_iam_role" "eks" {
  name               = "AmazonEKSRole"
  assume_role_policy = file("policies/eks-trust.json")
}

resource "aws_iam_policy" "eks-sts" {
  name        = "EKSStsAssumeRolePolicy"
  path        = "/"
  description = "Enable EKS to assume other resources when accessing AWS APIs"
  policy      = file("policies/eks-sts.json")
}

resource "aws_iam_role_policy_attachment" "eks-cluster-policy" {
  role       = aws_iam_role.eks.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks-service-policy" {
  role       = aws_iam_role.eks.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}

resource "aws_iam_role_policy_attachment" "eks-sts" {
  role       = aws_iam_role.eks.name
  policy_arn = aws_iam_policy.eks-sts.arn
}

output "eks-role" {
  value = aws_iam_role.eks.name
}

# For AWS managed node groups
resource "aws_iam_role" "eks-node-instance" {
  name               = "NodeInstanceRole"
  assume_role_policy = file("policies/eks-node-instance-trust.json")
}

resource "aws_iam_role_policy_attachment" "eks-worker-node-policy" {
  role       = aws_iam_role.eks-node-instance.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks-cni" {
  role       = aws_iam_role.eks-node-instance.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "ec2-container-registry-readonly" {
  role       = aws_iam_role.eks-node-instance.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "eks-secretsmanager-readonly" {
  role       = aws_iam_role.eks-node-instance.name
  policy_arn = aws_iam_policy.secretsmanager-read-only.arn
}

output "eks-node-instance-role" {
  value = aws_iam_role.eks-node-instance.name
}

