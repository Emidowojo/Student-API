# Define targets that aren't files
.PHONY: install run test docker-build docker-run

# Install dependencies
install:
	.venv/bin/pip install -r requirements.txt

# Run the app locally
run:
	flask run

# Run tests
test:
	.venv/bin/pytest -v

# Build Docker image with semantic version
docker-build:
	docker build -t student-api:1.0.0 .

# Run Docker container with environment variables
docker-run:
	docker run -d -p 5000:5000 --env-file .env student-api:1.0.0