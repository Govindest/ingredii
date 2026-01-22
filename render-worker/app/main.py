from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

app = FastAPI(title="Ingredii Render Worker")


class RenderRequest(BaseModel):
    manimCode: str


class RenderResponse(BaseModel):
    videoUrl: str
    note: str | None = None


@app.post("/render", response_model=RenderResponse)
def render_scene(payload: RenderRequest):
    if not payload.manimCode.strip():
        raise HTTPException(status_code=400, detail="Manim code is required.")

    # TODO: Replace this stub with a real Manim invocation, upload, and URL return.
    return RenderResponse(
        videoUrl="https://example.com/rendered-video.mp4",
        note="Stub worker: configure Manim rendering + storage to return a real URL.",
    )
