from fastapi import FastAPI
from prometheus_fastapi_instrumentator import Instrumentator
import os

app = FastAPI()
NODE_NAME = os.getenv("NODE_NAME", "unknown")

@app.on_event("startup")
async def startup():
    Instrumentator().instrument(app).expose(app)

@app.get("/")
async def root():
    return {"message": f"Hello from {NODE_NAME}!"}

@app.get("/health")
async def health():
    return {"status": "healthy"}