# CesiumJS in 1 Hour - From Zero to Hero — GISWorld

Source: https://youtu.be/ak--lv10z9Y
Speaker: GISWorld / GIS World Academy (GISWorld-Tech) · published Nov 15, 2024 · ~68 min tutorial (Cesium grant ecosystem)

> A **code-along, end-to-end CesiumJS tutorial** that builds a free browser-based geospatial digital twin from scratch — the applied, "type the code with me" counterpart to the WorldView-style 3D-globe stack. It walks eight concrete skills in one app: standing up your **first `Viewer`** with a **Cesium ion access token** and world terrain; uploading and adding **3D tilesets & glTF resources** via Cesium ion; **clamping CityGML/LOD2 buildings to terrain**; **advanced styling and filtering** of 3D tiles with Cesium `Cesium3DTileStyle` expressions; loading and filtering **LiDAR point clouds**; toggling **BIM models**; animating a **moving object** (aircraft/UAV) along a clamped path; and finally streaming **real-time dynamic entities** (buses/cars) into the scene by polling a **RESTful API** and converting GeoJSON linestrings into timed positions. Everything runs on a free Cesium ion account, a webpack `start` project, and QGIS-authored 2D data.

> **Related:** This is the **code-level entry point for the WorldView CesiumJS stack** — the hands-on "how to actually build the globe" companion to [[vibe_coded_palantir_worldview_bilawal]] (which vibe-codes the same kind of front-end) and to [[urban_digital_twins_opensource_geosolutions]] (the open-source **data → 3D Tiles serving** side that feeds a viewer like this one). It also grounds the reconstruction theory in [[the_internets_hidden_3d_model_bilawal]] (SfM → point clouds → tiles) in real API calls. Relevant to GrimGlow's Three.js / 3D work: the `Viewer`, tileset, styling, entity-animation, and REST-polling patterns here map directly onto browser 3D scene-graph development.

---

## [0:03](https://youtu.be/ak--lv10z9Y?t=3) The Eight Topics This Tutorial Covers

The tutorial is a single complete package (each topic also has its own standalone video). The eight topics:

1. **Getting started with CesiumJS** — set up your first **`Viewer`**.
2. **Add 3D tilesets and resources** to CesiumJS.
3. **Clamp CityGML models to terrain** in CesiumJS.
4. **Advanced styling and filtering** of 3D tiles.
5. **Visualize LiDAR point clouds** in CesiumJS.
6. **Integrate BIM models** into your visualization.
7. **Create interactive movable objects** from **2D data** authored in **QGIS** (or any web-GIS tool).
8. **Add real-time dynamic entities** to CesiumJS with the power of **RESTful APIs**.

- Thanks to the **Cesium team** for supporting the tutorial series (part of the Cesium grant ecosystem).

## [1:12](https://youtu.be/ak--lv10z9Y?t=72) Demo of the Finished App

A tour of what gets built, so you know where the code is headed:

- **Styled 3D tiles** — CityGML buildings colored by **roof type** and by **terrain/building height**.
- **Point cloud** rendering in the front end at acceptable speed, plus **filtering by classification/label** (e.g. isolate water vs. trees on a classified point cloud).
- **BIM data** you can zoom to, show/hide (toggle visibility), and combine with the point cloud to check impacts (e.g. does a new build affect a green/vegetation area).
- **Google photorealistic 3D tiles** combined with the point cloud — the same look as Google Earth's 3D models, but all inside one application instead of jumping between tools.
- **2D data as 3D** — e.g. a **drone/UAV flight path** animated as a moving object (useful to show a client a planned agriculture survey path before a project starts).
- **Real-time entities via REST** — one click visualizes traffic as real object models (a car, a bus, an accident) that are connected to **time** and **coordinates**; you can edit the source data in a web-GIS (**QGIS**) — swap a bus for a car, delete a feature — save, and re-fetch to see the scene update.

## [5:39](https://youtu.be/ak--lv10z9Y?t=339) Project Structure & Starting the Dev Server

