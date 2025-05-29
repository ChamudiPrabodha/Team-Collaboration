from flask import Flask, request, jsonify 
from tensorflow.keras.models import load_model 
from tensorflow.keras.preprocessing.image import img_to_array 
from PIL import Image
import numpy as np 
import io
import os

app = Flask(__name__)

# Load your trained model (update path)
model = load_model(r'C:\Users\Sanjana Yapa\Desktop\Govi Arana\AI\plant_disease_model_2_classes.h5')

# Define your class labels (update accordingly)
CLASS_NAMES = [
    'Pepper__bell___Bacterial_spot', 'Pepper__bell___healthy',
    'Potato___Early_blight','Potato___Late_blight','Potato___healthy',
    'Tomato_Bacterial_spot','Tomato_Early_blight','Tomato_Late_blight',
    'Tomato_Leaf_Mold','Tomato_Septoria_leaf_spot',
    'Tomato_Spider_mites_Two_spotted_spider_mite','Tomato__Target_Spot',
    'Tomato__Tomato_YellowLeaf__Curl_Virus','Tomato__Tomato_mosaic_virus',
    'Tomato_healthy',
]

def preprocess_image(image_bytes):
    img = Image.open(io.BytesIO(image_bytes)).convert('RGB')
    print(f"[DEBUG] Image size: {img.size}, mode: {img.mode}")  # Debugging image info
    img = img.resize((150, 150))  # match your model input size
    img_array = img_to_array(img) / 255.0  # normalize to [0,1]
    img_array = np.expand_dims(img_array, axis=0)  # batch dimension
    return img_array

@app.route('/predict', methods=['POST'])
def predict():
    if 'image' not in request.files:
        return jsonify({'error': 'No image provided'}), 400
    
    image_file = request.files['image']
    print(f"[DEBUG] Received file: {image_file.filename}, size: {image_file.content_length}")
    
    # Optional: Save uploaded image for manual verification
    temp_path = os.path.join('temp_uploads', image_file.filename)
    os.makedirs('temp_uploads', exist_ok=True)
    image_file.save(temp_path)
    print(f"[DEBUG] Saved uploaded image to {temp_path}")
    
    # Read bytes again from saved file (to ensure consistency)
    with open(temp_path, 'rb') as f:
        img_bytes = f.read()
    
    try:
        processed_img = preprocess_image(img_bytes)
        preds = model.predict(processed_img)
        print(f"[DEBUG] Raw model predictions: {preds}")  # Print prediction vector
        
        pred_index = np.argmax(preds, axis=1)[0]
        pred_label = CLASS_NAMES[pred_index]
        confidence = float(np.max(preds))
        
        return jsonify({
            'prediction': pred_label,
            'confidence': confidence
        })
    except Exception as e:
        print(f"[ERROR] Exception during prediction: {e}")
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True, port=8080)
