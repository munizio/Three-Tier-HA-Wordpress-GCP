output "lb_address" {
  value = "${google_compute_address.public.address}"
}