- **Repo layout:** three folders — **`start`**, **`final`**, and **`data`**. Open **`start`** in any IDE (presenter uses **PyCharm / JetBrains**) to code along; the completed **`final`** package is pushed to the GitHub repo (link in the description).
- The **`data`** folder is pre-populated with the hard-to-source 3D inputs: **point cloud**, **BIM**, **glb** models, **CityGML** data, and some **static point** features authored in **QGIS**.
- The project is built with **webpack**. (A separate part-3 video covers installing CesiumJS via **CDN + webpack**.)
- Start the app: **`npm start`**. The starter page shows static buttons that don't do anything yet — the tutorial wires them up.

## [8:29](https://youtu.be/ak--lv10z9Y?t=509) Cesium ion Account, Access Token & the First Viewer

- **Create a free Cesium ion account** at **cesium.com** (just an email + password). This is where you upload assets and generate tokens.
- **Access token:** in the ion dashboard's **Access Tokens** tab, use the **default token** or create per-application tokens with specific **read/write permissions** (e.g. whether others may download your source data). Copy the token.
- Store the token cleanly: the project keeps it in a **`cesiumConfig` file** as an exported `accessToken` variable (rather than hardcoding it in `index.js`) and imports it.
- **Wire the token and create the Viewer:**
  - `import ion from 'cesium'` (Cesium **`Ion`**), then set **`Ion.defaultAccessToken = accessToken`**.
  - Create the viewer: **`const viewer = new Viewer('cesiumContainer', { ... })`**, binding it to the **`cesiumContainer`** div (grab its ID) declared in `index.html`.
  - Add world terrain by passing a **`terrainProvider`** built with **`await createWorldTerrainAsync()`**. `[REVIEW: ASR renders this as "create word train async" — read as createWorldTerrainAsync]`
- Refresh: you get the globe with working terrain (visibly 3D when you zoom into mountainous areas).

## [12:23](https://youtu.be/ak--lv10z9Y?t=743) Fly the Camera (Quick Start Snippets)

- The **CesiumJS Quick Start** page has copy-paste snippets; the "**fly the camera to San Francisco**" snippet is used here.
- Paste it in, then remove the CDN-loaded `Cesium.*` prefixes and instead **import the needed classes** — here **`Cartesian3`** and **`Math`** (CesiumJS `Math`) — manually.
- Refresh → the camera flies to San Francisco. (Adding other 3D tiles from Quick Start was covered in an earlier tutorial.)

## [14:32](https://youtu.be/ak--lv10z9Y?t=872) Resources & Assets in Cesium ion

- In the ion dashboard's **My Assets** tab, use **Add Data** to upload models. Example: a **bus-station glb** uploaded as **glTF** — for glTF the object's **center point** is used as the pivot for rotation/placement.
- Uploading centralizes all data in one place, so you don't re-store it on your local machine or server. Upload the tree, bus, bus-station, etc. — origin (built/bought/downloaded/**Blender**-made) doesn't matter.

## [16:36](https://youtu.be/ak--lv10z9Y?t=996) Uploading LOD2 / 3D Tiles & Repositioning a Point Cloud in ion

- Upload **LOD2** data (in the `data` folder) — ion renders it as **3D Tiles**. **Tiling** is CesiumJS's core power: content is rendered based on **zoom level** so only what's needed loads, keeping the end-user browser fast.
- **Point clouds** can be tricky. In the ion asset viewer, the **Adjust Tileset Location** control gives **three arrows (X, Y, Z)** to relocate a point cloud that isn't georeferenced or whose coordinates are off. Reset it if the cloud is already fine.
- **Zoom to Tileset** button jumps to any asset (the same behavior reproduced later in code).
- **Save asset IDs:** the config file defines an **`assetIds`** object collecting every uploaded asset's ID, exports it, and imports it into `index.js`.

## [19:00](https://youtu.be/ak--lv10z9Y?t=1140) Resources vs. Tilesets — Loading Both in Code

