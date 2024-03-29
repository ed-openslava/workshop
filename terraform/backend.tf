terraform {
  backend "http" {
  }
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

# Pulls the image
resource "docker_image" "pizza-api" {
  name = "schroom/pizza-api"
}

# Create a container
resource "docker_container" "pizza-api" {
  image    = docker_image.pizza-api.image_id
  name     = "openslava-pizza-api"
  must_run = false

  ports {
    internal = 3000
    external = 3000
  }

}
