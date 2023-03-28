package ent;

import hxd.Timer;
import hxd.Key;
import h2d.Tile;
import h2d.Bitmap;

class Player extends Entity {
    var gravity:Float = 0.01;
    var moveSpeed:Float = 0.1;
    var jumpForce:Float = 0.25;

    var hangTime:Float = 0.5;
    var hangTimeCounter:Float;

    var jumpBuffer:Float = 0.1;
    var jumpBufferCounter:Float;

    public override function new(x:Float, y:Float) {
        super(x, y);
    }

    override function init() {
        sprite = new Bitmap(Tile.fromColor(0xFF0000, 8, 16), game.s2d);
        width = 0.5;
        height = 1;

        hangTimeCounter = 0;
        jumpBufferCounter = 0;
    }

    override function update() {
        super.update();
        velocityY += gravity;

        var moveX:Int = 0;
        if (Key.isDown(Key.A)) {
            moveX = -1;
        } else if (Key.isDown(Key.D)) {
            moveX = 1;
        }

        velocityX = moveSpeed * moveX * Timer.tmod;

        if (grounded) {
            hangTimeCounter = hangTime;
        } else {
            hangTimeCounter -= Timer.dt;
        }
        trace(hangTimeCounter);

        if (Key.isPressed(Key.SPACE) && hangTimeCounter > 0) {
            velocityY = -jumpForce * Timer.tmod;
        }
    }
}