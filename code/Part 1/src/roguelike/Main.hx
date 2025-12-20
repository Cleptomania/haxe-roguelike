package roguelike;

import hrl.terminal.TerminalBuilder;
import hrl.terminal.console.Console;

class Main extends hrl.App {

    public function new() {
        var builder = TerminalBuilder.simple(80, 50, "Roguelike Tutorial", 8, 8, "terminal8x8.png");
        super(builder.build());
    }

    public function tick(delta: Float): Void {
        this.console.clear();
        this.console.print(1, 1, "Hello World!");
    }

    static function main(): Void {
        new Main();
    }
}