package roguelike;

import hrl.terminal.TerminalBuilder;
import hrl.terminal.console.Console;

class Main {

    var console: Console;

    public function new() {
        var builder = TerminalBuilder.simple(80, 50, "Roguelike Tutorial", 8, 8, "terminal8x8.png");
        var terminal = builder.build();
        this.console = terminal.console;

        this.console.print(1, 1, "Hello World!");
    }

    static function main(): Void {
        new Main();
    }
}