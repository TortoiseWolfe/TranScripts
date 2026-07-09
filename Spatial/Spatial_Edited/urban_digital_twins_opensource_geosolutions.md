# Building and Consuming Urban Digital Twins with Open-Source Tools — GeoSolutions

Source: https://youtu.be/owQW-AUjk0U
Speaker: GeoSolutions Group (open-source geospatial company — GeoServer, GeoNode, MapStore) · published Jun 13, 2024 · ~90 min workshop

> A hands-on webinar that wires together a **fully open-source pipeline for building an urban digital twin** — taking raw **shapefiles and lidar point clouds** and converting them into streamable **OGC 3D Tiles**, then serving them in a browser. The workflow runs entirely from a **Dockerized "Digital Twin Toolbox"** (GeoSolutions, on GitHub) that orchestrates **PostGIS + pg2b3dm** (polygons → 3D Tiles), **py3dtiles** (points → 3D Tiles), and **PDAL** (point-cloud reprojection + colorization), with **CesiumJS-based MapStore** as the WebGIS viewer. Everything is demonstrated on **Washington D.C. open data** — extruding building footprints into volumes, instancing glTF tree models on point features, and reprojecting/colorizing an airborne-lidar point cloud — with a closing look at **AI point-cloud classification** (PointNet / random forest) as future work.

> **Related:** This is the "how to actually wire the OSS stack" companion to the WorldView build in [[vibe_coded_palantir_worldview_bilawal]] — where that video shows the vibe-coded front-end, this one shows the open-source data-to-3D-Tiles backend that feeds it. It builds on the reconstruction theory in [[the_internets_hidden_3d_model_bilawal]] (SfM → point clouds) and pairs with [[free_video_to_gaussian_splatting_pipeline_jakewong]] (free capture → 3D). This is the **entry point for the repo's free open-source geospatial digital-twin resource research**: MapStore, CesiumJS, GeoServer, PDAL, py3dtiles, pg2b3dm, and 3D Tiles are all zero-cost, standards-based building blocks.

---

## [4:41](https://youtu.be/owQW-AUjk0U?t=281) Who GeoSolutions Is (and the OSS They Steward)

- **GeoSolutions** — open-source geospatial company, offices in Italy and the US, ~17-18 years of OSS development. Presenters: **Tobia Di Pisa** (MapStore product owner), **Stefano Bovio** (front-end dev), **Georgios Pipis** (AI/point-cloud), hosted by Ryan Burley.
- Employs the **majority of core committers** for **GeoServer, GeoNode, MapStore, GeoNetwork**, associated plugins, and underlying toolsets like **GeoTools** and the **OGC protocols**.
- **Certified CesiumJS 3D developers** — deep expertise in **Cesium 3D tile generation** on an open-source stack.
- Business model: professional training, hosting/subscription services (e.g. hosting GeoServer), commercial support, and custom development. Contact: **info@geosolutionsgroup.com**; recordings on the GeoSolutions Group YouTube channel.

## [5:41](https://youtu.be/owQW-AUjk0U?t=341) The Problem: Consuming 3D Data on the Web

- Consuming 3D data in a **WebGIS** is now a common requirement — **digital twins, urban planning, flight ops/aerospace, IoT real-time, underground**.
- The **urban environment** is a key context: municipalities and public administrations need advanced 3D representations that **combine existing 2D data inside a 3D scene** with reliable terrain, buildings, and urban features.
- **3D Tiles** has become the main format for **streaming and rendering 3D geospatial content on the web** — lidar, derived meshes, oblique imagery, 3D buildings, point clouds.
- Two needs: (1) a tool to **view** 3D data, and (2) tools to **convert** existing data sets into 3D Tiles — the challenge being to do both **with open-source tools only**.

## [8:33](https://youtu.be/owQW-AUjk0U?t=513) The Two-Part Answer: MapStore + Digital Twin Toolbox

