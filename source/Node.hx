
package ;

import flixel.FlxG;

class Node
{
    public var root:Node;
    public var left:Node;
    public var right:Node;
    public var width:Int;
    public var height:Int;
    public var x:Int;
    public var y:Int;
    public var room:Room;

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
        return width > 22 && height > 22;
    }

    public function isLeaf():Bool
    {
        return left == null && right == null;
    }

    public function size():Int
    {
        return isLeaf() ? 1 : left.size() + right.size() + 1;
    }

    public function countLeaves():Int
    {
        return isLeaf() ? 1 : left.countLeaves() + right.countLeaves();
    }

    public function countNodes():Int
    {
        return size() - countLeaves();
    }

    public function depth():Int
    {
        return isLeaf() ? 1 : countNodes();
    }
}