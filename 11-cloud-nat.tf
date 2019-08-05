resource "google_compute_address" "nat-addr" {
    name = "${var.project}-nat-addr"
}

resource "google_compute_router" "router" {
    name    = "${var.project}-router"
    region  = var.region
    network = "${google_compute_network.private.name}"
    bgp {
        asn = 64514
    }
}

resource "google_compute_router_nat" "router-nat" {
    name                               = "${var.project}-nat-router"
    router                             = "${google_compute_router.router.name}"
    region                             = var.region
    nat_ip_allocate_option             = "MANUAL_ONLY"
    nat_ips                            = ["${google_compute_address.nat-addr.self_link}"]
    source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}
