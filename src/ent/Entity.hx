package ent;

import h2d.Drawable;
import h2d.Tile;
import h2d.Bitmap;
import h2d.col.Bounds;

class Entity {
    var game:Game;
    var bounds = Bounds;

    var width:Float;
    var height:Float;

    public var sprite:Drawable;

    public var x(get, set):Float;
    public var y(get, set):Float;

    public var velocityX:Float;
    public var velocityY:Float;
    public var drag:Float;

    public var grounded:Bool;

    public function new(x, y) {
        game = Game.instance;
        game.entities.push(this);

        width = 1;
        height = 1;

        drag = 0.96;

        init();

        if (sprite == null) {
            sprite = new Bitmap(Tile.fromColor(0xFF0000, 16, 16), game.s2d);
        }

        this.x = x;
        this.y = y;
    }

    function init() {}

    public function update() {
        move(velocityX, velocityY);
    }

    function add() {
        remove();
        game.entities.push(this);
        game.s2d.addChild(sprite);
    }

    public function remove() {
        game.entities.remove(this);
        sprite.remove();
    }

    inline function get_x() {
        return sprite.x / 16;
    }

    inline function get_y() {
        return sprite.y / 16;
    }

    inline function set_x(value:Float) {
        sprite.x = value * 16;
        return value;
    }

    inline function set_y(value:Float) {
        sprite.y = value * 16;
        return value;
    }

    function collide(dx:Float, dy:Float):Bool {
        return game.levelCollide(x + dx, y + dy);
    }

    function move(dx:Float, dy:Float) {
        x += dx;
        // Horizontal collision
        if (dx > 0) { // Right
            if (collide(width, 0) || collide(width, height / 2) || collide(width, height)) {
                if (velocityX > 0) velocityX = 0;
                x = Math.floor(x + width) - width - 0.001;
            }
        } else { // Left
            if (collide(0, 0) || collide(0, height / 2) || collide(0, height)) {
                if (velocityX < 0) velocityX = 0;
                x = Math.ceil(x);
            }
        }

        y += dy;
        grounded = false;
        // Vertical collision
        if (dy > 0) { // Down
            if (collide(0, height + 0.001) || collide(width / 2, height + 0.001) || collide(width, height + 0.001)) {
                if (velocityY > 0) velocityY = 0;
                y = Math.ceil(y) - height - 0.001;
                grounded = true;
            }
        } else { // Up
            if (collide(0, 0) || collide(width / 2, 0) || collide(width, 0)) {
                if (velocityY < 0) velocityY = 0;
                y = Math.ceil(y) - 0.001;
            }
        }
    }
}