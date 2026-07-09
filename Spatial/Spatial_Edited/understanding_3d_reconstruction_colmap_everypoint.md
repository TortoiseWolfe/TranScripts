# Understanding 3D Reconstruction with COLMAP — EveryPoint (Computer Vision Decoded)

Source: https://youtu.be/EdIuDLicU0c
Speaker: Jonathan Stephens (host) & Jared Heinly (guest, SfM/COLMAP expert) — EveryPoint "Computer Vision Decoded" · published Apr 3, 2025 · ~57 min

> The conceptual deep-dive on **COLMAP**, the free/open-source **Structure-from-Motion (SfM)** engine that turns a pile of overlapping photos into camera poses and a sparse 3D point cloud. It walks the full pipeline end to end — **feature extraction → matching → geometric verification → incremental reconstruction (initialization, image registration, triangulation, bundle adjustment, outlier filtering) → camera models** — then covers **GLOMAP**, a faster *global* alternative to COLMAP's incremental reconstruction. This matters because COLMAP's output (camera poses + sparse cloud) is the mandatory front-end that nearly **every NeRF, Gaussian-splat, photogrammetry, and digital-twin pipeline** depends on — most people run it as a black box without understanding what each stage does.

> **Related:** The applied counterpart is [[free_video_to_gaussian_splatting_pipeline_jakewong]], which exports to **COLMAP text format** as its handoff to a splat trainer. The historical foundation is [[the_internets_hidden_3d_model_bilawal]] — SfM at planet scale ("Building Rome in a Day"). Downstream, the reconstructions feed toolchains like [[urban_digital_twins_opensource_geosolutions]]. **COLMAP is the free/OSS SfM front-end nearly every reconstruction toolchain feeds through** — if a pipeline needs to know where the cameras were, it almost certainly runs COLMAP (or GLOMAP) first.

---

## [0:00](https://youtu.be/EdIuDLicU0c?t=0) Why This Episode — Demystifying the Black Box

- The most common question EveryPoint gets is about **Structure-from-Motion (SfM)** and 3D reconstruction from imagery — specifically what actually happens inside **COLMAP** ("Colmap").
- COLMAP is used as the reference tool because it is **open-source and free** — anyone can download it and follow along on their own PC, no paid third-party software required.
- The goal: understand this "black box" so you know what each step does. **Other 3D reconstruction software follows the same workflow**, so the concepts transfer.
- Running example: a fountain in front of the **Oregon State Capitol**, captured by walking around it and extracting frames from a video — enough angles for a 3D model.

## [2:22](https://youtu.be/EdIuDLicU0c?t=142) The Core Problem — Recovering Where the Cameras Were

- A single physical **camera** (phone, DSLR) moving around a scene occupies **different 3D positions in space**; each photo is a view from a different 3D point and perspective. ("Camera" and "image" are used interchangeably.)
- Humans do this 3D reasoning **instantly** — we see foreground/background, motion, parallax. Software has none of that intuition and must **compute it from math**.
- The first job is to figure out, for each photo: **where was the camera positioned, how was it angled, what was the focal length/zoom**. Establish how images relate to each other, *then* recover the 3D geometry describing that relationship.

## [4:47](https://youtu.be/EdIuDLicU0c?t=287) A Little COLMAP History (Why "COLMAP")

- Author **Johannes Schönberger** developed it while at **UNC Chapel Hill** (~2013). His earlier drone-focused pipeline was "MAV map" (mobile aerial vehicle mapper); he wanted to generalize beyond aerial photography to arbitrary **image collections** — hence **COLMAP = "collection mapper."**
- Jared was among the first users, running it on a **100-million-image** PhD project on a single PC (feature extraction + matching, then COLMAP for reconstruction).
- Still **actively maintained** years later, and won awards. Schönberger later worked at ETH Zürich and beyond, and had a hand in **GLOMAP** (released the prior year).
- **Why it endures:** recovering the **3D pose** (position + orientation) of images is a key step in *so many* 3D pipelines. If you want to understand the world in 3D, you must first figure out where the images were taken from.

## [7:45](https://youtu.be/EdIuDLicU0c?t=465) The Pipeline at a Glance

