from fastapi import FastAPI
from . import models

app = FastAPI()

db = models.InMemoryDB()

@app.get('/items')
def list_items():
    return db.get_items()
