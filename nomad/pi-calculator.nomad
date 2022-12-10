job "pi-calculator" {
  datacenters = ["europe-west1-b", "europe-west1-c"]

  group "nl.peterpopma" {
    count = 1

    scaling {
      enabled = true
      min     = 1
      max     = 8

      policy {
        evaluation_interval = "2s"
        cooldown            = "5s"

        check "cpu_usage" {
          source = "prometheus"
          query  = "avg(nomad_client_allocs_cpu_total_percent{task='server'})"
          strategy "target-value" {
            target = 25
          }
        }
      }
    }

    network {
      port "http" {
        to = 8080
      }
    }

    service {
      name = "pi-calculator"
      port = "http"
      check {
        type     = "http"
        path     = "/actuator/health"
        interval = "2s"
        timeout  = "1s"
      }
    }

    task "server" {
      env {
        PORT    = "${NOMAD_PORT_http}"
        NODE_IP = "${NOMAD_IP_http}"
      }

      resources {
        cpu    = 200
        memory = 128
      }

      driver = "docker"

      config {
        image = "peterpopma/pi-calculator:latest"
        ports = ["http"]
      }
    }
  }
}
