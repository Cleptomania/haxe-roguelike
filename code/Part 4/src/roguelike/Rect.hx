package roguelike;

class Rect {
    public var x1: Int;
    public var y1: Int;
    public var x2: Int;
    public var y2: Int;

    public function new(x: Int, y: Int, w: Int, h: Int) {
        this.x1 = x;
        this.y1 = y;
        this.x2 = x + w;
        this.y2 = y + h;
    }

    public function intersects(other: Rect): Bool {
        return (this.x1 < other.x2 && this.x2 >= other.x1 &&
                this.y1 < other.y2 && this.y2 >= other.y1);
    }

    public function center(): Components.Position {
        return {x: Std.int((x1 + x2) / 2), y: Std.int((y1 + y2) / 2)};
    }
}