COLMAP's own tutorial diagram shows the workflow from raw images to a 3D reconstruction with camera poses. Three high-level blocks:

1. **Correspondence Search** — feature extraction → matching → geometric verification. *All 2D*; no real 3D reasoning yet.
2. **Incremental Reconstruction** — initialization → image registration → triangulation → bundle adjustment → outlier filtering (looped).
3. **Final Reconstruction** — camera poses + sparse point cloud.

The tutorial's "wall of text" is opaque unless you're a computer-vision specialist — this episode breaks each stage down.

## [8:43](https://youtu.be/EdIuDLicU0c?t=523) Feature Extraction — Finding Unique Landmarks

- **Goal:** automatically identify **unique landmarks** (2D key points) in each photo — typically **tens of thousands per image** — so the *same* point can be found across multiple photos and tracked.
- Each tracked point becomes a **constraint** later: however the images end up positioned, that shared pixel should converge to a **common 3D point**. A key point gives a **viewing ray** (a direction into the scene; depth unknown).
- COLMAP uses **SIFT** (Scale-Invariant Feature Transform) — a **blob-style detector** that looks for a patch of pixels with **high contrast to its surroundings** (light-on-dark or dark-on-light), at **multiple scales/resolutions** (hence "scale-invariant").
- Once found, it extracts a **descriptor** — a compact summary of the appearance *around* the landmark (e.g., a dark doorknob plus the wood-grain pattern around it). The exact descriptor math "could be a whole podcast," but conceptually it just summarizes what the neighborhood looks like.
- **Fast on GPU** — feature extraction runs across all images independently (no cross-image dependency), so it parallelizes well. COLMAP defaults to a **max of ~10,000 features per image**.

## [12:32](https://youtu.be/EdIuDLicU0c?t=752) Camera Models — Why COLMAP Asks Up Front

When you run **feature extraction**, COLMAP makes you pick a **camera model** because it defines the **geometry** of the camera/lens, and it creates the image entries in the on-disk **database**.

- **Simple radial** — parameters `f, cx, cy, k`:
  - **`f`** = focal length (field of view).
  - **`cx, cy`** = principal point (where the optical axis meets the image; roughly the image center).
  - **`k`** = a single **radial distortion** term (one polynomial term for lens curvature). Good for most general cameras (iPhone, DSLR, point-and-shoot); assumes square pixels / a single focal length.
- **Radial** — adds a second distortion term (`k1, k2`) for a better distortion estimate.
- **Fisheye / simple radial fisheye / FOV** — for **wide-angle** lenses (GoPro, drones) with heavy distortion; **FOV** is best for super-wide angle.
- **Practical advice:** for a smartphone, just leave it on **simple radial** and you'll be fine.
- **Other options:** treat all images as **one shared camera** (great when everything was shot on the same device); **masks** — supply a per-image mask to exclude something from the reconstruction (e.g., mask out a person or a background so only the target object is reconstructed).

## [17:03](https://youtu.be/EdIuDLicU0c?t=1023) Inspecting Key Points in the Database

- COLMAP's **database manager → show image** overlays detected **key points** (red circles) on a photo.
- Where the scene is **low-contrast / low-variation** (a plain street, sky), there are **few features**. Where it's **ornate** (the fountain's decorations, background trees/buildings), there are **many**. This directly illustrates why texture-rich scenes reconstruct better.

## [18:25](https://youtu.be/EdIuDLicU0c?t=1105) Matching — Discovering Which Images Overlap

- **Show overlapping images** draws **green lines** between key points that matched across two images — the system believes these are the **same physical points**.
- **Matching** compares the descriptors from each image to find features that *look* similar, producing the set of **correspondences**. Not every key point matches — only a subset.
- This is a purely appearance-based step, so it makes mistakes: a repeating **brick pattern**, or the top of one tree vs. another, can be **mismatched** even when it makes no geometric sense.

## [19:57](https://youtu.be/EdIuDLicU0c?t=1197) Geometric Verification — Cleaning Up the Matches

