variable "project" {
  type = string
  default = "prj-1804-51958669-nsvc"
}

variable "region" {
  type = string
  default = "europe-west1"
}

variable "zone" {
  type = string
  default = "europe-west1-b"
}

variable "credentials" {
  type = string
  default = "../newdemo.json"
}

variable "instance-template-tf" {
  type = string
  default = "testtemplate"
}

variable "machine_type" {
  type = string
  default = "e2-micro"
}

variable "autohealing-healthcheck" {
  type = string
  default = "autohealing-health-check"
}

variable "instance-group-manager" {
  type = string
  default = "instance-group-manager"
}

variable "autoscaler" {
  type = string
  default = "autoscaler"
}

variable "vpc" {
  type = string
  default = "testvpc"
}

variable "subnet" {
  type = string
  default = "testsubnet"
}