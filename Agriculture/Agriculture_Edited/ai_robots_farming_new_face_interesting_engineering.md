# UV Robots, Cotton Bots & ChatGPT on a Broccoli Farm: The New Face of Farming — Interesting Engineering

Source: https://youtu.be/qmf1TEu17ZI
Speaker: Interesting Engineering ("IE Explains") · published Jul 30, 2026 · ~9 min

> A survey of **AI + robotics in agriculture as of 2026**: four real deployments in the field, the 30-year arc from GPS tractors to autonomous fleets, the engineering that lets a machine tell a weed from a crop, and the economics that decide who actually benefits. Thesis: **the capability is here and it works — the constraint was never engineering, it's access and economics.** Big industrial farms automate first (scale justifies cost); the wild card is **generative AI dropping the barrier** so one curious person can do what used to need an engineering team.

> **Category note:** first source in the new **Agriculture / AgTech** category (precision agriculture, farm robotics, autonomous machinery, AI agronomy).

> ⚠️ **Sourcing note:** every stat below is the video's own claim (vendor/market figures) as of **2026** — verify before relying. Company and person names (TRIC Robotics, XAG, Grain Weevil, Hiroki Tomiyasu, Blue River Technology) are transcribed by ear.

---

## [0:00](https://youtu.be/qmf1TEu17ZI?t=0) Four scenes from farming in 2026

- **California:** a fleet of robots hunts pests on strawberries **at 2 AM, zapping them with ultraviolet light instead of pesticides.**
- **China (Xinjiang desert):** cotton fields "larger than some countries" run **with barely a human in sight.**
- **Nebraska:** a 2-ft robot crawls a grain silo doing **one of the deadliest jobs in American farming so a human never has to.**
- **Japan (Hokkaido):** a former government worker with **no coding or farming background runs a 100-hectare farm using ChatGPT.**
- **Why now:** farmers are aging, labor is scarcer and more expensive, and climate stress makes every season less predictable. The question the video poses: can AI/robotics **actually transform how we grow food**, or are these "fun toys for the oldest industry on Earth"?

## [1:15](https://youtu.be/qmf1TEu17ZI?t=75) The machines actually in the field

