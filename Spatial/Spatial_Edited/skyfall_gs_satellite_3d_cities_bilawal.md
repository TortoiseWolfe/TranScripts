# This AI Just Fixed Google Earth's Biggest Problem (Skyfall-GS) — Bilawal Sidhu

Source: https://youtu.be/VWdmXlRpL84
Speaker: Bilawal Sidhu (ex-Google spatial-computing / 3D Maps PM, TED technology curator) · published Nov 20, 2025 · ~3 min

> A tight breakdown of **Skyfall-GS**, a research paper that reconstructs **full, flyable 3D cities from satellite imagery alone** — no airplane flyovers, no street-level photos, no LiDAR. It trains **3D Gaussian splats** on multi-view satellite images, then uses an **image diffusion model (Flux)** to hallucinate the occluded facades and street-level detail the satellites can't see, reaching **multi-view consistency by generating several diffusion samples per view and letting splat optimization find consensus** — refined in a **curriculum from high altitude down to ground level** (the "sky-fall"). This is the concrete instance of the "diffusion-guided splatting" and "long-tail" threads from Bilawal's reconstruction-history talk, and it directly attacks WorldView's biggest data limit (Google only has ~3,000 cities of 3D mesh).

> **Related:** Extends [[the_internets_hidden_3d_model_bilawal]] (the long-tail problem + diffusion-guided splatting, made concrete) and lifts the core data constraint behind [[vibe_coded_palantir_worldview_bilawal]] (Google's ~3,000-city 3D-Tiles coverage, and the oblique-imagery fallback where no mesh exists). Same dual-use intelligence-funding theme (US Army One World Terrain / Maxar). Pairs with the applied capture pipeline in [[free_video_to_gaussian_splatting_pipeline_jakewong]].

---

## [0:00](https://youtu.be/VWdmXlRpL84?t=0) The Problem — Satellites See Your Roof, Not Your Front Door

- From Bilawal's Google Maps photogrammetry days: **satellite-based 3D reconstructions were basically useless at city scale.** Good city 3D required **airplanes with specialized camera rigs flown at low altitude.**
- **The physics:** satellites look **oblique / slightly off-nadir**, so **building facades and street-level detail are occluded** — that geometry simply isn't captured.

## [0:18](https://youtu.be/VWdmXlRpL84?t=18) Why This Cripples Global Mapping

- Flying camera-array planes everywhere is impossible: **aerial-denied regions, restricted airspace, conflict zones.**
- Result: **huge chunks of Earth are unmapped** in 3D — **only ~3,000 cities** have 3D data inside Google Earth.

## [0:54](https://youtu.be/VWdmXlRpL84?t=54) The Skyfall-GS Approach — Splats + Diffusion

- **Step 1:** train **3D Gaussian splats on multi-view satellite imagery** (standard 3DGS).
- **The failure:** as the virtual camera **descends toward ground level, renders fall apart** — floating artifacts, geometric nonsense (exactly the occluded facades/streets).
- **The insight — lean into the failure:** feed those **broken ground-level renders into an image diffusion model (Flux)** and tell it to **"hallucinate and fill in the missing parts."** The bad render becomes a **starting point for diffusion to autocomplete.**

## [1:31](https://youtu.be/VWdmXlRpL84?t=91) The Clever Part — Consensus + Curriculum (the "Sky-Fall")

- **Multi-sample consensus:** generate **multiple diffusion samples per view** (rather than committing to one likely-wrong guess), then **let Gaussian-splatting optimization find consensus across them** → real **multi-view consistency**.
- **Curriculum training in episodes:** start at **higher altitudes and gradually descend** — hence **"Skyfall."** Each iteration makes the ground-level views less broken and more refined; diffusion fills facades, adds texture, fixes artifacts.
- **Outcome:** **real-time flyable 3D cities** that look surprisingly convincing.

## [2:14](https://youtu.be/VWdmXlRpL84?t=134) Why It's a Paradigm Shift, Not Just Cleanup

- **Geometry still respects the satellite input** — it's not fabricating; it's **intelligently completing what was occluded.**
- **Zero extra data:** no 3D training data, no street-level photos, no airplane flyovers — **just satellite imagery + diffusion filling the blanks.**
- Prior pipelines like **Vricon 3D (now owned by Maxar)** can get a huge boost from this. Effectively, **the entire world — including aerial-denied regions — becomes mappable.**

## [2:51](https://youtu.be/VWdmXlRpL84?t=171) Dual Use — One World Terrain

- **US Army "One World Terrain" program:** a Maxar contract using satellite imagery worldwide to build **synthetic 3D environments** for places the military can't fly planes/drones. (Same dual-use pattern as MegaDepth-X / IARPA WRIVA in the reconstruction-history talk.)
- Past results were **"2.5D"** — fine as elevation-analysis rasters, **not convincing for humans and not good for training an AI to navigate.**

## [3:28](https://youtu.be/VWdmXlRpL84?t=208) The Takeaway

- **"Neural scene completion, but actually practical."** It unlocks the whole world: not 3,000 cities in Google Earth — potentially **the entire planet.**

---

## Links

- **Skyfall-GS project page:** https://skyfall-gs.jayinnn.dev/
- Core technique stack: **3D Gaussian Splatting** + an **image diffusion model (Flux)** for occlusion in-fill, trained **high-to-low-altitude (curriculum)** with **multi-sample consensus**.