- **Matching and geometric verification go hand-in-hand** (verification runs immediately after matching).
- Verification's job: given the initial matches between a pair of images, decide **which ones actually make geometric sense** — i.e., is there a **valid camera motion** that would move the points in image A to their claimed locations in image B?
- Key terms you'll see: estimating a **homography** (perspective transform), an **essential matrix**, or a **fundamental matrix** — each describes how a point in one image maps to a location (or line) in another. This is still **2D-to-2D** reasoning.
- Knowing the **camera model / distortion / fisheye** can help verification; some methods ignore it and use only 2D relationships.
- **Inliers** = the geometrically verified matches for an image pair. Match settings expose verification thresholds: expected **pixel error**, **minimum inliers**, **inlier ratio**.

## [22:46](https://youtu.be/EdIuDLicU0c?t=1366) Matching Strategies — The Single Most Important Choice

Matching is **CPU-driven** (it compares images pairwise; it can't look at everything at once like feature extraction on the GPU). COLMAP offers several strategies:

- **Exhaustive** — matches **every image to every other image** (order n²). Best for an **unsorted/random collection** where you wandered around shooting in all directions. Works well up to a **few hundred images**; beyond that it gets very slow (but still possible if you wait).
- **Sequential** — assumes images were captured **in order** (e.g., video frames or a deliberate walk-around), so consecutive images overlap. **Fastest first option** whenever you have ordered/video input.
- **Vocabulary tree (vocab tree)** — image-retrieval-style matching. Builds a compact **lookup structure** summarizing each image's content, then for a given image returns a **ranked list** of the images most likely to match — so instead of matching all 10,000, you match the best 50/100. Use this for large, **unordered** sets.
- **Spatial** — uses embedded **GPS/EXIF geotags** to match each image only to others taken **nearby**. Ideal for **drone data** (modern DJI enterprise drones have good GPS, even without RTK).
- **Transitive** — **densifies existing matches**: if A↔B and B↔C matched but A↔C was never tried, it adds A↔C. Strengthens connectivity to help reconstruction.
- **Loop detection** (under sequential) — supply a vocab-tree path; every Nth frame runs a retrieval step to detect **loop closures** (you've returned to a place you already saw).

**Rule of thumb:** sequential/video → **sequential**; unordered and **>300–400 images** → **vocab tree** (not exhaustive); drone/GPS → **spatial**; small unordered set where accuracy matters most → **exhaustive**. Picking the wrong mode is the difference between "ready in 28 hours" and minutes.

## [31:11](https://youtu.be/EdIuDLicU0c?t=1871) Incremental Reconstruction — Initialization

- After feature extraction + matching you **still see nothing** in the GUI (no point cloud, no camera poses yet) — you're leaving **correspondence search** and entering **incremental reconstruction**.
- **Incremental reconstruction** is one style of doing SfM. Core idea: start from the **minimum** you need — a **single pair of images** — figure out their **3D relationship** and **triangulate** an initial set of 3D points. That two-view reconstruction is the **seed**.
- From there you **add one image at a time** (a third, fourth, fifth…) to grow a larger and larger reconstruction.
- **Initialization** = choosing **which pair of images to start with**.

## [33:09](https://youtu.be/EdIuDLicU0c?t=1989) The Reconstruction Loop — Registration, Triangulation, Refinement

The diagram loops: **image registration → triangulation → bundle adjustment → outlier filtering**, repeating while it grows the reconstruction.

- **Image registration** — add a *new* image to the existing reconstruction. Find the next best image that also saw already-triangulated 3D points (via feature matches), then align its **2D points to the known 3D points**. Also called the **Perspective-n-Point (PnP) problem** / pose estimation.
- **Triangulation** — the newly added image, combined with existing ones, creates **new 3D points**.
- **Bundle adjustment** — refinement (below).
- **Outlier filtering** — drop points/matches that don't hold up, then loop again.

## [34:54](https://youtu.be/EdIuDLicU0c?t=2094) It Doesn't Reconstruct in Capture Order

- COLMAP does **not** go image 1 → 2 → 3. It picks the initial **pair** that maximizes a criterion: **strong connectivity** (lots of feature matches) **plus enough viewpoint change (baseline / parallax)**.
- Two images from the **exact same position** give **no 3D information** — you need **translation/motion** between views to triangulate depth.
- In the fountain example, the capture had **two loops** at different heights; COLMAP paired, e.g., **image 1 with image ~180** (same part of the fountain, different elevation/angle) because that pair had both strong matches *and* good **parallax** — better than adjacent, nearly-identical frames.
- In the GUI you can **watch the sparse point cloud and camera poses build up** iteratively — a great way to build intuition.

## [38:27](https://youtu.be/EdIuDLicU0c?t=2307) Bundle Adjustment — Local vs. Global

- **Bundle adjustment** = jointly **refining the 3D points *and* the camera poses** to best satisfy all the "these 2D observations saw this common 3D point" constraints. (The "bundle" is the bundle of constraints — nothing to do with sticks.)
- **Local bundle adjustment** — when adding a new image, only optimize the **cameras and points near it** (fast). Runs every time an image is added.
- **Global bundle adjustment** — periodically (e.g., after the reconstruction **grows ~10%**, or every ~500 images, and at the end) optimize **everything** — all points and all camera poses.
- **Crucially, bundle adjustment also refines the camera intrinsics** — the **focal length**, **principal point**, and **radial distortion** terms chosen with the camera model — to sharpen the reconstruction.

## [41:12](https://youtu.be/EdIuDLicU0c?t=2472) Using Known Calibration (and Whether to Refine It)

- If you have a **calibration** (e.g., DJI enterprise drones embed calibrated lens data in EXIF), you can tell COLMAP whether to **refine or lock** the focal length / distortion terms (options under reconstruction or bundle-adjustment settings).
- COLMAP **parses EXIF** for an initial focal-length guess (e.g., "taken with a 24 mm lens") and uses it as **initialization**.
- **In practice, refining still usually helps** — the EXIF value gets you close but often not close enough for a really sharp reconstruction.

## [42:30](https://youtu.be/EdIuDLicU0c?t=2550) What the Sparse Model Is For

- You don't need a high-spec machine to learn on a **small data set** — it runs quickly even on an older CPU.
- After reconstruction you can run a final **global bundle adjustment**, then build a **dense reconstruction** (millions of points — not covered here).
- The **sparse output (camera poses + sparse point cloud)** is the input for downstream tasks: **dense multi-view stereo**, and critically **initializing 3D Gaussian splatting / NeRF**.
- The GUI's **magenta lines** and click-to-inspect tools show which images contributed to a point and how images matched — a very visual way to learn.

## [44:12](https://youtu.be/EdIuDLicU0c?t=2652) Why Incremental Reconstruction Doesn't Use the GPU

- A frequent complaint: "I have a new GPU, why is reconstruction slow and my GPU idle?"
- A **GPU excels at the same operation on millions of things at once** (drawing pixels) — great for **feature extraction** and **feature matching**.
- **Incremental reconstruction operates on one image at a time**, solving **linear-algebra / math** to recover a single image's pose — an inherently **sequential, hard-to-parallelize** task.
- COLMAP is also **very flexible** (many algorithms, switches, techniques); keeping it a general-purpose **CPU** implementation makes it easy for the open-source community to extend. Analogy: the **CPU is a detective solving clue-by-clue**; the GPU points out all clues at once but can't crack the sequential puzzle.

## [47:00](https://youtu.be/EdIuDLicU0c?t=2820) GLOMAP — Global Reconstruction Instead of Incremental

- **GLOMAP** ("glow map" = **global mapper**) replaces the reconstruction stage with a **global** approach: it solves the **3D poses of *all* images at once** instead of adding them one at a time.
- It still needs the **same correspondence search** — feature extraction, matching, geometric verification — to build the **web of connectivity**. Then:
  - **Rotation averaging** — estimate the **rotation between each image pair**, then find a single **consistent orientation for every image** that satisfies all the pairwise constraints (position ignored at this stage).
  - **Global positioning** — with images oriented, solve **camera positions and some 3D points simultaneously**. It throws all cameras into a "soup" with random initializations and rearranges them so they line up on the common points they observed (similar in spirit to bundle adjustment, but a formulation better suited to unknown positions).
  - **Bundle adjustment** — a final high-quality refinement, giving the finished 3D reconstruction.
- **Why it's faster:** it **skips the slow, non-parallelizable incremental loop**; rotation averaging and global positioning parallelize better and don't process images one-after-another.

## [49:49](https://youtu.be/EdIuDLicU0c?t=2989) When GLOMAP Works — and When It Fails

- **Low cost to try:** you find out within **minutes** whether it worked, so it's worth a shot on any project.
- **Global methods work best with lots of connectivity** — many **loop closures**, diverse vantage points, overlap, and unique features. A broad scene with rich texture is ideal.
- **Fails on** long non-returning paths (walking through a cave / down a street and never coming back) and **feature-poor scenes** (blank white indoor walls, or getting too tight on one small object).
- **Reading the output:** GLOMAP is either **clearly good** (a clean sparse cloud) or **clearly broken** — cameras scattered into a weird **"Borg cube."** You'll know immediately.
- Accuracy is **in the same range as COLMAP's incremental reconstruction** when it succeeds — fast *and* good, not fast-but-worse. GLOMAP **drops on top of COLMAP** (small lift to get running); Schönberger is again among the authors.

## [52:49](https://youtu.be/EdIuDLicU0c?t=3169) Takeaways — Just Try It

- This is the **standard classical 3D-reconstruction-from-imagery pipeline**; most other software follows the same style. Newer machine-learning methods differ, but this remains the well-known, reused workflow that feeds most projects.
- **Best way to learn:** throw your **own** photos at COLMAP, run a reconstruction, and **poke around** — inspect points, see which images formed them, view the match graph/matrix.
- **The single most important knob is the matching strategy** — it's the difference between hours and minutes.
- **Capture advice:** take **sharp imagery**, and use **your own photos** (not clean open-source datasets that are guaranteed to work) so you actually learn how real captures behave.
- Most people run COLMAP as a black box for **3D Gaussian splatting / NeRF** without knowing what it does. Understanding each step lets you **get better results** and debug failures. (This is episode ~15–16 of the EveryPoint "Computer Vision Decoded" series.)

---

## Tools & Concepts

- **COLMAP** — free, open-source SfM + Multi-View Stereo pipeline; the reference tool for this episode. https://colmap.github.io/
- **GLOMAP** — global SfM that drops on top of COLMAP for faster reconstruction at comparable accuracy. https://github.com/colmap/glomap
- **SfM (Structure from Motion)** — recovering camera **poses** (position + orientation) and a **sparse 3D point cloud** from overlapping 2D images.
- **Feature extraction** — detecting unique 2D landmarks (key points) per image; COLMAP uses **SIFT** (Scale-Invariant Feature Transform), a multi-scale blob detector.
- **Descriptor** — a compact numeric summary of a key point's local appearance, used to match it across images.
- **Matching** — finding features that look alike across image pairs, yielding **correspondences**.
- **Geometric verification** — keeping only matches consistent with a valid camera motion (**homography / essential / fundamental matrix**); survivors are **inliers**.
- **Matching modes** — exhaustive (n²), sequential (ordered/video), vocab tree (retrieval for large unordered sets), spatial (GPS/EXIF), transitive (densify), loop detection.
- **Camera model / intrinsics** — focal length (`f`), principal point (`cx, cy`), radial distortion (`k` / `k1, k2`); models range from simple radial to fisheye/FOV for wide lenses.
- **Incremental reconstruction** — build the model one image at a time: **initialization → image registration (PnP pose estimation) → triangulation → bundle adjustment → outlier filtering** (looped).
- **Triangulation** — intersecting viewing rays from matched key points to compute a 3D point.
- **Baseline / parallax** — the translation between viewpoints; needed to recover depth (no motion = no 3D).
- **Bundle adjustment** — jointly optimizing all 3D points, camera poses, and intrinsics to minimize reprojection error; **local** (near a new image) vs. **global** (everything).
- **Global reconstruction (GLOMAP)** — **rotation averaging** → **global positioning** → **bundle adjustment**, solving all poses at once.
- **Downstream uses** — dense MVS reconstruction, and initializing **3D Gaussian splatting** / **NeRF** from the sparse cloud + poses.