- **Viewing:** **MapStore** — a performant WebGIS for **visualizing, styling, measuring, and browsing 3D data** in 3D Tiles format, with many functions out of the box.
- **Converting:** the **Digital Twin Toolbox** — a well-driven set of open-source tools that support the conversion process to 3D Tiles.
- **Key insight:** the right conversion tools **depend on how the source data was collected** and on the format, so the toolbox must let you catch "all the shades of gray" — visualize/inspect/assess inputs, manipulate data (classification, decimation), and tune tiling options, CRS, and other georeferential adjustments.
- **Current input support: shapefiles and LAS files.** The toolbox orchestrates processing chains behind a **user-friendly UI**.

## [12:21](https://youtu.be/owQW-AUjk0U?t=741) The Demo Goal — Washington D.C. from Open Data

- Final target: a **sub-sample of Washington D.C.** built entirely from **downloadable open data**, converted into 3D Tile data and viewed in MapStore. The sample data is provided so viewers can replicate it.
- **Three data types** are demonstrated (all meaningful to a digital twin):
  - **Building volumes** — from a **shapefile of footprints**, extruded into volumes.
  - **Trees** — an **instanced glTF model per tree point**.
  - **Wider urban environment** — an **airborne-lidar point cloud**, processed and tiled.
- **Why 3D Tiles:** it's an **OGC open standard** and is built to **stream massive 3D geospatial content**. Output is viewed in an **embedded MapStore viewer**.
- The toolbox is **ongoing work — not production ready**, but already functional. `[REVIEW: presenters repeatedly stress pre-release status]`

## [15:31](https://youtu.be/owQW-AUjk0U?t=931) Setup — Docker + Git, then localhost:3000

- **Repo:** hosted on **GitHub under the GeoSolutions-IT organization** (`digital-twin-toolbox`).
- **Prerequisites:** **Docker** (or **OrbStack**) — Linux/Windows/Mac — plus **Git** (used only to clone the repo).
- **Steps:**
  1. `git clone` the repo into your workspace → creates the `digital-twin-toolbox` folder.
  2. Copy the sample env file (**`.env.sample` → `.env`**); the defaults work as-is.
  3. Run **`docker compose up`** from inside the folder.
- **First run builds the web-app image (~20 min); later runs are fast** because the image is cached.
- The stack starts **three containers**: **PostGIS** (used by some processes), **nginx** (endpoint management), and the **Digital Twin Toolbox** app (bundles all the open-source conversion libraries). When you see "listening on…", open **`http://localhost:3000`** (the default and, for now, only entry point).

## [18:10](https://youtu.be/owQW-AUjk0U?t=1090) The Three-Panel UI

- **Left — Controls:** change based on the selected input type (**shapefile** or **LAS** for now); switch with a select. The UI restructures to expose the relevant actions and variables.
- **Center — 3D viewer:** a **preview/debug** surface to inspect the geometry that will become 3D Tiles.
- **Left/bottom — Process feedback:** a **log of all background processes and UI actions** — essential in this early phase for seeing what's happening when something fails.
- **Navigation:** left-drag to pan, right-drag to rotate, mouse wheel to zoom.

## [19:49](https://youtu.be/owQW-AUjk0U?t=1189) The Workflow Model — `data/` → `tileset/`

- Two main directories: always start from a **`data`** directory and produce into a **`tileset`** directory, sometimes looping back to `data` to create a new input.
- **Three core processes shown today:**
  1. **Conversion of shapefiles** (polygons and points).
  2. **Processing of point-cloud data** — adjustments (e.g. datum shift, colorization) that produce a **new LAS file** as input.
  3. **Conversion of point cloud → 3D Tiles.**
- Plus one **experimental** process: **lidar → 3D mesh** (uses Blender, still ongoing).

## [21:31](https://youtu.be/owQW-AUjk0U?t=1291) Loading the Sample Data

- Download the **sample zip** and place its contents in the toolbox's **`static`** folder. The important subfolder is **`static/data`** (empty by default).
- **Contents of the sample:**
  - A **LAS file** (the point cloud).
  - An **ortho-photo TIFF** tiled to match the LAS — used for **colorization**.
  - `buildings_3D` shapefile (**EPSG:26985**) — building footprints for the volumes.
  - A **trees** shapefile — urban furniture points.
