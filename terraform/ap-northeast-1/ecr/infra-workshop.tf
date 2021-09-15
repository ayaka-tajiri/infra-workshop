# Elastic ContainerRegistryリポジトリを提供します。
resource "aws_ecr_repository" "infra-workshop-front-oharu" {
  # 必須
  name = "infra-workshop-front-oharu"

  #任意。リポジトリのタグ可変性設定。 デフォルトはMUTABLEです
  image_tag_mutability = "MUTABLE"

  # リポジトリのイメージスキャン構成を定義する構成ブロック。
  # デフォルトでは、画像スキャンは手動でトリガーする必要があります
  image_scanning_configuration {
    scan_on_push = true
  }

  # リポジトリの暗号化構成
  encryption_configuration {
    encryption_type = "AES256"
  }
}
