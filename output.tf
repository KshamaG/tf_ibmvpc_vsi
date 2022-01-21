output vpc_id {
  description = "ID of VPC created"
  value       = ibm_is_vpc.vpc.id
}

output subnet1_id {
  description = "The IDs of the subnet"
  value       = ibm_is_subnet.subnet1.id
}

output vsi_instance_crn {
  description = "The CRN of the VSI instance"
  value       = ibm_is_instance.vsi1.crn
}

output vsi_associated_vpc {
  description = "The ID of the VPC that the instance belongs to"
  value       = ibm_is_instance.vsi1.vpc
}