- **Distinction:**
  - **Resources** = discrete model objects — the aircraft, bus, tree (loaded from ion assets).
  - **Tilesets** = tiled data — CityGML → 3D Tiles, point clouds, Google photorealistic tiles.
- **Resources** object — each entry loaded via **`Resource.fromAssetId(assetIds.<name>)`** `[REVIEW: ASR "resource dot from asset ID" — read as the ion Resource/asset-from-ID pattern]`:
  ```
  const resources = {
    aircraft: Resource.fromAssetId(assetIds.aircraft),
    bus:      Resource.fromAssetId(assetIds.bus),
    car:      Resource.fromAssetId(assetIds.car),
  }
  ```
- **Tilesets** object — each entry loaded via **`await Cesium3DTileset.fromAssetId(assetIds.<name>)`**:
  ```
  const tileset = {
    citygml:            await Cesium3DTileset.fromAssetId(assetIds.citygml),
    pointcloud:         await Cesium3DTileset.fromAssetId(assetIds.pointcloud),
    bim:                await Cesium3DTileset.fromAssetId(assetIds.bim),
    googlePhotorealistic: await Cesium3DTileset.fromAssetId(assetIds.google),
  }
  ```

## [24:23](https://youtu.be/ak--lv10z9Y?t=1463) Adding Tilesets to the Viewer + zoomTo

- Build an array of the tilesets to show (**citygml, pointcloud, googlePhotorealistic**) and add each with **`viewer.scene.primitives.add(tileset)`**.
- You must tell the viewer where to look: **`await viewer.zoomTo(tileset.citygml)`** (any tileset works; here it zooms to CityGML).
- Refresh → photorealistic, point cloud, and CityGML data all import and render.
- **Initial visibility:** hide layers you don't want on by default with **`tileset.pointcloud.show = false`** and **`tileset.googlePhotorealistic.show = false`**, so only the buildings appear at start.

## [26:37](https://youtu.be/ak--lv10z9Y?t=1597) Styling 3D Tiles — TileStyleManager (Terrain & Roof)

- The project wraps styling in a custom **`TileStyleManager`** class, constructed with the two stylable tilesets: **`new TileStyleManager(tileset.citygml, tileset.pointcloud)`**. It exposes methods like **apply-style** and **generate-colors**, and holds a **terrain-height style** and a **roof-type style**.
- **How a Cesium 3D-tile style works** (see ion Quick Start → **Style and Filtering**):
  - A **`Cesium3DTileStyle`** with a **`color`** property whose value is a **`conditions`** array. Each condition is a 2-element array: **`[expression, colorString]`**.
  - The first element references a **feature property** in the 3D tile, written as `${property}` — e.g. **`${height}`**, `${latitude}`, `${terrain_height}`, `${roof_type}`.
  - Example condition test: `${height} >= 103`, `${height} >= 104`, etc., each mapped to a color.
- **Color generation:** the manager counts the number of classes and uses the **chroma.js** library to generate that many distinct colors (e.g. six classes → six colors), then builds the conditions programmatically.
- **Where properties come from:** some (like `height`) come from the source **CityGML** data; others (like **`terrain_height`**) are **auto-generated by Cesium ion on upload** because the data is **clamped to the Cesium world-terrain model**.
- **Wiring the buttons:** `document.getElementById('btn_roof').addEventListener('click', () => styleManager.applyRoofStyle())` and a matching **`btn_terrain`** → **terrain-height style**. Clicking swaps buildings between roof-type coloring and height coloring.

## [33:50](https://youtu.be/ak--lv10z9Y?t=2030) Point Cloud — Show, Filter & Color

- Add a **`pointCloudStyle`** method to `TileStyleManager`. It defines two things, mirroring the building style: a **color condition** and a **show query**.
- **Color condition** — style by the point's **`${classification}`** value:
  ```
  color: { conditions: [
    ['${classification} === 1', 'color("green")'],
    ['${classification} === 9', 'color("lightblue")'],
  ]}
  ```
