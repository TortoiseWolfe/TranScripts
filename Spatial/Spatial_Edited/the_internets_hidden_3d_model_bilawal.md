# The Internet's Hidden 3D Model of the World — Bilawal Sidhu

Source: https://youtu.be/KWXuxfdZhwk
Speaker: Bilawal Sidhu (ex-Google spatial computing / 3D Maps PM, TED technology curator) · published May 14, 2026 · ~15 min

> A 17-year history of **reconstructing 3D scenes from ordinary internet photos** — and why a single April 2026 paper finally cracked the problem everyone had been stuck on. It traces the arc from **Structure-from-Motion** ("Building Rome in a Day," 2009) through **MegaDepth** (learned single-image depth), **NeRFs** and **3D Gaussian Splatting**, the **MegaScenes** dataset and the **Doppelgangers** symmetry problem, the **feed-forward** models **VGGT** and **π³ (Pi-Cube)**, and finally **MegaDepth-X**, which uses a "stolen answer key" trick to punch through the **long-tail problem**. Closes on the IARPA/military funding angle and the **4D** (moving-world) frontier.

> **Related:** This is the seed of a new **Spatial** category in the repo (spatial intelligence / 3D reconstruction / computer vision) — reference material for GrimGlow's Three.js/3D work, photogrammetry, and any spatial-computing projects.

---

## [0:00](https://youtu.be/KWXuxfdZhwk?t=0) The God's-Eye View Hiding in Your Photos

- Today you can be **geo-located from a single photo** — from reflections in your sunglasses, what's outside the window, the angle of the sunlight.
- The bigger, unasked question: **what if you fuse *every* photo uploaded in an area** — every Instagram post, Snapchat story, WhatsApp share, random Flickr tourist shot — into **a 3D "God's-eye view" of the world**?
- Until now the answer was "kind of." **Last month (April 2026), one paper made it a real possibility.**

## [0:40](https://youtu.be/KWXuxfdZhwk?t=40) How It Works — Photos In, 3D Out

- **Input:** just photos — random tourist shots of a landmark scraped off the internet.
- **Output:** a **full 3D reconstruction** of the place from those photos. And not just landmarks — you can do it for an **entire city**.
- To grasp why this is a big deal, you have to see what the field spent **two decades** trying to do.

## [1:05](https://youtu.be/KWXuxfdZhwk?t=65) 2009 — Building Rome in a Day (Structure-from-Motion)

- **2009, University of Washington, led by Sameer Agarwal:** download thousands of tourist photos of Rome off Flickr.
- **Technique — Structure-from-Motion (SfM):** reverse-engineer **where every camera was in 3D space**, then use that to **stitch the photos into one cohesive 3D model.** The eternal city, rebuilt from random snapshots.
- Called **"Building Rome in a Day"** — "a day" is how long the processing took.
- **Why it was seminal:** the techniques — **skeletal sets, bundle adjustment at scale, posing photos against a global 3D model** — rippled outward. **This is the toolkit Street-View-style systems are still built on today.** (Agarwal later went to Google, where Bilawal worked on photogrammetry alongside the people who built these foundations.)

## [2:06](https://youtu.be/KWXuxfdZhwk?t=126) 2015 — Scaling to the Whole Planet (and Hitting the Wall)

- For the next ~9 years the field **scaled SfM hard.** By **2015 a UNC team reconstructed the entire planet from Flickr in 6 days** — the same technique at planetary scale.
- **But it hits the same wall every time:** photos online **aren't evenly distributed.**

## [2:20](https://youtu.be/KWXuxfdZhwk?t=140) The Long-Tail Problem

- **The head:** a small set of places everyone photographs — Eiffel Tower, Colosseum, Times Square. Tons of photos.
- **The torso and tail:** *everywhere else* — a local coastal fort, a random monument, your neighborhood. You have **a handful of photos, if any.**
- **The long-tail problem:** SfM-style methods **only work on the head.** Famous landmarks get beautiful reconstructions; **the long tail comes out a hollow shell.** The internet simply doesn't have enough photos there — which is *why* Google flies airplanes and drives cars to image the world.
- This is the wall the field bangs its head against **for the next decade.** *(Remember the term — it comes back.)*

## [3:22](https://youtu.be/KWXuxfdZhwk?t=202) 2018 — MegaDepth: Flip the Question (Reconstructions as Training Data)

- **Flip the problem.** You already have reconstructions of famous landmarks from thousands of angles. A **Cornell PhD student** asks: instead of using internet photos to build 3D scenes, **use the reconstructions as *training data.***
- **MegaDepth:** teach a neural network to **predict per-pixel depth from any single new photo.** Show it one random tourist shot → get back a **depth map.**

## [3:49](https://youtu.be/KWXuxfdZhwk?t=229) The Mannequin Challenge — Depth for Moving People

