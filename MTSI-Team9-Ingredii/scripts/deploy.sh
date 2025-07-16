#!/bin/bash
# Deploy the FastAPI backend
uvicorn api.main:app --host 0.0.0.0 --port 8000 --app-dir ../software/backend/src
