# Digital Twins Go Geospatial With OpenUSD, 3D Tiles, and Cesium — Sean Lilly (Cesium)

Source: https://youtu.be/kZzoAwrMYT0
Speaker: Sean Lilly (Cesium) — SIGGRAPH 2023 OpenUSD Day · published Aug 18, 2023 · ~16 min

> A Cesium engineer explains how **OGC 3D Tiles** and **OpenUSD (Universal Scene Description)** combine to place design models in real-world geospatial context — the backbone of an interoperable digital twin. Covers the taxonomy of geospatial data (point clouds, 3D buildings, photogrammetry reality models, vector, voxel, instance models, global imagery/terrain), why 3D Tiles' **hierarchical level-of-detail + streaming** is required at gigabyte-to-petabyte scale, and the **Cesium ion → Cesium Native → Cesium for Omniverse** pipeline. The load-bearing technical lesson is the **coordinate-system problem**: 3D Tiles is global **WGS84** (~6M-meter range, no fixed "up"), so you convert to a **local ENU tangent-plane** frame before dropping USD assets in — the same "where does it sit on the globe" problem WorldView and the GeoSolutions twin also solve.

> **Related:** The industrial/OpenUSD-and-Omniverse counterpart to the browser stacks in [[vibe_coded_palantir_worldview_bilawal]] and [[cesiumjs_zero_to_hero_gisworld]], and to the OSS-3D-Tiles-serving workshop in [[urban_digital_twins_opensource_geosolutions]] — all four center on **3D Tiles + glTF** as the streaming format. Note: Cesium ion, CesiumJS, and Cesium Native are free/open; **NVIDIA Omniverse** here is the proprietary industrial runtime (contrast the fully-free browser paths). Relevant to any GrimGlow move into Unreal/Unity/USD.

---

## [0:15](https://youtu.be/kZzoAwrMYT0?t=15) Cesium — Open Platform for 3D Geospatial

- Cesium builds an **open platform for 3D geospatial**, specializing in rendering **massive real-world digital representations**.
- Open-source runtimes: **CesiumJS** (2010, web/JS virtual globes), **Cesium for Unreal** (2020), **Cesium for Unity**, and **Cesium for Omniverse** (most recent).
- **Open-standards co-creators:** **glTF** (CesiumJS was one of the first glTF loaders) and **3D Tiles**.

## [1:26](https://youtu.be/kZzoAwrMYT0?t=86) Why USD — It's Everywhere in AEC

- SIGGRAPH 2022 was Cesium's first deep dive into **USD**, ahead of building Cesium for Omniverse (which is built on USD).
- Key observation: **USD is used far beyond animation** — heavily in **architecture, engineering, and construction (AEC)**. That prompted the question: **how do we bring geospatial data into this ecosystem?**

## [2:10](https://youtu.be/kZzoAwrMYT0?t=130) The Forms of Geospatial Data

- **Point clouds** — LiDAR-captured, high-resolution; points carry color, intensity, classification (can style by classification).
- **3D buildings** — e.g. **Cesium OSM Buildings** (global coverage).
- **Reality models** — photogrammetry-produced, high-res textured meshes (~cm resolution).
- **Vector data** — points/lines/polygons draped on the surface.
- **Voxel data** — e.g. time-dynamic temperature of the Gulf of Mexico.
- **Instance models** — e.g. Philly Tree Maps.
- **Global imagery and terrain.**

## [3:07](https://youtu.be/kZzoAwrMYT0?t=187) The Common Constraint — Massive Scale

- All these datasets are **gigabytes → terabytes → petabytes**. You **can't fit them on a single device**.
- Therefore you **need a level-of-detail system and a streaming system** — which is exactly what **3D Tiles** provides.

## [3:36](https://youtu.be/kZzoAwrMYT0?t=216) Why Geospatial Context Matters for Digital Twins

- Geospatial data lets designers **make better decisions with real-world data**.
- Export a CAD building to USD and it sits in **a void**; what you want is to **place the design in real-world context.**
- **Pipeline:** DCC tools → USD; real-world basemap (e.g. **Google Maps Platform 3D Tiles API**) → 3D Tiles; both merge in **Omniverse** as layers.
- Enables **simulations** — e.g. **shadow studies** (how a building shades neighbors / is shaded), which can send you back to edit the design.

## [4:53](https://youtu.be/kZzoAwrMYT0?t=293) Demo 1 — Earth-2 Climate Simulation (with NVIDIA)

- **ICON** simulation at **1.25 km resolution** (vs the typical 25 km) — visible cloud/thunderstorm detail over Taiwan and Africa.
- City-scale: **Ernst-Reuter-Platz, Berlin** airflow, using **PALM** data + volumetric **ICON** data — insight for sustainable urban design and climate science.

## [6:21](https://youtu.be/kZzoAwrMYT0?t=381) Demo 2 — Cape Canaveral Spaceport Digital Twin (Cesium + NVIDIA + US Space Force)

- Goal: **operational unification** across SpaceX, ULA, Blue Origin, NASA, Space Force, Air Force.
- **Omniverse on USD** enables interoperability across tools and data types (including **3D Tiles**).
- **Rocket-launch hazard simulation:** flight-caution areas as geolocated points; ground **terrain via a plug-in connecting Omniverse to Cesium's 3D Tiles service**.
- **Live telemetry** (transponders/radar) drives synchronized objects — visually confirm a plane is outside hazard zones; rocket telemetry drives the launch vehicle's motion **connected to USD**.
- Teams can view the same twin in their **preferred tool** (e.g. a Unity-based app) — connecting across **vendor/software silos**.

## [8:46](https://youtu.be/kZzoAwrMYT0?t=526) 3D Tiles — The Standard for Massive 3D Geospatial

