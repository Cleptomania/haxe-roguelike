package roguelike;

import haxe.ds.Vector;
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

enum TileType {
    FLOOR;
    WALL;
}

function mapIndex(x: Int, y: Int): Int {
    return (y * SCREEN_WIDTH) + x;
}

@:structInit class Position {
    public var x: Int;
    public var y: Int;

    public function new(x: Int, y: Int) {
        this.x = x;
        this.y = y;
    }
}

@:structInit class Renderable {
    public var glyph: Int;
    public var fg: RGBA;
    public var bg: RGBA;

    public function new(glyph: Int, fg: RGBA, bg: RGBA) {
        this.glyph = glyph;
        this.fg = fg;
        this.bg = bg;
    }
}

class GameState {

    public var player: Entity;
    public var map: Vector<TileType>;

    public function new() {}

}

class RenderSystem extends System {

    private var console: Console;

    public function new(console: Console) {
        super();
        this.console = console;
    }

    @:update private function updateRenderedPosition(renderable: Renderable, position: Position) {
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

        state.map = newMap();

        state.player = new Entity();
        state.player.add(new Renderable(to_cp437("@"), Color.YELLOW, Color.BLACK));
        state.player.add(new Position(40, 25));
    }

    function newMap(): Vector<TileType> {
        var map: Vector<TileType> = new Vector(SCREEN_WIDTH * SCREEN_HEIGHT, TileType.FLOOR);

        // Create walls on the perimeter
        for (x in 0...SCREEN_WIDTH) {
            map[mapIndex(x, 0)] = TileType.WALL;
            map[mapIndex(x, SCREEN_HEIGHT - 1)] = TileType.WALL;
        }
        for (y in 0...SCREEN_HEIGHT) {
            map[mapIndex(0, y)] = TileType.WALL;
            map[mapIndex(SCREEN_WIDTH - 1, y)] = TileType.WALL;
        }

        // Now lets randomly spit out some walls
        for (i in 0...400) {
            var x = hrl.Random.int(1, SCREEN_WIDTH - 1);
            var y = hrl.Random.int(1, SCREEN_HEIGHT - 1);
            var idx = mapIndex(x, y);
            if (idx != mapIndex(40, 25)) // Don't put a wall where the player spawn is
                map[idx] = TileType.WALL;
        }

        return map;
    }

    public function tick(delta: Float): Void {
        delta_counter += delta;
        this.console.clear();

        drawMap();

        if (delta_counter > 0.1) { // We only want to run input 10 times per second, otherwise it's way too fast
            playerInput();
            delta_counter = 0;
        }

        Echoes.update();
    }

    function drawMap() {
        var x = 0;
        var y = 0;
        for (tile in state.map) {
            switch (tile) {
                case FLOOR:
                    this.console.set(x, y, to_cp437("."), Color.rgb_f(0.5, 0.5, 0.5), Color.BLACK);
                case WALL:
                    this.console.set(x, y, to_cp437("#"), Color.GREEN, Color.BLACK);
            }
            x++;
            if (x >= SCREEN_WIDTH) {
                x = 0;
                y++;
            }
        }
    }

    function playerInput() {
        if (isKeyDown(hrl.Key.UP) || isKeyDown(hrl.Key.W))
            movePlayer(0, -1);
        if (isKeyDown(hrl.Key.DOWN) || isKeyDown(hrl.Key.S))
            movePlayer(0, 1);
        if (isKeyDown(hrl.Key.LEFT) || isKeyDown(hrl.Key.A))
            movePlayer(-1, 0);
        if (isKeyDown(hrl.Key.RIGHT) || isKeyDown(hrl.Key.D))
            movePlayer(1, 0);
    }

    function movePlayer(deltaX: Int, deltaY: Int) {
        var pos = this.state.player.get(Position);
        var destinationIdx = mapIndex(pos.x + deltaX, pos.y + deltaY);
        if (state.map[destinationIdx] != TileType.WALL) {
            pos.x = Std.int(Math.min(SCREEN_WIDTH - 1, Math.max(0, pos.x + deltaX)));
            pos.y = Std.int(Math.min(SCREEN_HEIGHT - 1, Math.max(0, pos.y + deltaY)));
        }
    }

    static function main(): Void {
        new Main();
    }
}