"use client";

import { useState } from "react";

type RenderResult = {
  id: string;
  prompt: string;
  manimCode: string;
  videoUrl: string;
};

export default function Home() {
  const [prompt, setPrompt] = useState("");
  const [results, setResults] = useState<RenderResult[]>([]);
  const [status, setStatus] = useState<string | null>(null);
  const [isLoading, setIsLoading] = useState(false);

  const handleGenerate = async () => {
    if (!prompt.trim()) {
      setStatus("Add a prompt to generate a scene.");
      return;
    }

    setIsLoading(true);
    setStatus("Contacting the model and render worker...");

    try {
      const response = await fetch("/api/generate", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ prompt }),
      });

      if (!response.ok) {
        const errorPayload = await response.json();
        throw new Error(errorPayload.error ?? "Something went wrong.");
      }

      const data = await response.json();
      const nextResult: RenderResult = {
        id: crypto.randomUUID(),
        prompt,
        manimCode: data.manimCode,
        videoUrl: data.videoUrl,
      };

      setResults((prev) => [nextResult, ...prev]);
      setPrompt("");
      setStatus("Render complete. Video ready.");
    } catch (error) {
      const message = error instanceof Error ? error.message : "Unexpected error.";
      setStatus(message);
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <main>
      <div className="app-shell">
        <header>
          <span className="badge">Vercel-ready web app</span>
          <h1>Ingredii Manim Studio</h1>
          <p>
            Generate Manim animations by prompting GPT and dispatching a render job to
            a Docker worker.
          </p>
        </header>

        <section className="prompt-card">
          <textarea
            placeholder="Describe the animation you want to render (e.g., 'Animate a bouncing ball labeled Ingredii')."
            value={prompt}
            onChange={(event) => setPrompt(event.target.value)}
          />
          <div className="actions">
            <button onClick={handleGenerate} disabled={isLoading}>
              {isLoading ? "Generating..." : "Generate video"}
            </button>
            <span className="helper-text">
              {status ?? "Your render results will appear below."}
            </span>
          </div>
        </section>

        <section className="feed">
          {results.length === 0 ? (
            <div className="feed-card">
              <h3>Feed viewer</h3>
              <p className="helper-text">
                Submit a prompt to see generated Manim code and the rendered MP4.
              </p>
            </div>
          ) : (
            results.map((result) => (
              <article className="feed-card" key={result.id}>
                <h3>{result.prompt}</h3>
                <video controls src={result.videoUrl} />
                <details>
                  <summary>View Manim code</summary>
                  <pre>{result.manimCode}</pre>
                </details>
              </article>
            ))
          )}
        </section>
      </div>
    </main>
  );
}
