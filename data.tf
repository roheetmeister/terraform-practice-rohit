# Declare the data source
#Terraform uses data sources to fetch information from cloud provider APIs, such as disk image IDs, or information about the rest of your infrastructure through the outputs of other Terraform configurations.
data "aws_availability_zones" "available" {
  state = "available"

}