- That gives structure; **what about the people in it?** Same year, same lab: scrape **2,000 "Mannequin Challenge" videos** off YouTube (the 2016 meme where everyone freezes and one person walks through with a camera).
- **Why it's genius:** people are static, the camera moves → **every video is a free Structure-from-Motion problem, conveniently with humans embedded.** They train the **first depth network that actually works on moving people.**
- **The uncomfortable aside:** how many viral "pose-and-hold" trends — TikTok challenges, Instagram poses — are **quietly data-collection plays** for ML labs? You think you're doing a meme; someone's training a frontier model on it.

## [4:39](https://youtu.be/KWXuxfdZhwk?t=279) 2019 — Both Directions Now Work

- By **2019** you can go **both ways:** *many photos in → full 3D scene out*, **or** *single photo in → geometry out.* **Two sides of the same coin.**

## [4:56](https://youtu.be/KWXuxfdZhwk?t=296) NeRFs — Scenes Baked Into Network Weights

- **Neural Radiance Fields (NeRFs):** instead of a point cloud or mesh, **encode the entire scene — geometry, color, the way light bounces — into the weights of a multi-layer perceptron.** (Bilawal worked on this at Google.)

## [5:25](https://youtu.be/KWXuxfdZhwk?t=325) 2021 — NeRF in the Wild (Disentangling Lighting)

- **2021, Google:** adapt NeRF to the **messy reality of internet-scale photos** → **NeRF in the Wild.**
- **Killer demo:** feed it **800 photos of the Brandenburg Gate** taken across years, cameras, lighting, with tourists in every frame. It pulls out the building **and disentangles the lighting** — so you can **change the time of day** on the same model.
- **The catch:** the whole scene lives in one massive network, so **rendering a single frame means querying it at millions of points** — beautiful, but **extremely painful to render.**

## [6:16](https://youtu.be/KWXuxfdZhwk?t=376) 2023 — 3D Gaussian Splatting (Explicit + Real-Time)

- **3D Gaussian Splatting (3DGS), 2023:** same goal as NeRF (fit a model to photos, render new views) — but **swap the implicit network for millions of fuzzy ellipsoidal "splats" (Gaussians).**
- Instead of querying a network per pixel, you **rasterize the primitives directly** → **~100 FPS, even in a browser.**
- **Why it matters for the story:** once the scene representation is **explicit and editable, every downstream trick gets easier.**

## [6:54](https://youtu.be/KWXuxfdZhwk?t=414) 2024 — Wild Gaussians (the "In the Wild" Trick, Faster)

- **Wild Gaussians (2024):** take the NeRF-in-the-Wild trick — **separate the building from its lighting** — and run it on the **more efficient Gaussian substrate.**
- **Killer demo:** an **interactive slider** in-browser tracking **sunrise → sunset → night** on the same building, in **real time.**

## [7:23](https://youtu.be/KWXuxfdZhwk?t=443) MegaScenes — Building the Dataset

- **Noah Snavely's lab + Stanford + Adobe** build **MegaScenes:** **430,000 scenes, 2 million images, 100,000 SfM reconstructions**, all scraped from **Wikimedia Commons** — real internet photos, organized by what they depict globally. **Infrastructure for everything that follows.**

## [7:49](https://youtu.be/KWXuxfdZhwk?t=469) Doppelgangers — When Symmetry Folds the Building in Half

- Scraping more photos creates new problems. Reconstruct the **Belvedere Palace in Vienna** and the software **folds the building in half** — because the **front and back look identical (bilateral symmetry).** Same issue with cathedrals, capitols, any repeated structure: **two surfaces identical in pixel space but physically apart.**
- The field's term for this: **doppelgangers.** Snavely's team trains a **transformer to detect them → Doppelgangers++.**
- Their viewer lets you **fly around a monument and see which photos contributed** — cameras light up around the building **like a swarm.** These are **hundreds of strangers' vacation photos, stitched into one coherent 3D model.** (Small-scale version: the photos your **Amazon delivery driver** snaps at your door.)
- The multi-decade arc from **Building Rome in a Day (2009)** is now, by **2024, one paper away from the punchline.**

## [9:12](https://youtu.be/KWXuxfdZhwk?t=552) Feed-Forward Models — VGGT and π³ (Killing Per-Scene Optimization)

- A parallel thread **kills per-scene optimization entirely:** **feed-forward models** that take any pile of photos and **predict cameras + geometry in a single pass, in seconds** — no Structure-from-Motion needed.
- **VGGT** — won **Best Paper at CVPR 2025** (out of ~13,000 submissions).
- **π³ (Pi-Cube)** — fixes VGGT's main weakness: VGGT **secretly picked one photo as the reference** and predicted everything relative to it, so **a bad anchor photo broke the whole reconstruction.** π³ **throws out the anchor entirely.**

