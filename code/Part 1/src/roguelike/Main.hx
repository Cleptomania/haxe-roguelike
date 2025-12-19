package roguelike;

class Main extends hxd.App {

    override function init(): Void {
        var hello = new h2d.Text(getFont(), s2d);
        hello.text = "Hello World!";
        hello.setPosition(1, 1);
    }

    function getFont(): h2d.Font {
        return hxd.res.DefaultFont.get();
    }

    static function main(): Void {
        new Main();
    }
}