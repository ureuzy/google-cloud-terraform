#resource "google_compute_instance" "default" {
#  name         = "flask-vm"
#  machine_type = "e2-micro"
#  zone         = "${var.region}-a"
#  tags         = ["ssh", "flask"]
#
#  boot_disk {
#    initialize_params {
#      image = "debian-cloud/debian-11"
#    }
#  }
#
#  # Install Flask
#  metadata_startup_script = "sudo apt-get update; sudo apt-get install -yq build-essential python3-pip rsync; pip install flask"
#
#  network_interface {
#    subnetwork = google_compute_subnetwork.default.id
#
#    access_config {
#      # Include this section to give the VM an external IP address
#    }
#  }
#}
#
#resource "google_compute_firewall" "ssh" {
#  name    = "allow-ssh"
#  network = google_compute_network.vpc_network.id
#  allow {
#    ports    = ["22"]
#    protocol = "tcp"
#  }
#  direction     = "INGRESS"
#  priority      = 1000
#  source_ranges = ["0.0.0.0/0"]
#  target_tags   = ["ssh"]
#}
#
#resource "google_compute_firewall" "flask" {
#  name    = "flask-app-firewall"
#  network = google_compute_network.vpc_network.id
#  allow {
#    protocol = "tcp"
#    ports    = ["5000"]
#  }
#  source_ranges = ["0.0.0.0/0"]
#  target_tags   = ["flask"]
#}