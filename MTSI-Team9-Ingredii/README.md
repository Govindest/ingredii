# MTSI Team 9 Ingredii

Ingredii is a pantry inventory management system. A small camera module scans the contents of your pantry and syncs data to a backend service. Our web and mobile apps then provide real‑time stock levels and recipe suggestions based on what you have at home.

## Installation

### Prerequisites
* Python 3.11+
* PlatformIO for firmware
* Node.js (16+) for the web interface
* Xcode (or Swift toolchain) for the iOS app
* Docker (optional) for containerised backend

### Setup
1. Clone this repository
   ```bash
   git clone <repo-url>
   cd MTSI-Team9-Ingredii
   ```
2. Install Python dependencies
   ```bash
   pip install -r software/backend/requirements.txt
   ```
3. Build and upload the firmware
   ```bash
   cd firmware
   platformio run --target upload
   ```
4. Start the backend API
   ```bash
   python software/backend/src/api/app.py
   ```
5. Run the web interface
   ```bash
   cd software/frontend/web_app
   npm install
   npm start
   ```
6. Open the iOS app in `software/frontend/mobile_app/ios` with Xcode and run it on a simulator or device.

## Running End to End
1. Flash the microcontroller with the firmware.
2. Ensure the backend API is running and accessible.
3. Launch either the web or mobile application and connect it to the backend.
4. The camera module will upload images periodically, updating your pantry inventory automatically.

## Repository Structure
* `docs/` – design notes and research
* `diagrams/` – architecture diagrams
* `hardware/` – CAD and electronics files
* `firmware/` – microcontroller source code
* `software/` – backend, web and mobile applications
* `scripts/` – helper utilities
* `data/` – sample datasets for development
* `tests/` – unit and integration tests