- **Show query (filtering)** — a boolean expression that keeps only the wanted points, e.g. `${classification} === 1 || ${classification} === 9`, then **`.apply()`**.
- **Why filter, not just color?** Filtering **reduces the number of points rendered** in the front end, saving render time and **increasing performance** — the key reason to use a show query alongside coloring.
- **Wire the point-cloud toggle** (a checkbox → `change` event):
  ```
  document.getElementById('pointCloud').addEventListener('change', (event) => {
    if (event.target.checked) {
      tileset.pointcloud.show = true;
      // apply styleManager point-cloud style
    } else {
      tileset.pointcloud.show = false;
    }
  })
  ```
- Result: the point cloud renders fast (even under screen-recording load) and toggles cleanly.

## [41:27](https://youtu.be/ak--lv10z9Y?t=2487) BIM Data — Zoom & Toggle Buttons

- **BIM is the easy one** — two buttons: a **zoom-to** and a **show/hide** toggle. This "zoom to any tileset" button is a reusable component you can drop anywhere.
- **Zoom button** (`click`): `document.getElementById('zoomToBim').addEventListener('click', () => viewer.zoomTo(tileset.bim))`.
- **Toggle button** (`change`): first ensure BIM is added to the scene via **`viewer.scene.primitives.add(tileset.bim)`**, then flip visibility with **`tileset.bim.show = event.target.checked`** (or `!tileset.bim.show` to toggle). Zoom, add, and show/hide all work together.

## [47:56](https://youtu.be/ak--lv10z9Y?t=2876) Google Photorealistic 3D Tiles Toggle

- Even simpler: when photorealistic is turned on, hide the CityGML tiles, and vice versa.
- Toggle handler (`change`):
  ```
  if (event.target.checked) {
    tileset.google.show = true;
    tileset.citygml.show = false;
  } else {
    tileset.google.show = false;
    tileset.citygml.show = true;
  }
  ```
- Turning it on/off swaps between the CityGML city and the Google photorealistic tiles as they render in.

## [51:20](https://youtu.be/ak--lv10z9Y?t=3080) Interactive Moving Object — Aircraft Along a Path

- Wire a **zoom-to-aircraft** button (`click`) that instantiates a custom **`MovingObject`** class:
  ```
  const mover = new MovingObject(viewer, flightData, /*interval*/ 1, aircraft);
  mover.addMovableEntity(resources.aircraft);
  ```
  Arguments: the **`viewer`**, the **`flightData`**, an **interval** (time between successive positions along the path), and the object type.
- **Authoring the path in QGIS:** the flight path started as **UAV points** in a GeoJSON (`UAV_points.json`). In QGIS you place/copy a handful of points (here ~45), then **export as GeoJSON** — **critical: reproject the coordinate system to WGS84 (EPSG:4326)** on export.
- The imported **flight data** is a GeoJSON **FeatureCollection**: each feature has properties and **point coordinates**.

## [55:16](https://youtu.be/ak--lv10z9Y?t=3316) Inside the MovingObject Class

- Constructor takes the **viewer** (where to draw the model), the **path** (flight path points), a **speed**, and an **object type**.
- **Timing:** a `configTime` step assigns a time to each point. For each position it **clamps the point to Cesium terrain** (a clamp function), producing an updated position, then advances by the **interval/time-step** between positions.
- It builds a **`Cartographic` (latitude/longitude + height)** per step and passes everything into a **`SampledPositionProperty`** as time-tagged positions. `[REVIEW: ASR "position property as a time and position" — read as a time-sampled position property]`
- **Adding height to 2D points:** QGIS UAV points are X/Y only (no Z). A loop assigns increasing height per iteration (e.g. +1 m per step → a smooth climb from 0 up to ~20 m), and **each height is again clamped to Cesium terrain** (terrain is not flat). The presenter flags this height section as hardcoded/not elegant but functional. `[REVIEW: presenter repeatedly calls the height logic "hardcoded" — a rough tutorial shortcut, not production code]`
- Running the function adds the fully time-and-position-configured object to the viewer, then **zooms to the entity**. Reuse: drop this class into a project to get animated moving-object models.

