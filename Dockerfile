FROM python:3.10-slim

WORKDIR /app

# System dependencies required for face-recognition & dlib
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    libopenblas-dev \
    liblapack-dev \
    libjpeg-dev \
    python3-dev \
    git \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip
RUN pip install --upgrade pip

# Install precompiled dlib wheel (FAST, no compiling)
RUN pip install https://github.com/wang-bin/prebuilt-dlib/raw/master/dlib-19.24.0-cp310-cp310-manylinux_2_17_x86_64.whl

# Install remaining requirements
COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .

CMD ["python", "app.py"]
