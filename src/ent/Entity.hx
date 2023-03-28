package ent;

import hxd.Timer;
import h2d.Drawable;
import h2d.Tile;
import h2d.Bitmap;
import h2d.col.Bounds;

class Entity {
    var game:Game;

    var width:Float;
    var height:Float;

    var kind:Data.EntityKind;

    public var overlapRadius:Float;

    public var sprite:Drawable;

    public var x(get, set):Float;
    public var y(get, set):Float;

    public var velocityX:Float;
    public var velocityY:Float;
    public var drag:Float;

    public var grounded:Bool;

    public static function create(kind:Data.EntityKind, x:Float, y:Float):Entity {
        switch(kind) {
            case jumpUpgrade:
                return new JumpUpgrade(kind, x, y);
            default:
                return new Entity(kind, x, y);
        }
    }

    public function new(kind, x, y) {
        game = Game.instance;
        game.entities.push(this);

        width = 1;
        height = 1;

        drag = 0.96;

        this.kind = kind;

        overlapRadius = 0;

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
        x += dx * Timer.tmod;
        // Horizontal collision
        if (velocityX > 0) { // Right
            if (collide(width, 0 + 0.001) || collide(width, height / 2) || collide(width, height)) {
                if (velocityX > 0) velocityX = 0;
                x = Math.floor(x + width) - width - 0.001;
            }
        } else { // Left
            if (collide(0, 0 + 0.001) || collide(0, height / 2) || collide(0, height)) {
                if (velocityX < 0) velocityX = 0;
                x = Math.ceil(x);
            }
        }

        y += dy * Timer.tmod;
        grounded = false;
        // Vertical collision
        if (velocityY > 0) { // Down
            if (collide(0, height) || collide(width / 2, height) || collide(width, height)) {
                if (velocityY > 0) velocityY = 0;
                y = Math.floor(y + height) - height - 0.001;
                grounded = true;
            }
        } else { // Up
            if (collide(0, 0) || collide(width / 2, 0) || collide(width, 0)) {
                if (velocityY < 0) velocityY = 0;
                y = Math.ceil(y) - 0.001;
            }
        }
    }

    public function overlaps(entity:Entity) {
        var maxDistance = overlapRadius + entity.overlapRadius;

        var distanceSquared = (entity.x - x) * (entity.x - x) + (entity.y - y) * (entity.y - y);
        return distanceSquared <= maxDistance * maxDistance;
    }
}