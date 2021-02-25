data "digitalocean_database_cluster" "db_cluster" {
  name = "strapi-database-cluster-${var.environment}"
}

resource "digitalocean_app" "app_platform_strapi" {
  spec {
    name   = "strapi-demo"
    region = "sgp"

    database {
      cluster_name = "strapi-database-cluster-${var.environment}"
      name         = var.database_name
      engine       = "PG"
      version      = var.database_version
      production   = true
      db_name      = var.database_name
      db_user      = data.digitalocean_database_cluster.db_cluster.user
    }

    service {
      name               = "strapi-service"
      environment_slug   = "node-js"
      instance_size_slug = "basic-xxs"
      build_command      = "npm run build"
      run_command        = "npm run develop"
      http_port          = "8080"
      instance_count     = 1

      github {
        repo           = "sachirjn/strapi-demo"
        branch         = "master"
        deploy_on_push = true
      }
      routes {
        path = "/"
      }

      env {
        key   = "DATABASE_HOST"
        scope = "RUN_AND_BUILD_TIME"
        value = data.digitalocean_database_cluster.db_cluster.host
      }
      env {
        key   = "DATABASE_PORT"
        scope = "RUN_AND_BUILD_TIME"
        value = data.digitalocean_database_cluster.db_cluster.port
      }
      env {
        key   = "DATABASE_NAME"
        scope = "RUN_AND_BUILD_TIME"
        value = var.database_name
      }
      env {
        key   = "DATABASE_USERNAME"
        scope = "RUN_AND_BUILD_TIME"
        value = data.digitalocean_database_cluster.db_cluster.user
      }
      env {
        key   = "DATABASE_PASSWORD"
        scope = "RUN_AND_BUILD_TIME"
        value = data.digitalocean_database_cluster.db_cluster.password
      }
    }

  }
}
