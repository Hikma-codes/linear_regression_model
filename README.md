 **Linear Regression Summative**
 Mission

Educate and empower youth in underserved communities to recognize the transformative power of technology.

 Problem

Predict the impact of digital literacy training on learners’ income after training.

 Dataset

Digital Literacy Education Dataset (Kaggle):
https://www.kaggle.com/datasets/ziya07/digital-literacy-education-dataset?resource=download

 Goal

Build and compare three machine learning models:

Linear Regression
Decision Tree
Random Forest

The goal is to predict income outcomes based on digital literacy training data.

 Live API
Base URL:
https://linear-regression-model-ovfh.onrender.com
Swagger UI (Interactive Docs):
https://linear-regression-model-ovfh.onrender.com/docs
🔗 API Endpoints
POST /predict

Returns predicted Skill_Application score

POST /retrain

Uploads a CSV file to retrain the model

 Example Request
/predict request body:
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
🎥 Video Demo

https://youtu.be/TViAELn27pQ

 Repository Structure
linear_regression_model/
│
├── summative/
│   │
│   ├── linear_regression/
│   │   └── multivariate.ipynb        # Model training notebook
│   │
│   ├── API/
│   │   ├── prediction.py             # FastAPI app
│   │   ├── best_model.pkl            # Trained model
│   │   ├── scaler.pkl                # Feature scaler
│   │   └── requirements.txt
│   │
│   ├── FlutterApp/
│   │   ├── lib/
│   │   │   ├── main.dart             # App entry point
│   │   │   └── prediction_page.dart  # Prediction UI + API calls
│   │   └── pubspec.yaml
│
└── StudentPerformanceFactors.csv     # Dataset used for training
 Running the Flutter App
 Prerequisites
Flutter SDK ≥ 3.0.0
Android emulator / iOS simulator / physical device
 Steps
# Navigate to Flutter app
cd summative/FlutterApp

# Install dependencies
flutter pub get

# Run the app
flutter run

 The app connects to the live Render API by default:
https://linear-regression-model-ovfh.onrender.com

 Build APK (Android)
flutter build apk --release

Output:

build/app/outputs/flutter-apk/app-release.apk
 Running the API Locally
cd summative/API

# Install dependencies
pip install -r requirements.txt

# Run server
uvicorn prediction:app --reload

Then open:
http://127.0.0.1:8000/docs

 How It Works
User enters data in the Flutter app
App sends request to FastAPI backend
Model processes the input
Prediction is generated
Result is returned and displayed
 Model Approach
Linear Regression → Simple baseline
Decision Tree → Captures patterns but may overfit
Random Forest → Best overall performance

Final model was selected based on lowest loss and better generalization.

 Challenges
API connection issues between Flutter and backend
CORS configuration
Model retraining errors
Managing deployment on Render
 Future Improvements
Improve UI/UX design
Add user progress tracking
Deploy mobile app publicly
Train with larger dataset for better accuracy
Author

Hikma Hamza
🔗 www.linkedin.com/in/hikmahamza

 Final Note

This project shows how machine learning can be applied in a real-world context to support digital literacy and economic empowerment.
