# Luck by normal law — Roblox UI Tool
 
A client-side GUI tool that visualizes how a luck boost shifts pet drop probabilities using a Gaussian bell curve model.
 
## How it works
 
Each pet has a base probability and a `luckRate` (0–1). At luck = 0, probabilities match the base table. As luck increases, the Gaussian center shifts rightward; pets with a higher `luckRate` move further along the curve, boosting rarer pets more than common ones.
 
The formula: each pet's initial placement on the Gaussian is derived from its base probability, then recalculated at `center = luck^1.35`. Final probabilities are normalized to sum to 1.
 
The UI shows live probability percentages for each pet tier and updates in real time as the user drags a slider or presses the luck boost buttons (Small +2, Medium +4, Large +7, Uber +10 — each lasts 5 seconds).
 
## Architecture
 
Everything is a single `LocalScript`. No server involvement — it's a pure math and UI tool intended to prototype pet systems.
 
## Author
 
Roblox project, 2025