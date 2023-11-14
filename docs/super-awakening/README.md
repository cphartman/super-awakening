# Super Link's Awakening

`Super Link's Awakening` is a `Legend of Zelda: Link's Awakening` romhack that enables additional functionality using `Super Game Boy` features.  This romhack enables new gameplay features that are designed to be played with an SNES controller.

![Super Links Awakening](super-lzdx.gif)

## New Gameplay Features
* 🗡 Sword always equipped to `A` button
* ⛨ Shield always equipped to `B` button
* 💣 Weapon inventory equipped to `X` and `Y` buttons 
* 🏹 Switch weapon inventory with `R` and `L` buttons

![Super Controller Diagram](super-controller-diagram.png)

## How?
`Super Game Boy` exposes up to 4 controller inputs to `Game Boy` games.  This feature enabled local multiplayer via `Super Game Boy` for games like `Street Fighter 2` or `Bomberman`.

The romhack takes advantage of this functionality by configuring a single IRL controller to use buttons for both `Super Game Boy` controllers inputs.  This double the number of inputs available for the game to use. Custom functionality is implemented for each of the additional inputs.

## Setup

* This romhack must be played using a `Super Game Boy`
* Controller 1 and Controller 2 inputs for the `Super Game Boy` should both map to a single IRL controller

### Controller Mapping

**IRL Controller** is the the real life controller used to play the game.  **SGB Controller** is the input in to the `Super Game Boy`.

| IRL Controller  | SGB Controller | SGB Button |
| ------------- | ------------- | ------------- |
| `Up` | Controller 1 |  `Up`  |
| `Down` | Controller 1 |  `Down`  |
| `Left` | Controller 1 |  `Left`  |
| `Right` | Controller 1 |  `Right`  |
| `Start` | Controller 1 |  `Start`  |
| `Select` | Controller 1 |  `Select`  |
| `A` | Controller 2 |  `Right`  |
| `B` | Controller 2 |  `Down`  |
| `X` | Controller 2 |  `Up`  |
| `Y` | Controller 2 |  `Left`  |
| `R` | Controller 2 |  `Start`  |
| `L` | Controller 2 |  `Select`  |

![IRL Controller with SGB Controller Buttons](input-mapping-diagram.png)

*IRL Controller, with SGB Controller button mapping*