# Ingredii MVP

This repository contains a minimal proof of concept for the Ingredii project. The goal is to provide a lightweight skeleton demonstrating the major components:

- **Firmware** running on a microcontroller
- **Backend API** built with FastAPI
- **Scripts** for image preprocessing and model training
- **Documentation** outlining the concept and requirements

The project is not production ready but offers a starting point for experimentation.

## Usage

1. Install Python dependencies:
   ```bash
   python3 -m venv venv
   source venv/bin/activate
   pip install -r software/backend/requirements.txt
   ```
2. Start the backend:
   ```bash
   uvicorn api.main:app --reload --app-dir software/backend/src
   ```
3. Run preprocessing and training scripts from the `scripts` directory as needed.
