# Linear-Regression Summative

**Mission:** Educate and empower the youth in underserved communities to recoginze the tranformatve power of tecnology.

**Problem:** Predict the impact of digital literacy training on learners’ income after training.  

**Dataset:** Digital Literacy Education Dataset from Kaggle -link - [https://www.kaggle.com/datasets/ziya07/digital-literacy-education-dataset?resource=download]

**The goal** is to build linear regression, decision tree, and random forest models to predict income outcomes.

Live API
Base URL: [https://linear-regression-model-ovfh.onrender.com]
Swagger UI (interactive docs): [https://linear-regression-model-ovfh.onrender.com/docs]
Endpoints
MethodPathDescriptionPOST/predictReturns predicted Skill_Application scorePOST/retrainUpload a CSV to retrain the model
Example /predict request body
json{
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

🎥 Video Demo
[https://youtu.be/TViAELn27pQ]


 Repository Structure
linear_regression_model/
│
├── summative/
│   ├── linear_regression/
│   │   └── multivariate.ipynb        # Model training notebook
│   │
│   ├── API/
│   │   ├── prediction.py             # FastAPI app
│   │   ├── best_model.pkl            # Trained model
│   │   ├── scaler.pkl                # Feature scaler
│   │   └── requirements.txt
│   │
│   └── FlutterApp/
│       ├── lib/
│       │   ├── main.dart             # App entry point
│       │   └── prediction_page.dart  # Prediction UI + API call
│       └── pubspec.yaml

Running the Flutter App
Prerequisites

Flutter SDK ≥ 3.0.0
An Android emulator, iOS simulator, or physical device connected

Steps
bash# 1. Navigate to the Flutter app folder
cd summative/FlutterApp

# 2. Install dependencies
flutter pub get

# 3. Run on a connected device or emulator
flutter run

The app targets the live Render API by default [https://linear-regression-model-ovfh.onrender.com]
No additional configuration is needed.

Building a release APK (Android)
bashflutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk

Running the API Locally
bashcd summative/API
pip install -r requirements.txt
uvicorn prediction:app --reload
# Visit: http://127.0.0.1:8000/docs
|   |   |-- StudentPerformanceFactors.csv
