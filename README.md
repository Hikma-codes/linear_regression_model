# Linear Regression Summative

 **Predicting the impact of digital literacy training on learner outcomes using machine learning.**

---

## Mission

Educate and empower youth in underserved communities to recognize the transformative power of technology.

---

##  Problem Statement

Digital literacy training has the potential to improve economic outcomes for learners in underserved communities. This project builds and evaluates machine learning models to **predict the impact of digital literacy training on learners' income** based on pre- and post-training data.

---

##  Dataset

**Digital Literacy Education Dataset** — sourced from Kaggle
🔗 [View Dataset](https://www.kaggle.com/datasets/ziya07/digital-literacy-education-dataset?resource=download)

---

##  Models Built & Compared

| Model | Description |
|---|---|
| **Linear Regression** | Simple baseline model |
| **Decision Tree** | Captures non-linear patterns; may overfit |
| **Random Forest** | Best overall performance and generalization |

The final model was selected based on **lowest loss** and **best generalization** on unseen data.

---

##  Live API

| Resource | URL |
|---|---|
| **Base URL** | https://linear-regression-model-ovfh.onrender.com |
| **Swagger UI (Interactive Docs)** | https://linear-regression-model-ovfh.onrender.com/docs |

### Endpoints

#### `POST /predict`
Returns a predicted **Skill Application score** based on learner input data.

**Example request body:**
```json
{
  "Age": 25,
  "Basic_Computer_Knowledge_Score": 70.0,
  "Internet_Usage_Score": 65.0,
  "Mobile_Literacy_Score": 80.0,
  "Post_Training_Basic_Computer_Knowledge_Score": 85.0,
  "Post_Training_Internet_Usage_Score": 78.0,
  "Post_Training_Mobile_Literacy_Score": 90.0,
  "Modules_Completed": 10,
  "Average_Time_Per_Module": 2.5,
  "Quiz_Performance": 75.0,
  "Session_Count": 20,
  "Adaptability_Score": 88.0,
  "Feedback_Rating": 4.2
}
```

#### `POST /retrain`
Uploads a CSV file to retrain the model with new data.

---

## 🎥 Video Demo

🔗 [Watch on YouTube](https://youtu.be/TViAELn27pQ)

---

##  Repository Structure

```
linear_regression_model/
│
└── summative/
    │
    ├── linear_regression/
    │   └── multivariate.ipynb              # Model training & evaluation notebook
    │
    ├── API/
    │   ├── prediction.py                   # FastAPI application
    │   ├── best_model.pkl                  # Trained model (serialized)
    │   ├── scaler.pkl                      # Feature scaler (serialized)
    │   └── requirements.txt
    │
    ├── FlutterApp/
    │   ├── lib/
    │   │   ├── main.dart                   # App entry point
    │   │   └── prediction_page.dart        # Prediction UI + API integration
    │   └── pubspec.yaml
    │
    └── StudentPerformanceFactors.csv       # Dataset used for training
```

---

## 📱 Running the Flutter App

### Prerequisites
- Flutter SDK ≥ 3.0.0
- Android emulator, iOS simulator, or a physical device

### Steps

```bash
# Navigate to the Flutter app directory
cd summative/FlutterApp

# Install dependencies
flutter pub get

# Run the app
flutter run
```

The app connects to the live Render API by default:
`https://linear-regression-model-ovfh.onrender.com`

### Build Release APK (Android)

```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

---

##  Running the API Locally

```bash
cd summative/API

# Install dependencies
pip install -r requirements.txt

# Start the server
uvicorn prediction:app --reload
```

Then open the interactive docs at: `http://127.0.0.1:8000/docs`

---

##  How It Works

```
User enters data in the Flutter app
        ↓
App sends a POST request to the FastAPI backend
        ↓
Model processes and scores the input features
        ↓
Prediction is generated
        ↓
Result is returned and displayed in the app
```

---

##  Challenges

- API connection issues between the Flutter frontend and the FastAPI backend
- CORS configuration for cross-origin requests
- Model retraining errors during live updates
- Managing deployment stability on Render's free tier

---

##  Future Improvements

- [ ] Improve mobile UI/UX design
- [ ] Add user progress tracking across sessions
- [ ] Deploy the mobile app publicly (Play Store / App Store)
- [ ] Train with a larger dataset for improved prediction accuracy

---

## 👤 Author

**Hikma Hamza**
🔗 [LinkedIn](https://www.linkedin.com/in/hikmahamza)

---

##  Final Note

This project demonstrates how machine learning can be applied in a real-world context to support digital literacy initiatives and contribute to economic empowerment in underserved communities.
