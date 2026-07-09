# Ex-Google Maps PM Vibe Coded Palantir In a Weekend (Palantir Noticed) — Bilawal Sidhu

Source: https://youtu.be/rXvU7bPJ8n4
Speaker: Bilawal Sidhu (ex-Google spatial computing / 3D Maps PM, TED technology curator) · published Feb 24, 2026 · ~10 min

> Bilawal builds **WorldView** in **3 days with an army of parallel AI agents**: a browser-based "Google Earth meets Palantir" that fuses **live satellite tracking, commercial + military flight data (OpenSky / ADS-B), real-time CCTV projected onto 3D geometry, seismic data, and simulated street traffic** against **Google's Photorealistic 3D Tiles**, skinned with CRT / night-vision / FLIR shader modes. It trends on X; the **Palantir co-founder responds** that it lacks real proprietary data fusion. The meta-lesson: **open data feeds + agentic coding CLIs have collapsed the geospatial learning curve** — if you have domain expertise, build now.

> **Related:** Second source in the **Spatial** category (after "The Internet's Hidden 3D Model of the World"). Directly relevant to GrimGlow's Three.js/3D ambitions, and his parallel-agent workflow (multiple CLI agents, one per subsystem) mirrors the assembly-line orchestration pattern used across the ScriptHammer family.

---

## [0:03](https://youtu.be/rXvU7bPJ8n4?t=3) It Went Viral Overnight

- Posted the project at night, **woke up trending on X** — people sharing it as "vibe coded Palantir," "Palantir is going down."
- **WorldView** = real-time satellite tracking + live CCTV cameras + military and commercial flight data, **fused against a 3D model of the world**, skinned to look like a classified intelligence system.
- Grok's summary: *"Ex-Google PM builds spy-thriller geospatial dashboard."*
- Built in **3 days with an army of AI agents.** The **Palantir co-founder** weighed in: he's *"missing real proprietary data fusion."* Fair — but the point is what's possible right now.
- Core message: **if you've got domain expertise, this is the time to put it to work.**

## [0:50](https://youtu.be/rXvU7bPJ8n4?t=50) The Goal — Google Earth and Palantir Have a Baby

- Foundation: the **full globe in Google's Photorealistic 3D Tiles** — a dataset Bilawal worked on and launched at Google.
- Everything runs **in the browser** against that globe.

## [1:07](https://youtu.be/rXvU7bPJ8n4?t=67) CRT, Night Vision & FLIR — Shader Modes in the Browser

- Number keys switch between **CRT, night vision (NVG), and FLIR** display modes.
- Full parameter control: **sensitivity, pixelation amount**, etc. — all real-time post-processing effects in the browser.
- Camera-preset system for **planning shots** (built for content creation) — jump between framings easily.
- All of it **built custom to his needs "just by talking to AI systems and screenshotting things a little bit."**

## [1:36](https://youtu.be/rXvU7bPJ8n4?t=96) Camera Presets & Landmarks — Centering via OpenStreetMap 3D Volumes

- Jump between cities; the AI **figured out the landmarks per city** (hotkeys Q/W/E/R/T cycle points of interest).
- **Key technique:** when jumping to a point of interest, the camera targets the **OpenStreetMap 3D volume** of the landmark, so it's **perfectly centered**.
- Doing this naively with **latitude/longitude alone** puts the camera off-target — the volume gives you the true center of what you want in the field of view.

## [2:22](https://youtu.be/rXvU7bPJ8n4?t=142) Live Satellite Tracking — Every Satellite in Orbit

- Zoomed out, the globe shows **every satellite currently in orbit, in real time**.
- **Detection mode** renders either a sparse set or the full set of detections, **down to individual satellite IDs** (e.g., NORAD 11574).
- Click any satellite to **track it in orbit** and see its orbital path around the planet — geostationary, geosynchronous, etc.

## [3:12](https://youtu.be/rXvU7bPJ8n4?t=192) Real-Time Flight Data via OpenSky — 6,700+ Planes

- **OpenSky Network** loads **live flight data**: ~6.7K flights at once — every tracked plane on the planet, in real time, against the 3D globe.
- Detection mode + click any plane to **follow its location live**. "This looks like a freaking spy movie."

## [3:57](https://youtu.be/rXvU7bPJ8n4?t=237) Why Not After Effects? Real-Time Motion Graphics

- The same views double as **cinematic visualizations** — why build this in After Effects when it runs real-time in the browser?
- Add **bloom, sharpening, custom filters** — the way you'd build **LUTs** and post-processing stacks in a video editor. **"Just tell the agent to code it for you."**

## [4:26](https://youtu.be/rXvU7bPJ8n4?t=266) Military Flight Tracking via ADS-B

