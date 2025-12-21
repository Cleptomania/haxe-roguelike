package roguelike;

import hrl.Color;
import hrl.CP437.to_cp437;
import hrl.terminal.console.Console;
import haxe.ds.Vector;

enum TileType {
    FLOOR;
    WALL;
}

enum MapGenerator {
    OLD;
    ROOMS;
}

class Map {

    public var width: Int;
    public var height: Int;

    public var tiles: Vector<TileType>;
    public var spawnPoint: Components.Position;

    public function new(width: Int, height: Int, generator: MapGenerator) {
        this.width = width;
        this.height = height;

        switch(generator) {
            case OLD:
                this.newMapOld();
            case ROOMS:
                this.newMapRooms();
        }
    }

    public function getTile(x: Int, y: Int): TileType {
        return tiles[mapIndex(x, y)];
    }

    public function mapIndex(x: Int, y: Int): Int {
        return (y * this.width) + x;
    }

    public function draw(console: Console) {
        var x = 0;
        var y = 0;
        for (tile in tiles) {
            switch (tile) {
                case FLOOR:
                    console.set(x, y, to_cp437("."), Color.rgb_f(0.5, 0.5, 0.5), Color.BLACK);
                case WALL:
                    console.set(x, y, to_cp437("#"), Color.GREEN, Color.BLACK);
            }
            x++;
            if (x >= width) {
                x = 0;
                y++;
            }
        }
    }

    function newMapOld(): Void {
        tiles = new Vector(width * height, TileType.FLOOR);

        // Create walls on the perimeter
        for (x in 0...width) {
            tiles[mapIndex(x, 0)] = TileType.WALL;
            tiles[mapIndex(x, height - 1)] = TileType.WALL;
        }
        for (y in 0...height) {
            tiles[mapIndex(0, y)] = TileType.WALL;
            tiles[mapIndex(width - 1, y)] = TileType.WALL;
        }

        // Now lets randomly spit out some walls
        for (i in 0...400) {
            var x = hrl.Random.int(1, width - 1);
            var y = hrl.Random.int(1, height - 1);
            var idx = mapIndex(x, y);
            if (idx != mapIndex(40, 25)) // Don't put a wall where the player spawn is
                tiles[idx] = TileType.WALL;
        }
    }

    function createRoom(room: Rect): Void {
        for (y in room.y1 + 1 ... room.y2) {
            for (x in room.x1 + 1 ... room.x2) {
                tiles[mapIndex(x, y)] = TileType.FLOOR;
            }
        }
    }

    function horizontalTunnel(x1: Int, x2: Int, y: Int): Void {
        for (x in Std.int(Math.min(x1, x2)) ... Std.int(Math.max(x1, x2) + 1)) {
            var index = mapIndex(x, y);
            if (index > 0 && index < tiles.length) {
                tiles[index] = TileType.FLOOR;
            }
        }
    }

    function verticalTunnel(y1: Int, y2: Int, x: Int): Void {
        for (y in Std.int(Math.min(y1, y2)) ... Std.int(Math.max(y1, y2) + 1)) {
            var index = mapIndex(x, y);
            if (index > 0 && index < tiles.length) {
                tiles[index] = TileType.FLOOR;
            }
        }
    }

    function newMapRooms(): Void {
        tiles = new Vector(width * height, TileType.WALL);

        var rooms: Array<Rect> = [];
        var MAX_ROOMS = 30;
        var MIN_SIZE = 6;
        var MAX_SIZE = 10;

        for (i in 0...MAX_ROOMS) {
            var w = hrl.Random.int(MIN_SIZE, MAX_SIZE);
            var h = hrl.Random.int(MIN_SIZE, MAX_SIZE);
            var x = hrl.Random.int(1, width - w - 1) - 1;
            var y = hrl.Random.int(1, height - h - 1) - 1;

            var newRoom = new Rect(x, y, w, h);
            var ok = true;
            for (otherRoom in rooms) {
                if (newRoom.intersects(otherRoom)) {
                    ok = false;
                }
            }

            if (ok) {
                createRoom(newRoom);

                if (rooms.length > 0) {
                    var newCenter = newRoom.center();
                    var prevCenter = rooms[rooms.length - 1].center();

                    if (hrl.Random.bool()) {
                        horizontalTunnel(prevCenter.x, newCenter.x, prevCenter.y);
                        verticalTunnel(prevCenter.y, newCenter.y, newCenter.x);
                    } else {
                        verticalTunnel(prevCenter.y, newCenter.y, prevCenter.x);
                        horizontalTunnel(prevCenter.x, newCenter.x, newCenter.y);
                    }
                }

                rooms.push(newRoom);
            }
        }
        this.spawnPoint = rooms[0].center();
    }
}
