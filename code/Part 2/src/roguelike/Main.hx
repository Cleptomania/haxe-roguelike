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
    public var console: Console;

    public var delta_counter: Float = 0;

    public function new() {
        var builder = TerminalBuilder.simple(SCREEN_WIDTH, SCREEN_HEIGHT, "Roguelike Tutorial", TILE_WIDTH, TILE_HEIGHT, FONT_FILE);
        super(builder.build());
        this.console = terminal.console;

        Echoes.init(0);
        new RenderSystem(this.console).activate();

        state.player = new Entity();
        state.player.add(new Renderable(to_cp437("@"), Color.YELLOW, Color.BLACK));
        state.player.add(new Position(40, 25));

        for (i in 0...10) {
            var new_entity: Entity = new Entity();
            new_entity.add(new Renderable(to_cp437("@"), Color.RED, Color.BLACK));
            new_entity.add(new Position(i * 7, 20));
        }
    }

    public function tick(delta: Float): Void {
        delta_counter += delta;
        this.console.clear();

        if (delta_counter > 0.1) { // We only want to run input 10 times per second, otherwise it's way too fast
            playerInput();
            delta_counter = 0;
        }

        Echoes.update();
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
        pos.x = Std.int(Math.min(SCREEN_WIDTH - 1, Math.max(0, pos.x + deltaX)));
        pos.y = Std.int(Math.min(SCREEN_HEIGHT - 1, Math.max(0, pos.y + deltaY)));
    }

    static function main(): Void {
        new Main();
    }
}