- **ADS-B Exchange** uses **crowdsourced receiver data** to track **military planes** that normal flight-tracking sites don't show.
- Military aircraft render in orange — **open-source intelligence (OSINT)** showing what's happening on the other side of the world.

## [4:58](https://youtu.be/rXvU7bPJ8n4?t=298) Filtering — The Personal Panopticon

- Geospatial data's superpower is **filtering**: isolate just the military planes.
- Demo: hover over **the Pentagon**, zoom out, see nearby military flights, jump into one, and see **which satellites are overhead in real time**.
- Layer military + commercial planes + satellites: **"you have built yourself a personal panopticon, all using open-source data feeds."**

## [5:23](https://youtu.be/rXvU7bPJ8n4?t=323) Street Traffic Simulation — OSM Road Network → Particle System

- Query the **OpenStreetMap road network** and **spawn a particle system that emulates city traffic** (demoed on London Bridge / the City of London).
- Sparse labels work best for showing a whole city; in **NVG and thermal modes** the traffic looks spectacular.
- You could try making footage like this in **Veo** [REVIEW: transcript says "VIO" — almost certainly Google's Veo video-gen model], but **coding it + screen-recording gives far more control.**

## [6:09](https://youtu.be/rXvU7bPJ8n4?t=369) Works Even Where Google Has No 3D Data

- Some places (e.g., **Dubai**) don't allow US companies to 3D-scan, so there's no Google 3D mesh.
- The approach still works via **oblique (off-nadir) satellite imagery** — the Burj Khalifa demo — and the **street-traffic layer still renders on the road network**.

## [6:31](https://youtu.be/rXvU7bPJ8n4?t=391) Real-Time CCTV Projected Onto 3D Geometry

- A custom panel pulls **openly available live CCTV feeds in Austin, Texas** — pedestrians, a first responder passing through.
- Feeds update at **one frame per minute** — not fully real-time, but real data of what's happening in the city.
- Pick a camera → jump to it → the feed is **projected onto the 3D geometry** (the same crosswalk visible in both). "This feels like it shouldn't be legal, but it is."

## [7:30](https://youtu.be/rXvU7bPJ8n4?t=450) Roadmap: Point-Based Camera Calibration

- Next up: a **calibration system** — drop a couple of correspondence points to align each CCTV camera near-perfectly, plus shader work so projections look realistic.
- This replaces what used to be **hours of After Effects fakery** or Google Earth Studio export-and-composite workflows.

## [8:00](https://youtu.be/rXvU7bPJ8n4?t=480) Earthquake & Seismic Data — Layering It Up

- Tags for **every earthquake / seismic event across the globe**.
- Stack the layers — seismic + satellites + military flights — and **"you've got a pretty comprehensive picture of what's going on."** More data streams are on the roadmap; this was a couple of days of work.

## [8:25](https://youtu.be/rXvU7bPJ8n4?t=505) The AI Coding Tools — All of Them Work

- Used **Gemini 3.1, Claude 4.6, and Codex 5.2** (already 5.3 by publish time) — **the version numbers will keep changing; don't fixate on them.**
- The real advice: **get into the CLI tools** — go straight into the terminal and tell the AI what you want.

## [8:45](https://youtu.be/rXvU7bPJ8n4?t=525) Running Agents in Parallel

- Runs **OpenClaw with three or four terminals at once** — working two projects simultaneously, **controlling 4–8 agents**.
- Division of labor: **one agent on shaders/style presets, another on data integration** (building the particle system for street traffic, or the military/flight data layer).
- Doing this in **Blender would have been an order of magnitude harder**; directly in browser code, "it's insane what you can do."

## [9:20](https://youtu.be/rXvU7bPJ8n4?t=560) The Human Still Does the Problem-Solving

- From his Google Maps years: the biggest blocker for the 3D Tiles dataset was developers' **steep learning curve**. That barrier is now gone — "now you can do it, too."
- But **the AI won't do it all**: the traffic view **spawned too many particles and crashed the browser**.
- His fix was a human architectural call: **"do sequential loading — load the main roads first, then the arterial roads."** You do **creative problem-solving while talking to the system.**

## [9:53](https://youtu.be/rXvU7bPJ8n4?t=593) Now Is the Time to Build

- Closing push: go play with the coding editors; see his earlier **"vibe coding for creatives"** video for what the build process actually looks like.
- Theme of the channel going forward: what you can vibe code **for creation and for spatial understanding of the world**.

---

## Data Sources & Links (from video description)

- **Google Photorealistic 3D Tiles:** https://developers.google.com/maps/documentation/tile
- **OpenSky Network** (live flight data): https://opensky-network.org
- **ADS-B Exchange** (military flights, crowdsourced): https://adsbexchange.com
- **CesiumJS** (the 3D globe rendering engine): https://cesium.com