- **3D Tiles:** open standard for massive 3D geospatial data; started by Cesium **2015**, became an **OGC Community Standard 2019**.
- Think of it as a **spatial subdivision for glTF** via **hierarchical level of detail**: a **tree of tiles** — root = least detailed, leaves = highest resolution; **each tile is a glTF model**.
- **Advantage: stream only what the view needs** — no full dataset in memory; camera parameters select the tiles to load.

## [9:36](https://youtu.be/kZzoAwrMYT0?t=576) 3D Tiles vs glTF — Who Does What

- **3D Tiles** provides the **spatial subdivision**: a **bounding volume hierarchy** + **geometric error** (which determines when a tile refines to its children).
- **Each tile is a glTF** carrying geometry + textures, with compression extensions: **Draco / meshopt** (geometry) and **KTX2 / Basis Universal** (textures).
- glTF can also carry **feature identification** (which vertices/texels are windows vs doors) and **per-feature metadata**.

## [10:24](https://youtu.be/kZzoAwrMYT0?t=624) 3D Tiles vs USD — Complementary Strengths

- **3D Tiles:** massive scale, **streaming**, runtime efficiency (get to the GPU fast).
- **USD:** **non-destructive editing, composition, flexible scene description.**

## [10:52](https://youtu.be/kZzoAwrMYT0?t=652) The Pipeline — Cesium ion → Cesium Native → Runtimes

- **Cesium ion:** ingest source data (**OBJ**, **LAS** point clouds, **GeoTIFF** terrain/imagery) → process into **3D Tiles** via domain-specific tilers + simplification → store in **S3**, stream out.
- **Pre-packaged hosted data:** **Cesium World Terrain, Cesium OSM Buildings, Bing imagery**; plus external providers (**Google Maps Platform** 3D Tiles). Local-disk 3D Tiles also work.
- **Cesium Native:** a **C++ open-source, engine-agnostic** 3D-Tiles streaming library — shared across Cesium for Unreal / Unity / Omniverse.
- **Cesium for Omniverse:** an extension on NVIDIA Omniverse; 3D Tiles stream in via the extension, DCC tools arrive via USD.

## [12:10](https://youtu.be/kZzoAwrMYT0?t=730) The Core Challenge — Coordinate Systems (WGS84 → ENU)

- **3D Tiles is global WGS84:** ~**6 million-meter** range, **right-handed**, **no fixed "up"** (up depends on where you are on the globe).
- **USD:** right-handed, **Y-up or Z-up**, unit size configurable (**default centimeters**).
- **The conversion:** glTF → a few transforms → convert the **global 3D-Tiles frame to a local coordinate system** via a **fixed-frame → ENU (East-North-Up)** transform. A chosen **lon/lat becomes the tangent plane / center of the world.**
- Then **place USD assets in that local space**, and **anchor them by lon/lat** so they stay put. *(This is the industrial-USD analogue of WorldView's OSM-3D-volume centering and the GeoSolutions vertical-datum handling — every twin has to solve "where on the globe.")*

## [13:18](https://youtu.be/kZzoAwrMYT0?t=798) Runtime — USD Scene Description of Tilesets

- Even with 3D Tiles and USD arriving separately, USD represents the **scene description of the tilesets**: a **Cesium tileset Prim** inheriting from a **Gprim** (to assign materials + extents), plus prims for **top-level scene metadata, geo-referencing, and imagery**.
- Uses **TF notices** — if a dataset URL or the geo-reference lon/lat changes, the extension is notified and **reloads the tileset** or reacts accordingly.

## [14:15](https://youtu.be/kZzoAwrMYT0?t=855) Renderer Architecture — glTF → Fabric → Hydra → RTX

- Because 3D Tiles **packages glTF**, it must be turned into a renderable form. Two parallel tracks: the **USD stage** (design models) and **Cesium for Omniverse** (glTF).
- Uses the lower-level **Fabric scene delegate** (a post-composed, efficient version of the stage) → **Hydra** → render delegate → **RTX**.
- **Per frame:** get view-projection matrices → **`update-view` in Cesium Native** selects tiles → convert glTF to **Fabric prims** → set visibility + transforms.

## [15:08](https://youtu.be/kZzoAwrMYT0?t=908) USD Wish List

- **Industry-wide geospatial schemas** — a common way to **anchor objects on the globe** (lon/lat + coordinate system).
- **USD↔glTF alignment**, starting with **material interoperability** (being explored by the **Metaverse Standards Forum** 3D Asset Interoperability group).
- **Improved point-cloud rendering** support (rendering-domain, but core to digital twins).
- **More 3D-Tiles-in-USD interoperability** — e.g. using 3D Tiles to spatially subdivide USD (open research direction).

## [16:11](https://youtu.be/kZzoAwrMYT0?t=971) Learn More

- Cesium's **learning page** has tutorials: given your CAD software, export design models → USD → add to a stage → add layers (**global imagery, terrain, 3D buildings**).

---

## Tools & Links

- **CesiumJS / Cesium for Omniverse / Cesium ion:** https://cesium.com — the free/open 3D-geospatial runtimes + asset service.
- **3D Tiles** (OGC Community Standard, spatial subdivision for glTF) and **glTF** (with Draco/meshopt/KTX2/Basis compression).
- **Cesium Native** — open-source C++ engine-agnostic 3D-Tiles streaming library.
- **OpenUSD** (Universal Scene Description): https://www.nvidia.com/en-us/omniverse/usd/ — non-destructive scene composition.
- **NVIDIA Omniverse** (proprietary industrial runtime built on USD): https://www.nvidia.com/en-us/omniverse/
