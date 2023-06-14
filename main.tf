resource "google_compute_instance_template" "template" {
  name = var.instance-template-tf
  machine_type = var.machine_type
  region = var.region
  can_ip_forward = false

  disk {
    source_image = "debian-cloud/debian-11"
    auto_delete = true
    boot = true
  }
  network_interface {
    network = "default"
    access_config {
    }

  }
  lifecycle {
    create_before_destroy = true
  }
  scheduling {
    automatic_restart = true
    on_host_maintenance = "MIGRATE"
  }

  metadata_startup_script = file("./startup_script.sh")

  service_account {
    email = "132520307301-compute@developer.gserviceaccount.com"
    scopes = ["cloud-platform"]
  
  }

  tags = ["http-server" , "https-server"]
}

resource "google_compute_firewall" "allowhttp" {
  project = var.project
  name = "allow-http-rule"
  network = "default"
  allow {
    protocol = "tcp"
    ports = ["80" , "8080" , "1000-2000"]
  }
  target_tags = ["http-server" , "https-server"]
  source_ranges = ["0.0.0.0/0"]
}

#resource "google_compute_firewall" "allowhealthcheck" {
#  project = var.project
 # name = "allow-health-check"
  #network = google_compute_network.vpc.id
  #allow {
   # protocol = "tcp"
    #ports = ["80" , "8080" , "443"]
  #}
  #target_tags = ["http-server" , "https-server"]
 # source_ranges = ["130.211.0.0/22" , "35.191.0.0/16"]
#}

resource "google_compute_health_check" "healthcheck" {
  name = var.autohealing-healthcheck
  check_interval_sec = 5
  timeout_sec = 5
  healthy_threshold = 2
  unhealthy_threshold = 10

  http_health_check {
    request_path = "/"
    port = "80"
  }
}

resource "google_compute_instance_group_manager" "instancegroup" {
  name = var.instance-group-manager
  zone = var.zone
  base_instance_name = "instance-group-tf"
  version {
    name = var.instance-template-tf
    instance_template = google_compute_instance_template.template.id
  }
  named_port {
    name = "web"
    port = 80
  }

  auto_healing_policies {
    health_check = google_compute_health_check.healthcheck.id
    initial_delay_sec = 300
  }
}

resource "google_compute_autoscaler" "autoscaler" {
 name = var.autoscaler
  zone = var.zone
  target = google_compute_instance_group_manager.instancegroup.id

  autoscaling_policy {
    min_replicas = 2
    max_replicas = 3
    cooldown_period = 60

  }
}