## [1:00:14](https://youtu.be/ak--lv10z9Y?t=3614) Real-Time Dynamic Entities via a REST API

- The most valued part: **poll a REST API for linestring coordinates** and visualize live **bus/car movement**.
- **The API** returns GeoJSON **linestrings** (drawn in QGIS). The moving-object model needs **points**, so linestrings must be converted per-vertex into points — a `convertLineToPoints(feature)` helper does this so the existing `MovingObject` can be reused unchanged.
- **Fetching** — an `axios` GET (install with `npm install axios` if the starter didn't):
  ```
  const apiUrl = "http://localhost:1818/.../cesium_linestring/...";  // project/API endpoint
  const fetchAllData = () => {
    axios.get(apiUrl).then((response) => {
      viewer.entities.removeAll();                 // clear stale data before redrawing
      response.data.features.forEach((feature) => {
        const objectPath = convertLineToPoints(feature);
        const mover = new MovingObject(viewer, objectPath, /*step*/ 5, bus);
        mover.addMovableEntity(resources[feature.properties.usage]);  // "bus" or "car"
      });
      viewer.zoomTo(viewer.entities);
    }).catch((error) => console.log(error));
  }
  ```
- **Why `viewer.entities.removeAll()` before each fetch:** with live/traffic data you must show only current state. Entities added to the viewer persist until you refresh or overwrite them, so removing all first acts like a refresh. (Alternatively use **remove-by-ID** for finer control.)
- **`feature.properties.usage`** drives which asset (bus vs. car) is instanced, connecting the feature to its ion **asset ID**.
- **Time-step controls speed:** a larger step (e.g. 10) means the object needs more time to travel point-to-point → **slower**; a smaller step (e.g. 5) → **faster**.
- **The button** (`click`): `document.getElementById('fetchData').addEventListener('click', () => fetchAllData())`.
- **Gotcha — API port / CORS:** the API is only reachable on the expected host/port (**`localhost:1818`**); the wrong port throws an error. (Publishing the API URL like this is fine for a tutorial but not production-safe.)
- **Live editing loop:** edit the source in **QGIS** — change a car to a bus, draw a new car linestring ahead of it in the same direction, save — then click **fetch** again and the scene redraws with the updated bus + car. This closes the "edit 2D web-GIS data → see it live in the 3D twin" loop.

---

## Tools & Links

- **CesiumJS** — open-source JavaScript 3D-globe/geospatial engine: https://cesium.com/learn/cesiumjs-learn/
- **Cesium ion** — free account for hosting/tiling assets, generating **access tokens**, uploading glTF/LOD2/point clouds, and repositioning tilesets: https://cesium.com
- **Tutorial repo** (start / final / data, webpack project): https://github.com/GISWorld-Tech/cesium_js
- **Cesium ion Quick Start → Style and Filtering** — reference for `Cesium3DTileStyle` conditions/expressions.
- **QGIS** — authoring 2D data (UAV points, linestrings); export as **GeoJSON in WGS84 / EPSG:4326**.
- **chroma.js** — generating N distinct colors for classification-based styling.
- **axios** — HTTP client used to poll the REST API (`npm install axios`).
- **webpack** — bundler for the starter project (`npm start`).
- **Key CesiumJS APIs used:** `Ion.defaultAccessToken`, `Viewer`, `createWorldTerrainAsync` (`terrainProvider`), `Cartesian3`, `Cesium3DTileset.fromAssetId`, `viewer.scene.primitives.add`, `viewer.zoomTo`, `Cesium3DTileStyle` (color conditions + show query), `viewer.entities` / `removeAll`, `Cartographic`, time-sampled position property (clamp-to-terrain).
- Cesium grant ecosystem — series supported by the **Cesium team**.
