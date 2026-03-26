# prediction.py
import warnings
import numpy as np
import joblib
from pydantic import BaseModel, Field
from fastapi.middleware.cors import CORSMiddleware
from fastapi import FastAPI

warnings.filterwarnings("ignore", category=UserWarning)

# Create app ONCE
app = FastAPI()

# CORS setup
origins = [
    "http://localhost",
    "http://127.0.0.1",
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["POST"],
    allow_headers=["*"],
)

# Load model + scaler
model = joblib.load("best_model.pkl")
scaler = joblib.load("scaler.pkl")

# Input schema


class InputData(BaseModel):
    Age: int = Field(..., ge=0, le=100)
    Basic_Computer_Knowledge_Score: float = Field(..., ge=0, le=100)
    Internet_Usage_Score: float = Field(..., ge=0, le=100)
    Mobile_Literacy_Score: float = Field(..., ge=0, le=100)
    Post_Training_Basic_Computer_Knowledge_Score: float = Field(
        ..., ge=0, le=100)
    Post_Training_Internet_Usage_Score: float = Field(..., ge=0, le=100)
    Post_Training_Mobile_Literacy_Score: float = Field(..., ge=0, le=100)
    Modules_Completed: int = Field(..., ge=0, le=100)
    Average_Time_Per_Module: float = Field(..., ge=0, le=100)
    Quiz_Performance: float = Field(..., ge=0, le=100)
    Session_Count: int = Field(..., ge=0, le=500)
    Adaptability_Score: float = Field(..., ge=0, le=100)
    Feedback_Rating: float = Field(..., ge=0, le=5)
    Skill_Application: float = Field(..., ge=0, le=100)

# Predict endpoint


@app.post("/predict")
def predict(data: InputData):
    input_array = np.array([[
        data.Age,
        data.Basic_Computer_Knowledge_Score,
        data.Internet_Usage_Score,
        data.Mobile_Literacy_Score,
        data.Post_Training_Basic_Computer_Knowledge_Score,
        data.Post_Training_Internet_Usage_Score,
        data.Post_Training_Mobile_Literacy_Score,
        data.Modules_Completed,
        data.Average_Time_Per_Module,
        data.Quiz_Performance,
        data.Session_Count,
        data.Adaptability_Score,
        data.Feedback_Rating,
        data.Skill_Application
    ]])

    input_scaled = scaler.transform(input_array)
    prediction = model.predict(input_scaled)

    return {"prediction": float(prediction[0])}

# Retrain endpoint


@app.post("/retrain")
def retrain():
    return {"message": "Model retraining triggered successfully"}
