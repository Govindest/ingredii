import "./globals.css";
import type { ReactNode } from "react";

export const metadata = {
  title: "Ingredii Manim Studio",
  description: "Generate Manim animations through a lightweight Vercel web app.",
};

export default function RootLayout({ children }: { children: ReactNode }) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