- **TRIC Robotics** (San Luis Obispo, CA): autonomous robots patrol at night because **UV-C light kills pests and mildew most effectively then and stresses the plant least.** Claimed results from the UV-C + bug-vacuum combo: **lygus bugs −35%, spotted-wing fruit flies −58%, spider mites −~⅓, mildew pressure −30%, with almost no spraying.** Sold **as a service** — farmers don't buy the robot.
- **XAG "super cotton fields"** (Xinjiang grows ~**90% of China's cotton**): camera/sensor/self-driving robots read each plant, compute an exact fertilizer/pesticide dose, and spray precisely. **One robot ≈ 7 hectares/hour; one technician runs 5 at once.** By end of 2025, spread across **>130,000 hectares.**
- **Grain Weevil** (a Nebraska father-and-son team): grain bins are one of farming's deadliest places (farmers suffocate in flowing grain yearly). This **2-ft robot uses spinning augers to make a controlled avalanche**, leveling/breaking grain from the outside **so no human climbs in.** **>100 sold.**
- **Hiroki Tomiyasu** (Hokkaido): a Tokyo public servant 10 years ago, **no farm or engineering degree.** Now manages **100 hectares** (broccoli, pumpkins, onions, soybeans) and **built his own software with ChatGPT + Codex** — a phone-controlled greenhouse vent, satellite crop-health tracking, and photographing black spots on broccoli to ask AI whether it's disease and what to do.

## [3:24](https://youtu.be/qmf1TEu17ZI?t=204) How we got here: GPS → precision agriculture → AI

- **Mid-1990s:** John Deere + **NASA's Jet Propulsion Laboratory** put satellite receivers on tractors accurate enough to drive near-perfect straight lines → **yield maps** showing which parts of a field produce more or less.
- **Precision agriculture:** once you can measure every square meter, you can treat each differently — **variable rates of seed, water, fertilizer** instead of blanketing the whole field.
- **2017:** Deere paid **$305M for Blue River Technology**, whose **"See & Spray"** uses cameras + computer vision to tell crop from weed, **scanning >1 million plants/hour** and spraying only the weeds.
- **2022 (CES):** Deere's **fully autonomous tractor** — 16 cameras for 360° vision, GPS accurate to **<1 inch, no driver in the cab.**

## [4:35](https://youtu.be/qmf1TEu17ZI?t=275) Where AI helps: four jobs

1. **Seeing** — computer vision spots pests/disease early, often **~90% accuracy**, so a farmer treats one sick patch, not the whole field.
2. **Predicting** — ML forecasts yields, disease rates, soil nutrients, and the best time to irrigate (turns weather + sensor data into decisions).
3. **Acting** — robots/smart sprayers do the physical work. **Selective weeding can cut herbicide use up to 95%;** farms report **up to +20% yields and ~−20% input costs.**
4. **Advising** (newest) — generative AI becomes an **on-call agronomist + translator + software engineer** in one (the Hokkaido broccoli farmer's tool).

## [5:37](https://youtu.be/qmf1TEu17ZI?t=337) How a robot tells a weed from a crop — sense → decide → act

- **Sense:** color cameras + near-infrared and sometimes **hyperspectral** sensors (wavelengths our eyes can't see) — healthy plants, stressed plants, and bare soil reflect light differently.
- **Decide:** images feed a deep-learning model, often a **CNN or a YOLO detector** trained on **hundreds of thousands of labeled plant images**; in milliseconds it segments the frame, boxes each plant, and classifies **crop vs. weed.**
- **Act:** the software fires an actuator — a **precisely aimed nozzle spot-sprays** the weed, or a mechanical tool **rips it out**, all while the machine keeps moving.
- **Every robot is a variation on this loop.** Grain Weevil swaps cameras for an auger + a controlled avalanche of physics; TRIC swaps sprayers for UV-C + a vacuum; Deere's driverless tractor wraps it in inch-accurate GPS + 360° vision. **Same recipe, different tools.**

## [6:53](https://youtu.be/qmf1TEu17ZI?t=413) The catches: why isn't every farm automated?

1. **Cost** — autonomous robots + hardware are wildly expensive, out of reach for all but the largest operations (exactly why TRIC and others **rent robots as a service**).
2. **Connectivity** — many robots need reliable broadband + cloud access that vast rural stretches lack: **a digital divide drawn across the countryside.**
3. **Skills** — someone must operate, maintain, and trust these systems; rural training and digital literacy haven't kept pace.
4. **Fit** — most tech was designed for **big, uniform, single-crop fields**; it doesn't map onto the **small mixed-crop plots** that feed much of the world. Plus real worries about **who owns the farm data.**

## [7:53](https://youtu.be/qmf1TEu17ZI?t=473) Verdict: real, but uneven — and the wild card

- **Can AI/robotics transform agriculture? Yes, but unevenly.** The market says it's real: **AI-in-agriculture ≈ $2.5B (2025), projected toward ~$25B within a decade.** Not a passing fad — the capability is here and works.
- **The constraint was never engineering; it's access and economics.** Industrial cotton fields (Xinjiang) and big US-Midwest farms automate first because scale justifies the cost.
- **The real wild card is the Hokkaido broccoli farmer:** generative AI is quietly dropping the barrier, letting **one curious person do what used to need a whole engineering team.** The next farm revolution "might not come from a $500,000 robot, but from a chatbot in a farmer's pocket."

---

## Key numbers (all as claimed in the video, 2026)

| Thing | Figure |
|---|---|
| TRIC UV-C + vacuum | lygus −35%, spotted-wing fruit flies −58%, spider mites −~⅓, mildew −30% |
| XAG cotton robot throughput | ~7 ha/hour; 1 tech runs 5; >130,000 ha by end-2025 |
| Xinjiang share of China's cotton | ~90% |
| Grain Weevil | 2-ft robot; >100 sold |
| Hiroki Tomiyasu farm | 100 ha, built on ChatGPT + Codex |
| Deere → Blue River (2017) | $305M; See & Spray >1M plants/hour |
| Deere autonomous tractor (CES 2022) | 16 cameras, 360°, GPS <1 inch, no driver |
| Computer-vision detection | ~90% accuracy |
| Selective weeding | up to −95% herbicide |
| Reported farm outcomes | up to +20% yield, ~−20% input cost |
| AI-in-agriculture market | ~$2.5B (2025) → ~$25B in a decade |

## Names & tech (transcribed by ear — verify)

TRIC Robotics · XAG · Grain Weevil · Hiroki Tomiyasu (Hokkaido) · John Deere · NASA JPL · Blue River Technology / "See & Spray" · CES 2022 · CNN / YOLO detectors · near-infrared & hyperspectral imaging · UV-C.
