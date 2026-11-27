# Okrane's Nutty Balance

A personal balance mod for **Battle Brothers** with the **[Reforged](https://github.com/Battle-Modders/mod-reforged)** mod.
It makes characters a bit sturdier, smooths out a few annoying perks, adds a **Medic** perk and reworks the **Supporter** perk.

---

## Characters

- **Hitpoints on level-up:** 3–5 instead of 2–4

## New Perk: Medic

*Trained perk group, tier 1*
- Grants the **Bandage** skill (see below)
- Heals **15 Hitpoints after every battle**
- Regenerates **5 Hitpoints at the start of each turn**
- Injuries heal **1 day faster**

## Perk Changes

| Perk | Change |
|---|---|
| **Nine Lives** | **+10 Hitpoints** |
| **Survival Instinct** | **+5 Hitpoints** |
| **Resilient** (Hold Out) | **+5 Hitpoints**, player characters are **immune to being netted, webbed or rooted** |
| **Bags and Belts** | Items in bags never reduce Maximum Fatigue – **two-handed weapons included** |
| **Quick Hands** | One free item swap per turn with **any** item – shields and two-handed weapons included |
| **Supporter** | No longer refunds Action Points – reworked **Encourage** instead (see below) |

## Perk Groups

| Group | Change |
|---|---|
| **General** (every character) | Bags and Belts, **Quick Hands** and **Fortified Mind** |
| **Fast** | **Pathfinder** at tier 2 (instead of Quick Hands) |
| **Trained** | **Medic** at tier 1; tier 2 is empty (Quick Hands moved to General) |

## Skills

- **Encourage** (Supporter)
  - Can target any ally within **2** tiles whose morale is **lower than or equal** to yours
  - Raises the target's morale by up to **2** steps with a positive morale check
  - The target gains **+3 Action Points**
  - Cannot be used after attacking; after using it, your attacks cost **+2 Action Points** for the rest of the turn
- **Bandage**
  - Costs **5 AP**
  - The **first use each battle** also heals **20 Hitpoints** and can target any ally
  - Removes Bleeding and **treats injuries received up to 2 rounds ago** (injuries show "(Fresh)" and the round they were received)
- **Deathblow** (daggers) – the +33% damage bonus also works against **Staggered** targets, and those targets take an extra **20% armor-ignoring damage**
- **Lunge** and **Sword Thrust** (fencing swords) – the **-20% chance to hit** is removed
- **Net Pull** – range **3** and pulls the target up to **2 tiles** closer
- **Free swap:** swapping to or from a **tool** (bombs, nets, …) costs **0 AP once per turn** – shared with Reforged's free dagger swap

## Items

- **Living Tree Shield** (crafted Schrat shield) weighs **8** instead of 12

---

## Requirements

- Reforged **0.9+** (with its requirements: MSU, Modern Hooks, Dynamic Perks, Stack Based Skills, …)

## Installation

Download the zip from the latest [release](../../releases) and put it (unextracted) into the game's `data` folder.
The mod is **safe to add to or remove from an existing savegame**.

---

## Changelog

**0.6.1**
- Fixed: the fencing sword hit penalty (Lunge, Sword Thrust) was no longer removed with Reforged 0.9

**0.6.0**
- Living Tree Shield weighs 8 (was 12)
- Survival Instinct: +5 Hitpoints (was +10)
- Fixed: the mod loaded *before* Reforged instead of after it
- Fixed: Nine Lives no longer cured damage-over-time effects when it triggered
- Fixed: Resilient lost Reforged's halved bleeding
- Fixed: Survival Instinct lost Reforged's defense bonus
- Fixed: the Medic perk did not remove its Bandage and effect on respec; no duplicate Bandage
- Fixed: Bandage could heal above maximum Hitpoints
- Fixed: the free tool swap referenced a field removed in Reforged 0.9 (now shared with Reforged's free dagger swap)
- Fixed: Survival Instinct and Supporter descriptions were only partly applied
- In-game update notifications via MSU

**Earlier versions (up to 0.5.5)**
- Medic perk, Bandage rework, fresh injuries
- Supporter / Encourage rework
- Hitpoint changes for level-ups, Nine Lives, Survival Instinct and Resilient
- Bags and Belts, Quick Hands and perk group changes
- Deathblow, fencing swords, Net Pull and free tool swap changes
