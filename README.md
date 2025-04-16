Student API
A simple REST API to manage student records.
Setup (Local)

Clone the repo: git clone <https://github.com/Emidowojo/Student-API.git>
Activate venv: source .venv/bin/activate
Install: make install
Run: make run

Setup (Docker)
Prerequisites

Docker installed (docker --version to check)

Build the Image
# Build with semantic version tag
make docker-build

Run the Container
# Run with environment variables
make docker-run

Example API Usage
# Add a student
curl -X POST http://localhost:5000/api/v1/students -H "Content-Type: application/json" -d '{"name": "Alice", "age": 20}'

Makefile Targets

make install: Install dependencies
make run: Run locally
make test: Run tests
make docker-build: Build Docker image
make docker-run: Run Docker container

