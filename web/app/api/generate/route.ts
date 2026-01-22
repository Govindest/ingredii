import { NextResponse } from "next/server";

type GenerateRequest = {
  prompt: string;
};

type OpenAIMessage = {
  role: "system" | "user";
  content: string;
};

const SYSTEM_PROMPT =
  "You are a Manim expert. Return ONLY valid Python Manim code for a single Scene.";

function buildFallbackManim(prompt: string) {
  return `from manim import *\n\nclass GeneratedScene(Scene):\n    def construct(self):\n        text = Text("${prompt.replace(/"/g, "'" )}")\n        self.play(Write(text))\n        self.wait(1)\n`;
}

async function fetchManimCode(prompt: string) {
  const apiKey = process.env.OPENAI_API_KEY;
  const model = process.env.OPENAI_MODEL ?? "gpt-4o-mini";

  if (!apiKey) {
    return {
      manimCode: buildFallbackManim(prompt),
      usedFallback: true,
    };
  }

  const messages: OpenAIMessage[] = [
    { role: "system", content: SYSTEM_PROMPT },
    { role: "user", content: prompt },
  ];

  const response = await fetch("https://api.openai.com/v1/chat/completions", {
    method: "POST",
    headers: {
      Authorization: `Bearer ${apiKey}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      model,
      messages,
      temperature: 0.2,
    }),
  });

  if (!response.ok) {
    const errorPayload = await response.json();
    throw new Error(errorPayload.error?.message ?? "OpenAI request failed.");
  }

  const payload = await response.json();
  const manimCode = payload.choices?.[0]?.message?.content?.trim();

  if (!manimCode) {
    throw new Error("No Manim code returned from model.");
  }

  return { manimCode, usedFallback: false };
}

async function sendToRenderWorker(manimCode: string) {
  const workerUrl = process.env.RENDER_WORKER_URL;

  if (!workerUrl) {
    return {
      videoUrl: "https://example.com/rendered-video.mp4",
      usedFallback: true,
    };
  }

  const response = await fetch(`${workerUrl.replace(/\/$/, "")}/render`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({ manimCode }),
  });

  if (!response.ok) {
    const errorPayload = await response.json();
    throw new Error(errorPayload.error ?? "Render worker failed.");
  }

  const payload = await response.json();

  if (!payload.videoUrl) {
    throw new Error("Render worker did not return a video URL.");
  }

  return { videoUrl: payload.videoUrl, usedFallback: false };
}

export async function POST(request: Request) {
  try {
    const body = (await request.json()) as GenerateRequest;

    if (!body.prompt || !body.prompt.trim()) {
      return NextResponse.json(
        { error: "Prompt is required." },
        { status: 400 }
      );
    }

    const { manimCode, usedFallback: usedModelFallback } = await fetchManimCode(
      body.prompt
    );
    const { videoUrl, usedFallback: usedWorkerFallback } =
      await sendToRenderWorker(manimCode);

    return NextResponse.json({
      manimCode,
      videoUrl,
      usedModelFallback,
      usedWorkerFallback,
    });
  } catch (error) {
    const message = error instanceof Error ? error.message : "Unexpected error.";
    return NextResponse.json({ error: message }, { status: 500 });
  }
}
