package roguelike;

import hrl.Color.RGBA;

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