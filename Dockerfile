FROM python:3.10-slim

<<<<<<< HEAD
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

=======
# आवश्यक Linux packages
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    python3-dev \
    libopenblas-dev \
    liblapack-dev \
    && rm -rf /var/lib/apt/lists/*

# Precompiled dlib wheel install
RUN pip install --upgrade pip
RUN pip install https://github.com/datamagic2020/precompiled-dlib/raw/main/dlib-19.24.0-cp310-cp310-manylinux_2_17_x86_64.whl

# बाकी requirements
COPY requirements.txt .
RUN pip install -r requirements.txt

# App copy
COPY . /app
WORKDIR /app

>>>>>>> 17e88e56c5078803fd82e1db0c4ca41fbb88b0e7
CMD ["python", "app.py"]
