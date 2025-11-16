# Use official Python runtime as parent image
FROM python:3.10-slim

# Set working directory
WORKDIR /app

# Install OS dependencies for dlib / face-recognition / opencv
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        cmake \
        libopenblas-dev \
        liblapack-dev \
        libx11-dev \
        libgtk2.0-dev && \
    rm -rf /var/lib/apt/lists/*

# Copy requirements file first (for better build caching)
COPY requirements.txt .

# Upgrade pip and install Python dependencies
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Copy all application files
COPY . .

# Expose port (Flask default)
EXPOSE 5000

# Use gunicorn to run the Flask app
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]

