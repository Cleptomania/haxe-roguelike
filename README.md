# Haxe Roguelike Tutorial

This is an attempt to write something equating to the typical "Roguelike Tutorial" with Haxe.

Currently it's built using:
    - [Heaps](https://github.com/HeapsIO/heaps) - General game engine used for rendering.
    - [Echoes](https://github.com/player-03/echoes) - A nice Haxe ECS library
    - [HashLink](https://hashlink.haxe.org/) - Build targeting HashLink and using the hlsdl as a target for Heaps.

To get setup, install the following dependencies with haxelib(installing from Git because for some reason actual haxelib dependencies are never used/updated):

```bash
haxelib git heaps https://github.com/HeapsIO/heaps.git
haxelib git echoes https://github.com/player-03/echoes.git
haxelib git hlsdl https://github.com/HaxeFoundation/hashlink
```

The individual code part folders each contain a fully runnable workspace. If you open a particular part in VSCode, it includes a launch.json that assuming you have the Haxe and HashLink VSCode extensions, will compile + run using HashLink by pressing F5.