## [9:57](https://youtu.be/KWXuxfdZhwk?t=597) April 2026 — MegaDepth-X Punches Through the Wall

- **April 2026, same Cornell lab (Noah Snavely), PhD student Wan Li:** **MegaDepth-X.**
- **The chicken-and-egg trap:** you can't train a model to reconstruct **sparse** internet photos because **nobody has ground truth** for those scenes — because **nothing can reconstruct them.** No answers, no training data, stuck.
- **The "stolen answer key" trick:** take **well-photographed landmarks that *do* have ground truth** (full reconstructions), then **throw away most of the photos on purpose** to **simulate the messy long tail** — a hard problem *with the answer key already known* — and train on that.
- **Fine-tune VGGT and π³ on this data → both improve dramatically.** Same architecture, now **trained on the long tail of the world.**

## [10:51](https://youtu.be/KWXuxfdZhwk?t=651) The Result — The Long Tail Unlocked

- On the **hardest sparse scenes:** off-the-shelf **π³ ≈ 75% rotation accuracy** → after fine-tuning on **MegaDepth-X ≈ 86%.**
- **The wall the field hit since 2015 is now being punched through.** You can take random photos of **basically anywhere** on the internet and turn them into **coherent 3D models.**

## [11:28](https://youtu.be/KWXuxfdZhwk?t=688) Filling the Holes — Diffusion-Guided Splatting

- To 3D-reconstruct the whole planet, you can do it Google's way (planes, satellites, Street View cars) — **or** use **generative image diffusion models** to **fill in the holes.** Even Google needs this: it **can't drive Street View / fly everywhere** (e.g., Dubai).
- **Sky Fall GS** (covered previously): 3DGS + diffusion to fill sparse-satellite gaps — **Google Earth's problem, solved from above.**
- **Diffusion-Guided Gaussian Splatting (SRI International, "last April"):** the **ground-level equivalent** — fuse ground photos, drone shots, and satellite data into one 3D model, letting **diffusion models fill gaps wherever any single source runs out.**

## [12:30](https://youtu.be/KWXuxfdZhwk?t=750) Why IARPA Funds Your Vacation Photos

- **Why does SRI care?** They're contractors for **IARPA** (the intelligence community's DARPA), on a program called **WRIVA — Walkthrough Rendering from Images of Varying Altitudes.**
- A **42-month effort since 2023** to **build photorealistic 3D walkthroughs of places agents can't physically go** — a handful of ground photos, maybe some satellite imagery, no aerial — **so they know exactly what a place looks like before sending operators in.** *That's their long-tail problem.*
- **Not just the US:** **MegaDepth-X was funded by Korea's National AI Research Lab Project.** Same race, different country footing the bill.
- **The recurring pattern:** the same tech surfaces in **a Cornell paper, a Netflix VFX tool, and an intelligence program within months of each other** — mapping and understanding the world has **always had both commercial and military application.** "They always have and they always will. Don't forget that."

## [13:53](https://youtu.be/KWXuxfdZhwk?t=833) The 4D Frontier — A Moving World

- Everything so far is **static structure.** But the world is **four-dimensional** — people move, time passes.
- Researchers now do the same trick for **casual handheld video: MoSca and Shape of Motion pull 4D out of a single phone clip** — not just geometry, but **the motion of the entities within it.**
- We're **not yet** fusing every concertgoer's iPhone into a **free-viewpoint playback of a Taylor Swift show** — but you can see where it's going.

## [14:31](https://youtu.be/KWXuxfdZhwk?t=871) The Sensorium Comes to Life

- We capture photos and video constantly — every iPhone, dashcam, every post on every platform. Now we can determine **not just where each was taken, but extract the 3D structure of the world from it.**
- **The "sensorium" comes to life:** a real **God's-eye view built from everyone's vacation photos and status updates, fused together.** We've been uploading the photos for years; **until last month it was hard to pull it all together** — now those viewpoints **mold into a 3D view of the world.**
- **Outro:** for the future of **4D Gaussian splatting** via dedicated **capture rigs** (entertainment and sports applications), see the linked videos. "Bilawal signing off — I'll see y'all in the next one."

---

> **Closing idea:** For 17 years, reconstructing 3D from internet photos only worked on **the head** — the famous, over-photographed landmarks — while **the long tail** ("everywhere else") stayed a hollow shell. The pipeline evolved from **Structure-from-Motion → learned depth (MegaDepth) → NeRFs → Gaussian Splatting → feed-forward models (VGGT / π³)**, and **MegaDepth-X** (April 2026) finally broke the long-tail wall with a **"throw away the photos, keep the answer key"** training trick. Diffusion models patch the remaining holes; the same tech quietly serves **research, VFX, and intelligence** at once; and the **4D (moving) frontier** is already opening. The hidden 3D model of the world was in our uploads all along — now we can finally assemble it.
