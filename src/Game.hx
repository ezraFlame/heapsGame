import ent.Player;
import ent.GravityTest;
import ent.Entity;
import h2d.CdbLevel;
import hxd.Res;
import hxd.App;

class Game extends App {
    public static var instance:Game;

    public var level:CdbLevel;
    var levelCollision:Array<String>;

    public var entities:Array<Entity>;

    public override function init() {
        Res.initEmbed();
        Data.load(Res.data.entry.getText());

        engine.backgroundColor = 0x51B1B1;

        entities = [];

        level = new CdbLevel(Data.levelData, 0, s2d);

        levelCollision = level.buildStringProperty("collide");

        s2d.camera.setAnchor(0.5, 0.5);

        s2d.camera.follow = new Player(1, 1).sprite;

        s2d.camera.setScale(2, 2);
    }

    public override function update(deltaTime:Float) {
        for (entity in entities) {
            entity.update();
        }
    }

    public static function main() {
        instance = new Game();
    }

    public function levelCollide(x:Float, y:Float) {
        return levelCollision[Std.int(x) + Std.int(y) * level.width] == "Full";
    }
}