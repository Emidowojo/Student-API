# Stage 1: Build dependencies
FROM python:3.13-slim AS builder
# Set working directory inside the container
WORKDIR /app
# Update package index separately to cache it
RUN apt-get update
# Install build tools and dependencies, then clean up
RUN apt-get install -y --no-install-recommends gcc && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*
# Copy requirements file
COPY requirements.txt .
# Install Python dependencies without cache
RUN pip install --no-cache-dir -r requirements.txt
# Explicitly install gunicorn to ensure binary is available
RUN pip install --no-cache-dir gunicorn==23.0.0

# Stage 2: Runtime image
FROM python:3.13-slim
# Set working directory
WORKDIR /app
# Copy installed dependencies from builder (site-packages and bin)
COPY --from=builder /usr/local/lib/python3.13/site-packages /usr/local/lib/python3.13/site-packages
COPY --from=builder /usr/local/bin/gunicorn /usr/local/bin/gunicorn
# Copy application code
COPY app/ ./app/
# Create non-root user for security
RUN useradd -m appuser && chown -R appuser:appuser /app
# Switch to non-root user
USER appuser
# Expose port 5000 for Flask
EXPOSE 5000
# Set environment variable for Flask
ENV FLASK_APP=app
# Run with gunicorn for production
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:create_app()"]