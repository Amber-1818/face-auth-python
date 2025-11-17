from flask import Flask, request, jsonify
import cv2
import numpy as np
import base64
from io import BytesIO
from PIL import Image

app = Flask(__name__)

# OpenCV HaarCascade (Render safe)
face_cascade = cv2.CascadeClassifier(
    cv2.data.haarcascades + 'haarcascade_frontalface_default.xml'
)

def get_embedding(face):
    # Resize to fixed 112x112
    face = cv2.resize(face, (112, 112))
    face = face.astype(np.float32) / 255.0
    face = (face - 0.5) / 0.5

    embedding = []
    for i in range(16):
        for j in range(16):
            block = face[i * 7:(i + 1) * 7, j * 7:(j + 1) * 7]
            if block.size > 0:
                embedding.append(np.mean(block))

    embedding = embedding[:512]
    embedding = np.array(embedding)

    # Normalize to unit vector
    norm = np.linalg.norm(embedding)
    if norm > 0:
        embedding = embedding / norm

    return embedding.tolist()

@app.route('/api/process_face', methods=['POST'])
def process_face():
    try:
        data = request.get_json()
        base64_str = data['image'].split(',')[1]

        img_data = base64.b64decode(base64_str)
        img = Image.open(BytesIO(img_data)).convert('RGB')

        img_bgr = cv2.cvtColor(np.array(img), cv2.COLOR_RGB2BGR)
        gray = cv2.cvtColor(img_bgr, cv2.COLOR_BGR2GRAY)

        faces = face_cascade.detectMultiScale(
            gray, 
            scaleFactor=1.3,
            minNeighbors=5,
            minSize=(80, 80)
        )

        if len(faces) == 0:
            return jsonify({"success": False, "error": "No face"}), 400

        x, y, w, h = faces[0]
        face = img_bgr[y:y+h, x:x+w]

        emb = get_embedding(face)

        return jsonify({"success": True, "embedding": emb})

    except Exception as e:
        return jsonify({"success": False, "error": str(e)}), 500


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
