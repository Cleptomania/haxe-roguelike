package roguelike;

import sdl.GameController;
import h2d.Scene;

import echoes.Echoes;
import echoes.Entity;
import echoes.System;

var SCREEN_WIDTH: Int = 80;
var SCREEN_HEIGHT: Int = 50;
var FIELD_SIZE: Int;

@:structInit class Position {
    public var x: Int;
    public var y: Int;

    public function new(x: Int, y: Int) {
        this.x = x;
        this.y = y;
    }
}

class GameState {

    public var player: Entity;

    public function new() {}

}

class RenderSystem extends System {
    public final scene: Scene;

    public function new(scene: Scene) {
        super();
        this.scene = scene;
    }

    @:add private function onObjectAdded(object: h2d.Object): Void {
        scene.addChild(object);
    }

    @:add private function onTextAdded(text: h2d.Text): Void {
        onObjectAdded(text);
    }

    @:remove private function onObjectRemoved(object: h2d.Object): Void {
        scene.removeChild(object);
    }

    @:remove private function onTextRemoved(text: h2d.Text): Void {
        onObjectRemoved(text);
    }

    @:update private function updateObjectPosition(object: h2d.Object, position: Position): Void {
        object.setPosition(position.x * FIELD_SIZE, position.y * FIELD_SIZE);
    }

    @:update private function updateTextPosition(text: h2d.Text, position: Position): Void {
        updateObjectPosition(text, position);
    }
}

class Main extends hxd.App {

    public var state: GameState = new GameState();

    override function init(): Void {
        FIELD_SIZE = getFont().size;
        var window_width = FIELD_SIZE * SCREEN_WIDTH;
        var window_height = FIELD_SIZE * SCREEN_HEIGHT;

        hxd.Window.getInstance().resize(window_width, window_height);
        hxd.Window.getInstance().addEventTarget(onEvent);
        
        new RenderSystem(this.s2d).activate();

        state.player = new Entity();
        state.player.add(new h2d.Text(getFont()));
        state.player.get(h2d.Text).text = "@";
        state.player.get(h2d.Text).textColor = 0xFFFFFF00;
        state.player.add(new Position(40, 25));

        for (i in 0...10) {
            var new_entity: Entity = new Entity();
            new_entity.add(new h2d.Text(getFont()));
            new_entity.get(h2d.Text).text = "@";
            new_entity.get(h2d.Text).textColor = 0xFFFF0000;
            new_entity.add(new Position(i * 7, 20));
        }
    }

    function onEvent(event: hxd.Event) {
        switch(event.kind) {
            case EKeyDown:
                onKeyDown(event.keyCode);
            case _:
        }
    }

    function onKeyDown(keyCode: Int) {
        switch(keyCode) {
            case hxd.Key.UP | hxd.Key.W:
                movePlayer(0, -1);
            case hxd.Key.DOWN | hxd.Key.S:
                movePlayer(0, 1);
            case hxd.Key.LEFT | hxd.Key.A:
                movePlayer(-1, 0);
            case hxd.Key.RIGHT | hxd.Key.D:
                movePlayer(1, 0);
        }
    }

    function movePlayer(deltaX: Int, deltaY: Int) {
        var pos = this.state.player.get(Position);
        pos.x = Std.int(Math.min(SCREEN_WIDTH - 1, Math.max(0, pos.x + deltaX)));
        pos.y = Std.int(Math.min(SCREEN_HEIGHT - 1, Math.max(0, pos.y + deltaY)));
    }

    function getFont(): h2d.Font {
        return hxd.res.DefaultFont.get();
    }

    static function main(): Void {
        Echoes.init();
        new Main();
    }
}