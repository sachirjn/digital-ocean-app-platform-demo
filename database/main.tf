resource "digitalocean_database_cluster" "database_cluster" {
  name       = "strapi-database-cluster-${var.environment}"
  engine     = "pg"
  version    = var.database_version
  size       = "db-s-1vcpu-1gb"
  region     = var.region
  node_count = 1
}

resource "digitalocean_database_db" "postgres" {
  cluster_id = digitalocean_database_cluster.database_cluster.id
  name       = var.database_name
}

resource "digitalocean_project_resources" "project_resources" {
  project   = var.project_id
  resources = [digitalocean_database_cluster.database_cluster.urn]
}
