# The Completely Free Video to 3D Gaussian Splatting Pipeline — Jake Wong

Source: https://youtu.be/nd084X0n7t4
Speaker: Jake Wong (visual artist, jakewongvisuals.com) · published Dec 30, 2025 · ~7 min

> A **hands-on, zero-cost pipeline** to turn an ordinary video into an editable **3D Gaussian splat** in three steps — no math, no CS degree required. Uses **RealityCapture / RealityScan** (free from Epic) for frame extraction + Structure-from-Motion, exports to **COLMAP text format**, trains the splat in **Brush** (open-source, Arthur Brussee), and views/edits/measures the result in **SuperSplat** (open-source PlayCanvas viewer). This is the applied, tool-by-tool counterpart to Bilawal Sidhu's SfM→3DGS theory — and it maps exactly onto the "free reality-capture" and "video→3DGS" resources in the repo's digital-twin research.

> **Related:** Pairs with [[the_internets_hidden_3d_model_bilawal]] (the theory: SfM → 3DGS) and the WorldView build in [[vibe_coded_palantir_worldview_bilawal]]. Every tool here (RealityScan, Brush, SuperSplat, COLMAP) is a commercial-safe / free option flagged in the repo's free-digital-twin resource sweep. Relevant to GrimGlow's 3D asset capture.

---

## [0:00](https://youtu.be/nd084X0n7t4?t=0) What a Gaussian Splat Is (No Math Needed)

- A **completely free, open-source pipeline** to train Gaussian splats from **video input** in three steps.
- Unlike research papers, **you don't need the math or a CS degree** to run it.
- A splat is built from **3D "voxels" — oval/ellipsoid-shaped points** instead of flat pixels; together they form a scene you can orbit from any angle.

## [0:24](https://youtu.be/nd084X0n7t4?t=24) The Three Steps & The Three Free Tools

The whole pipeline is three stages, each handled by a free tool:

| Step | What it does | Tool |
|---|---|---|
| **1. Frame extraction** | Pull individual frames out of the video | **RealityCapture / RealityScan** (free, Epic Games Store) |
| **2. Structure-from-Motion (SfM)** | Detect features across frames, recover camera path → point cloud | **RealityCapture / RealityScan** |
| **3. Gaussian training** | Turn the SfM point cloud into a navigable 3D reconstruction | **Brush** (open-source, by Arthur Brussee, on GitHub) |

- Viewing/editing (step 4, effectively) is done in **SuperSplat**, a free open-source web viewer.
- **Downloads:** RealityCapture from the **Epic Games Store**; **Brush** via the GitHub green "Code" button → download ZIP.

## [1:21](https://youtu.be/nd084X0n7t4?t=81) Steps 1–2 in RealityCapture — Import Video & Extract Frames

- **Drag and drop the video file** into the RealityCapture workspace (or use import).
- A pop-up shows the sequence name and **frame intervals, labeled "jump lengths"** — how many frames to sample per second.
- **Default is 1 frame/sec.** For 2 fps, set **0.5**; for every frame of 30fps footage, set 1/30. (More frames = more detail but slower.)
- Importing extracts all the frames.

## [1:58](https://youtu.be/nd084X0n7t4?t=118) Align Images — The Structure-from-Motion Phase

- **Align tab → Align images** runs SfM: detects features across frames, builds a cohesive pattern, and generates a **point cloud**.
- Takes a few minutes. Output includes the **recovered camera path** (e.g., the drone's flight path) from feature matching.
- **Tip:** double-click the center of the model to set your **axis of rotation** in case it's off-center.

## [2:36](https://youtu.be/nd084X0n7t4?t=156) Export to COLMAP Text Format (the Key Handoff)

- **RealityScan icon → Export → COLMAP text format** (scroll toward the bottom of the format list).
- **COLMAP is the SfM format that Brush reads** to generate 3D Gaussians.
- **Name the file with no spaces.**
- **Critical:** in the export pop-up, enable **"export images → yes."** This generates a **second set of frame images** that Brush uses to **project RGB color onto the Gaussians**. Skip it and you get sharp splats or random blobs / failed training.

## [3:48](https://youtu.be/nd084X0n7t4?t=228) Step 3 in Brush — Train the Splat

- Launch **Brush**, click the top-left **directory** tab, and select the folder containing the COLMAP text files **plus the exported secondary frames**.
- **Steps setting:** default 30,000 is slow. The presenter dials it down to **3,000 steps** — "diminishing returns beyond 7,000," and 3,000 gives the shortest time with minimal quality loss.
- Training is the longest stage (a few minutes). **Disable live update** in controls to reduce lag while it runs. The bottom-left shows iterations, splat count, and elapsed time.
- When done: **controls → export** as a **.ply file** (named e.g. "SpaceX launch").

## [5:01](https://youtu.be/nd084X0n7t4?t=301) View & Clean in SuperSplat

- **SuperSplat** — open-source, completely free web viewer; create an account, upload, edit, and share. Maintains splat fidelity.
- **Editor → File → Import** the .ply. Toggle the **pointer/point view** to see individual Gaussians.
- **Cleaning blobs:** bottom tool tab lets you **brush over stray blobs and delete** them.
- **"Snow-globe" trim:** pick the **sphere** tool, grow its radius around the subject, then **Select → Invert → Delete** to remove everything outside the sphere. Clean spherical crop of the reconstruction.
- Export the edited result back out as a **PLY** with edits baked in.

## [6:45](https://youtu.be/nd084X0n7t4?t=405) Bonus — Real-World Measurement in SuperSplat

- The **measurement tool** (bottom toolbar) lets you **scale the whole scene from one known length**.
- Example: set a line on the rocket = **Starship height 123 m**; SuperSplat scales the entire reconstruction to match.
- Then measure anything else — e.g., main launch tower to the adjacent tower came out to **~460 m**. Useful for extracting real dimensions from a capture.

## [7:21](https://youtu.be/nd084X0n7t4?t=441) Why This Pipeline

- Built as a **clean, free alternative** for people put off by paid tools — **Postshot**, or app-based **Polycam / Scaniverse / KIRI Engine**.
- Runs on your **own PC** with holiday videos or heavy video files — the entire 3D Gaussian pipeline **for completely free**.

---

## Tools & Links

- **RealityCapture / RealityScan** (frame extraction + SfM): free via the Epic Games Store — https://www.realityscan.com/en-US/download
- **Brush** (open-source Gaussian splatting trainer, Apache-2.0, WebGPU/Rust, by Arthur Brussee): https://github.com/ArthurBrussee/brush
- **SuperSplat** (open-source MIT splat editor/viewer, PlayCanvas): https://superspl.at/
- Example scene (SpaceX launch splat): https://superspl.at/view?id=c65b5422
