package ent;

import h2d.Tile;
import h2d.Bitmap;
import hxd.Key;
import hxd.Timer;

class GravityTest extends Entity {
    var gravity:Float = .01;
    var speed:Float = .1;
    var moveX:Int;
    var jumpForce:Float = .25;

    public override function new(x, y) {
        super(x, y);
    }

    public override function init() {
        sprite = new Bitmap(Tile.fromColor(0xFF0000, 8, 8), game.s2d);
        width = 0.5;
        height = 0.5;
    }

    override function update() {
        super.update();
        velocityY += gravity * Timer.tmod;
        moveX = 0;
        if (Key.isDown(Key.A)) {
            moveX = -1;
        } else if (Key.isDown(Key.D)) {
            moveX = 1;
        }

        velocityX = moveX * speed * Timer.tmod;

        if (Key.isPressed(Key.SPACE) && grounded) {
            velocityY = -jumpForce * Timer.tmod;
        }
    }
}