- **Rule:** shapefiles must be **inside a zip**; LAS files do **not** need to be zipped. You can **drag-and-drop** new inputs into `static/data` and refresh the page even while the app is running.

## [26:49](https://youtu.be/owQW-AUjk0U?t=1609) Buildings — Extruding Footprints into Volumes

- Select the **building footprints** shapefile → the 3D view renders immediately. The footprints already carry a **Z coordinate** (they sit in 3D, aligned to terrain), not flat.
- **Geometry options** control the extrusion: **lower limit, upper limit, height (m)**. A constant (e.g. 0 → 100) extrudes everything to the same height — useful only as a preview.
- **Per-feature extrusion via expressions:** the input carries **min Z / max Z per feature**, so set **lower limit = min Z**, **upper limit = max Z** to get the correct height per building.
- **Advanced expressions:** because Z here is measured above sea level but the geometry is true 3D, you can use computed expressions like **`$mean_z`** (the per-feature minimum Z) and extrude by **(max Z − min Z)**, starting from the min Z — leaving the lower limit blank lets the tool keep the default geometry base and apply only the computed upper limit.
- The workflow **auto-swaps** lower/upper limits if they're inverted.
- **Extrusion values become baked into the 3D Tiles** — they're persistent and can't be changed later in the final view.

## [32:28](https://youtu.be/owQW-AUjk0U?t=1948) Tiling the Buildings — pg2b3dm

- **Tiling options:** **features per tile** (default **100**) and **geometric error** (controls the camera distance at which content displays; e.g. 500 = visible from farther away; default here **~250 m**). Tune after testing.
- Click **create tileset** → the process uses **PostGIS** to store the geometry and the open-source library **`pg2b3dm`** (polygon-in-PostGIS → 3D Tiles).
- A **preview button** opens the resulting 3D Tiles in a new window. Scrolling out makes tiles disappear once outside the camera's geometric-error range (on-the-fly pixel-error computation based on camera position).
- **Debug volume** option draws **bounding boxes** showing where tiles were cut.
- Result: **building volumes as 3D Tiles** — step one complete.

## [34:49](https://youtu.be/owQW-AUjk0U?t=2089) Trees — Instancing glTF Models on Points

