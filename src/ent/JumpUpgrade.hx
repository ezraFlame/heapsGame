package ent;

import h2d.col.Bounds;
import hxd.Res;
import h2d.Tile;
import h2d.Bitmap;

class JumpUpgrade extends Entity {
    public function new(kind:Data.EntityKind, x:Float, y:Float) {
        super(kind, x, y);
    }

    override function update() {
        super.update();

        if (overlaps(Player.instance)) {
            Player.instance.jumpForce = 0.25;
            remove();
        }
    }

    override function init() {
        sprite = new Bitmap(Res.jumpUpgrade.toTile(), game.s2d);

        overlapRadius = 0.5;
    }
}