package roguelike;

import hrl.CP437.to_cp437;
import hrl.Color;
import hrl.terminal.TerminalBuilder;
import hrl.terminal.console.Console;

import echoes.Echoes;
import echoes.Entity;
import echoes.System;

var SCREEN_WIDTH: Int = 80;
var SCREEN_HEIGHT: Int = 50;
var FONT_FILE: String = "terminal8x8.png";
var TILE_WIDTH: Int = 8;
var TILE_HEIGHT: Int = 8;

class GameState {

    public var player: Entity;
    public var map: Map;

    public function new() {}
}

class RenderSystem extends System {

    private var console: Console;

    public function new(console: Console) {
        super();
        this.console = console;
    }

    @:update private function updateRenderedPosition(renderable: Components.Renderable, position: Components.Position) {
        this.console.set(position.x, position.y, renderable.glyph, renderable.fg, renderable.bg);
    }
}

class Main extends hrl.App {

    public var state: GameState = new GameState();

    public var delta_counter: Float = 0;

    public function new() {
        var builder = TerminalBuilder.simple(SCREEN_WIDTH, SCREEN_HEIGHT, "Roguelike Tutorial", TILE_WIDTH, TILE_HEIGHT, FONT_FILE);
        super(builder.build());

        Echoes.init(0);
        new RenderSystem(this.console).activate();

        state.map = new Map(SCREEN_WIDTH, SCREEN_HEIGHT, Map.MapGenerator.ROOMS);

        state.player = new Entity();
        state.player.add(new Components.Renderable(to_cp437("@"), Color.YELLOW, Color.BLACK));
        state.player.add(new Components.Position(state.map.spawnPoint.x, state.map.spawnPoint.y));
    }

    override function tick(delta: Float): Void {
        this.console.clear();
        state.map.draw(this.console);
        Echoes.update();
    }

    override function onKeyDown(event: hrl.Event.KeyDown): Void {
        switch (event.keyCode) {
            case hrl.Key.UP | hrl.Key.W:
                movePlayer(0, -1);
            case hrl.Key.DOWN | hrl.Key.S:
                movePlayer(0, 1);
            case hrl.Key.LEFT | hrl.Key.A:
                movePlayer(-1, 0);
            case hrl.Key.RIGHT | hrl.Key.D:
                movePlayer(1, 0);
        }
    }

    function movePlayer(deltaX: Int, deltaY: Int) {
        var pos = this.state.player.get(Components.Position);
        if (state.map.getTile(pos.x + deltaX, pos.y + deltaY) != Map.TileType.WALL) {
            pos.x = Std.int(Math.min(SCREEN_WIDTH - 1, Math.max(0, pos.x + deltaX)));
            pos.y = Std.int(Math.min(SCREEN_HEIGHT - 1, Math.max(0, pos.y + deltaY)));
        }
    }

    static function main(): Void {
        new Main();
    }
}