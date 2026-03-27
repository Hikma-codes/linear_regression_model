# prediction.py
import io
import warnings
import numpy as np
import joblib
from pydantic import BaseModel, Field
from fastapi.middleware.cors import CORSMiddleware
from fastapi import FastAPI, HTTPException, UploadFile, File
import pandas as pd
from sklearn.linear_model import LinearRegression
from sklearn.preprocessing import StandardScaler

# Load your trained model and scaler
model = joblib.load("best_model.pkl")
scaler = joblib.load("scaler.pkl")

app = FastAPI(
    title="FastAPI",
    description="Predict Skill Application scores and retrain the model with new data.",
    version="1.0.0"
)

#  CORS Middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost",
        "http://localhost:50427",
        "http://localhost:62944",
    ],


    allow_credentials=True,
    allow_methods=["GET", "POST"],
    allow_headers=["Content-Type", "Authorization", "Accept"],
)


# Input schema (no Skill_Application — that is what we predict)


class InputData(BaseModel):
    Age: int = Field(..., ge=0, le=100)
    Basic_Computer_Knowledge_Score: float = Field(..., ge=0, le=100)
    Internet_Usage_Score: float = Field(..., ge=0, le=100)
    Mobile_Literacy_Score: float = Field(..., ge=0, le=100)
    Post_Training_Basic_Computer_Knowledge_Score: float = Field(
        ..., ge=0, le=100)
    Post_Training_Internet_Usage_Score: float = Field(..., ge=0, le=100)
    Post_Training_Mobile_Literacy_Score: float = Field(..., ge=0, le=100)
    Modules_Completed: int = Field(..., ge=0, le=10)
    Average_Time_Per_Module: float = Field(..., ge=0, le=100)
    Quiz_Performance: float = Field(..., ge=0, le=100)
    Session_Count: int = Field(..., ge=0, le=500)
    Adaptability_Score: float = Field(..., ge=0, le=100)
    Feedback_Rating: float = Field(..., ge=0, le=5)


#  Feature order must match what the scaler was trained on
FEATURE_COLS = [
    "Age",
    "Basic_Computer_Knowledge_Score",
    "Internet_Usage_Score",
    "Mobile_Literacy_Score",
    "Post_Training_Basic_Computer_Knowledge_Score",
    "Post_Training_Internet_Usage_Score",
    "Post_Training_Mobile_Literacy_Score",
    "Modules_Completed",
    "Average_Time_Per_Module",
    "Quiz_Performance",
    "Session_Count",
    "Adaptability_Score",
    "Feedback_Rating",
]
TARGET_COL = "Skill_Application"


# /predict
@app.post("/predict", summary="Predict Skill Application score")
def predict(data: InputData):
    """
    Submit learner metrics and receive a predicted **Skill_Application** score.
    `Skill_Application` is NOT an input — it is the value being predicted.
    """
    input_array = np.array([[getattr(data, col) for col in FEATURE_COLS]])

    input_scaled = scaler.transform(input_array)
    prediction = model.predict(input_scaled)

    return {
        "predicted_Skill_Application": round(float(prediction[0]), 4)
    }


#  /retrain
@app.post("/retrain", summary="Retrain model with a new CSV dataset")
async def retrain(file: UploadFile = File(..., description="CSV file containing training data")):
    """
    Upload a CSV file with the same columns as the original dataset.
    The model and scaler will be updated and saved to disk.
    """
    global model, scaler

   
