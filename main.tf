##############################################################################
# IBM Cloud Provider
##############################################################################

provider ibm {
  region           = var.region
  ibmcloud_timeout = 60 // Timeout for API operations in seconds.
}

##############################################################################
# Resource Group where VPC Resources Will Be Created
##############################################################################

resource ibm_resource_group resource_group {
  name = var.resource_group
  tags = var.tags

}

##############################################################################
# Create VPC
##############################################################################

resource "ibm_is_vpc" "vpc" {
  name           = "${var.prefix}-vpc"
  resource_group = ibm_resource_group.resource_group.id
  tags           = var.tags
}

resource "ibm_is_subnet" "subnet1" {
  name            = "${var.prefix}-subnet1"
  vpc             = ibm_is_vpc.vpc.id
  zone            = var.zone1
  ipv4_cidr_block = "10.240.0.0/24"
  resource_group  = ibm_resource_group.resource_group.id
  tags            = var.tags
}

##############################################################################
# Create VSI in your VPC
##############################################################################

// create an SSH Key
resource "ibm_is_ssh_key" "ssh_key" {
  name           = "${var.prefix}-sshkey"
  public_key     = var.public_key
  resource_group = ibm_resource_group.resource_group.id

}

// retrieve VSI image details
data "ibm_is_image" "ubuntu" {
  name = "ibm-ubuntu-18-04-1-minimal-amd64-2"
}

// create VSI instance
resource "ibm_is_instance" "vsi1" {
  name           = "${var.prefix}-vsi1"
  vpc            = ibm_is_vpc.vpc.id
  zone           = var.zone1
  keys           = [ibm_is_ssh_key.ssh_key.id]
  image          = data.ibm_is_image.ubuntu.id
  profile        = "cx2-2x4"
  resource_group = ibm_resource_group.resource_group.id
  tags           = var.tags


  primary_network_interface {
    subnet               = ibm_is_subnet.subnet1.id
    primary_ipv4_address = "10.240.0.6"
    # allow_ip_spoofing = true
  }

  # network_interfaces {
  #   name   = "eth1"
  #   subnet = ibm_is_subnet.subnet1.id
  #   # allow_ip_spoofing = false
  # }

  //User can configure timeouts
  timeouts {
    create = var.create_timeout
    update = "15m"
    delete = "15m"
  }

}

// create floating IP to associate with Virtual Servers for VPC instance.
resource "ibm_is_floating_ip" "fip1" {
  name           = "${var.prefix}-fip1"
  target         = ibm_is_instance.vsi1.primary_network_interface[0].id
  resource_group = ibm_resource_group.resource_group.id
  tags           = var.tags
}





