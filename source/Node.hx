
package ;

import flixel.FlxG;

class Node
{
    public var height:Int;
    public var width:Int;
    public var x:Int;
    public var y:Int;
    public var root:Node;
    public var left:Node;
    public var right:Node;

    public function new(w:Int, h:Int, ox:Int = 0, oy:Int = 0, r:Node = null):Void
    {
        width = w;
        height = h;
        x = ox;
        y = oy;
        root = r;
    }

    public function canBeSplit():Bool
    {
        return width > FlxG.width / 4 && height > FlxG.height / 4;
    }

    public function isLeaf():Bool
    {
        return left == null && right == null;
    }

    public function size():Int
    {
        var size = 1;

        if (!isLeaf()) {
            size += left.size() + right.size();
        }

        return size;
    }
}