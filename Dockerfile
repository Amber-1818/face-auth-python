FROM python:3.10-slim

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

CMD ["python", "app.py"]
