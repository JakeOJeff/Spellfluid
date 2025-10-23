# Spell Fluid

Spellfluid is a magical fluid simulator written in Lua, inspired by GridFluids, Fluid–Euler Particle (University of Freiburg). It simulates flowing, glowing, spell-like fluids using a simple grid + particle system, perfect for games, visual effects, or experiments.

## Features

- Hybrid Eulerian (grid) + Lagrangian (particle) simulation

- Lightweight — pure Lua, no external dependencies

- Easy to modify and embed into other Lua projects

- Designed for magical / energy visual effects

- Realistic motion with customizable parameters (viscosity, diffusion, etc.)

## Usage

Clone and run ( Must have [Love2D](https://love2d.org/) Installed ) [ FASTER ]:

```
git clone https://github.com/JakeOJeff/Spellfluid.git
cd Spellfluid
love main.lua
```

**OR**

Visit the Online Demo at : https://jakeojeff.github.io/fluid-web ( May have performance issues )



## Controls:

Left click / drag → Add fluid or energy
Right click / drag → Invert Fluid
Middle Mouse / Drag → Move the Circle
P → Switch Density Map
C → Reset the simulation
1, 2, 3, 4 → Different types of Flow


## ( FOR DEVELOPERS )
- Adjust simulation settings in main.lua or fluid.lua:

fluid:setViscosity(0.002)
fluid:setDiffusion(0.001)
fluid:setResolution(128)


- Integrate it into your game or project by calling:

fluid:update(dt)
fluid:draw()

Important Source : https://cg.informatik.uni-freiburg.de/intern/seminar/gridFluids_fluid-EulerParticle.pdf
