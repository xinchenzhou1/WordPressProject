resource "aws_efs_file_system" "word-press-efs-system" {
  creation_token = "word-press-efs-system"
  encrypted = false
  throughput_mode = "elastic"

  tags = {
    Name: "${var.env_prefix}-efs-file-system"
  }
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }
}
resource "aws_efs_mount_target" "word-press-mount-target-az1" {
  file_system_id = aws_efs_file_system.word-press-efs-system.id
  subnet_id      = var.app_subnet_1_id
  security_groups = [var.efs_sg_id]
}
resource "aws_efs_mount_target" "word-press-mount-target-az2" {
  file_system_id = aws_efs_file_system.word-press-efs-system.id
  subnet_id      = var.app_subnet_2_id
  security_groups = [var.efs_sg_id]
}
resource "aws_efs_backup_policy" "policy" {
  file_system_id = aws_efs_file_system.word-press-efs-system.id

  backup_policy {
    status = "DISABLED"
  }
}