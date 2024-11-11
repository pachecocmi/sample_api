# Laravel API, MariaDB, and phpMyAdmin Docker Setup

This is a Docker-based setup for running a Laravel API, a MariaDB database, and a phpMyAdmin interface.

## Prerequisites

- Docker and Docker Compose installed on your system.

## Installation

1. Clone the repository to your local machine:

   ```
   git clone https://github.com/your-username/your-project.git
   ```

2. Navigate to the project directory:

   ```
   cd your-project
   ```

3. Build and start the Docker containers:

   ```
   docker-compose up -d --build
   ```

   This will build the Docker images and start the containers in detached mode.

4. Once the containers are running, you can access the following services:

   - Laravel API: `http://localhost:8000`
   - phpMyAdmin: `http://localhost:8001`

   The default phpMyAdmin credentials are:
   - Username: `root`
   - Password: `password`

## Usage

With this setup, you can develop your Laravel API-based application and interact with the database using phpMyAdmin.

- To stop the containers, run:

  ```
  docker-compose down
  ```

- To start the containers again, run:

  ```
  docker-compose up -d
  ```

- To view the logs of a specific container, run:

  ```
  docker logs -f container-name
  ```

  Replace `container-name` with the name of the container you want to view the logs for (e.g., `laravel-api`, `laravel-db`, or `laravel-phpmyadmin`).

## Customization

You can customize the setup by modifying the `docker-compose.yml` and `Dockerfile` files. For example, you can change the database credentials, add additional services, or modify the PHP and Apache configurations.

## Deployment

When you're ready to deploy your application, you can either:

1. Use the same Docker Compose setup on your production server.
2. Build a production-ready Docker image and deploy it to a container platform like AWS ECS, Google Cloud Run, or your own Kubernetes cluster.

Make sure to update the environment variables and any other necessary configurations for your production environment.

## License

This project is licensed under the [MIT License](LICENSE).