- Point shapefiles follow a slightly different workflow: **each point gets a 3D model instance**. Models are **glTF/`.glb`**, stored in **`static/glb`**; defaults include a **cube** and a **cone**. You can add your own (e.g. modeled in **Blender**) to the folder.
- **Geometry options for points:** no upper/lower limit — instead **model, rotation, scale, translation.** Set the model by string, e.g. `"tree.glb"`, to render trees.
- **Expressions on any field:** scale each tree by its **height** attribute. Note units — the D.C. height is in **feet**, so multiply by **~0.348** to convert. These transforms are **baked into the 3D tile** and can't be changed afterward.
- **Rotation by property** — e.g. orient a cone to represent a viewpoint direction.
- **Tiling** uses **`py3dtiles`** (`py3dtiles export`). The debug preview shows face-visibility colors (not the model's real colors); the final MapStore preview shows the real model and lets you inspect the generated tiling.

## [41:21](https://youtu.be/owQW-AUjk0U?t=2481) Point Cloud — Preview, Datum Shift & Colorization (PDAL)

- Selecting a **LAS file** shows no preview until you click **create data sample** (cached after first run) — used to check whether the cloud already carries **RGB** color.
- **Two problems to fix before tiling:**
  1. **Vertical datum.** The elevation here is **above sea level**, but **CesiumJS (the MapStore engine) expects heights above the ellipsoid** — so the cloud must be **reprojected/shifted**.
  2. **Colorization.** Apply RGB from the ortho-photo TIFF.
- **Process data** step handles both, producing a **new LAS file** (e.g. `196_processed`):
  - Pull the **CRS from metadata** (here **EPSG:26985**).
  - For the datum shift, download a **geoid grid** from the **PROJ repo** and place it in the toolbox's **`v_datum`** folder (e.g. a `.gtx` geoid).
  - Configure **from CRS → to CRS** (using a **PROJJSON**), targeting the **ellipsoid** of 26985, and point the raster to the **ortho TIFF** for color.
- This runs a **PDAL pipeline** — visible as a generated **JSON** doing colorization (TIFF), input LAS, **reprojection filter (in-SRS → out-SRS)**, and output to the processed file. You can watch the raw PDAL command in the Docker logs.
- After processing, select the `…_processed` cloud → the preview now shows the **colorized** cloud (datum shift applied but not visually obvious).

## [47:24](https://youtu.be/owQW-AUjk0U?t=2844) Tiling the Point Cloud → 3D Tiles

- Skip the process-data step and go to **tiling options**: set the **SRS authority number** (the **26985** detected earlier) and a **geometric factor** (adjusts geometric error, e.g. **0.15**) — tune per use case.
- Click **create tileset** → this input uses the **`py3dtiles`** Python library (the toolbox picks a **different library per input type**). Progress is logged; watch the backend state.
- **Classification is preserved:** if the cloud carries a classification, the process keeps it, and a **color-by-classification** button lets you view it.
- Result: the **final point-cloud 3D Tiles**. Debug-tiles view lets you check the tiling structure. This completes **the three-element digital twin: buildings + trees + point cloud.**

## [50:15](https://youtu.be/owQW-AUjk0U?t=3015) Experimental — Point Cloud → 3D Mesh

- Uses **Blender** to build a **mesh from a point cloud**; still ongoing work.
- Not optimal yet — issues on vertical-stage construction, and tileset generation can take **~30 minutes** — so not demoed live, but steps are in the slides/wiki.

## [51:20](https://youtu.be/owQW-AUjk0U?t=3080) Viewing the Full Twin in MapStore

- Preview any single tileset via the toolbox, or check tilesets at the top and **show them together in the embedded MapStore viewer**. All tilesets live in the `static/tileset` folder — copy/host the output wherever you like.
- **In MapStore you can:** increase point size, style points and each feature, and **query elements** — the original shapefile attributes ride along inside the 3D model, so you can query and **apply attribute-driven styling** (e.g. classify points by a value property).
- **MapStore tools:** measurement tool, map views, etc. Links to MapStore releases, repo, and docs are provided.

## [54:24](https://youtu.be/owQW-AUjk0U?t=3264) AI Point-Cloud Classification (Future Work — Georgios Pipis)

- **What it is:** assigning a **class label to each point** (e.g. buildings=red, vegetation=green, roads=gray, ground=yellow) so the system understands the **semantics** of the scene. Useful for 3D urban reconstruction, and beyond (self-driving, inspection, autonomous navigation) — here the focus is **urban** classification.
- **Approaches, in order of automation:**
  - **Manual labeling** — slow, but still used to **generate ground-truth training data**.
  - **Deterministic rule scripts** (e.g. "this color + this shape → tree") — brittle across different scenes.
  - **Machine learning / deep learning** — **support vector machines, random forest, PointNet** — outperform handcrafted rules.
- **Key caveat:** model accuracy is **highly dependent on the training set**. An indoor-trained model won't predict outdoor features (cars, trees) well.
- **Experiment plan:** prepare a **balanced, heterogeneous** data set → **parameterize/fine-tune** → train → **evaluate on unseen data** → compare models.
- **Findings:**
  - A model trained on **sparsely populated areas** (parks/villages; classes: ground, buildings, vegetation, vehicles) was accurate on sparse scenes but **failed on dense urban scenes** (predicted almost everything as buildings).
  - Retraining on the **Washington D.C. open data set** (classes: vegetation, buildings, ground, water), tuned for an **accurate but lightweight** model, gave much cleaner predictions on dense and sparse urban scenes — and generalized to a **different city/country** unseen by the model.
- Classification results were tested inside the Digital Twin Toolbox (toggle a **classification checkbox**); a future version will let users **auto-classify** point clouds.

## [1:03:47](https://youtu.be/owQW-AUjk0U?t=3827) Roadmap / Future Work

- **Harden point-cloud classification** (plus UI for managing it from the control panel).
- **Improve point-cloud → mesh** generation.
- **Enrich final 3D Tiles** — better level-of-detail and tiling system.
- **Automation** — reduce the currently manual, one-element-at-a-time UI/CLI work, including **batch processing** of many elements into a bigger model.
- Credits: the **Municipalities of Genova and Florence** contributed to the toolbox and MapStore 3D capabilities. A **pre-release** is on GitHub, with a **Wiki** covering functionalities, configuration properties, the concepts, and **tutorials on the same D.C. data**.

## [1:07:56](https://youtu.be/owQW-AUjk0U?t=4076) Q&A — Key Technical Answers

- **Different models per tree type by attribute?** Yes — reference a property that holds the model name and append `.glb` (e.g. `genus_name + ".glb"`); the matching model must exist in the `glb` folder.
- **Attach metadata to the 3D Tiles?** Not directly — the toolbox only carries **native shapefile feature properties** and **point-cloud classification** (if present).
- **3D Tiles on GeoNode / MapStore?** MapStore already supports 3D Tiles **as a visualization client**; **3D Tiles support in GeoNode** is coming in the next MapStore release.
- **Tiling large surface point clouds?** Approach is to **pile/split the data** (easier to parallelize). Tested formats: **LAS/LAZ**; splitting via **PDAL** (which can also tile). Batch processing is on the roadmap.
- **Clamp-to-ground / display above terrain?** Provided on the **MapStore side**; the toolbox pipeline itself expects a **ready shapefile with the correct Z** (no terrain-draping step yet). For point clouds you can use a **geoid to shift the vertical datum**.
- **3D Tiles point cloud below terrain?** Yes — mind the **vertical datum** at generation; MapStore offers **vertical offset** in styling/layer-properties, and map views can **clip the ground** to place data underground (camera navigation is a planned improvement).
- **Lidar or photogrammetry?** The D.C. data is **airborne lidar**; photogrammetry is future work.
- **BIM / IFC?** Not via the toolbox yet, but **MapStore supports IFC models directly**; importing IFC → 3D Tiles is a noted potential improvement.
- **Geodetic datum for extrusions?** Uses a geodetic datum with a **global geoid** for the vertical shift; **ellipsoidal lidar works right away**, otherwise pick a precise geoid for conversion.
- **Overlay two epochs of the same place?** Create two 3D Tiles models in MapStore and use **opacity** to compare.
- **Syncing virtual ↔ physical (true digital twin with live sensor data)?** Out of scope today — this webinar covered **representation/structure**, not live sensor feeds. `[REVIEW: presenters call live-sensor syncing "a new webinar" / open topic]`

---

## Tools & Links

- **MapStore** — open-source WebGIS viewer (CesiumJS-based 3D): https://mapstore.geosolutionsgroup.com/
- **Digital Twin Toolbox** — Dockerized conversion toolbox: GitHub under the **GeoSolutions-IT** org (pre-release + Wiki with D.C. tutorials)
- **CesiumJS** — 3D geospatial engine underlying MapStore's 3D: https://cesium.com
- **3D Tiles** — OGC open standard for streaming massive 3D geospatial content
- **pg2b3dm** — open-source: polygons in PostGIS → 3D Tiles (used for building volumes)
- **py3dtiles** — Python library: points / point clouds → 3D Tiles (trees + lidar)
- **PDAL** — Point Data Abstraction Library: reprojection, vertical-datum shift, colorization, tiling/splitting
- **PostGIS** — geometry storage backing the tiling processes
- **PROJ** — source of the **geoid grids** for vertical-datum conversion
- **Blender** — used for custom glb models and the experimental point-cloud → mesh
- **PointNet / random forest / SVM** — AI point-cloud classification approaches under investigation
- **GeoServer / GeoNode / GeoNetwork / GeoTools** — the wider GeoSolutions OSS stack
- Contact: **info@geosolutionsgroup.com** · recordings on the GeoSolutions Group YouTube channel
