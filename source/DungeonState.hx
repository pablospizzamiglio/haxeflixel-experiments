
package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxColor;
import flixel.util.FlxRandom;
import flixel.util.FlxSpriteUtil;

class DungeonState extends FlxState
{
    var _dungeonTree:Node;
    var _rooms:Array<FlxSprite>;
    var _rooms2:Array<FlxSprite>;

    override public function create():Void
    {
        super.create();

        // _dungeonTree = new Node(640, 360);

        _dungeonTree = createTree(640, 360);
        _rooms = createRooms(_dungeonTree);

        FlxG.log.add(_dungeonTree.size());
        FlxG.log.add(_rooms.length);

        var lineStyle:LineStyle = { color: FlxColor.BLACK, thickness: 2 };

        for (r in _rooms)
        {
            FlxG.log.add(r.x + " " + r.y + " -- " + r.width + " " + r.height);

            add(r);
            //add(FlxSpriteUtil.drawRect(r, r.x, r.y, r.width - 1, r.height - 1, FlxColor.WHITE));
        }
    }

    override public function destroy():Void
    {
        super.destroy();
    }

    override public function update():Void
    {
        super.update();

        // Back to Menu
        if (FlxG.keys.justPressed.ESCAPE) mainMenu();
    }

    private function mainMenu():Void
    {
        FlxG.switchState(new MenuState());
    }

    public function createTree(width:Int, height:Int, x:Int = 0, y:Int = 0, root:Node = null):Node
    {
        var tree = new Node(width, height, x, y, root);

        if (tree.canBeSplit())
        {
            var isVertical = width > height && height / width >= 0.05;

            if (isVertical)
            {
                var newWidth = Std.int(FlxRandom.floatRanged(tree.width * 0.4, tree.width * 0.6));
                tree.left = createTree(newWidth, height, x, y, tree);
                tree.right = createTree(width - newWidth, height, x + newWidth, y, tree);
            }
            else
            {
                var newHeight = Std.int(FlxRandom.floatRanged(tree.height * 0.4, tree.height * 0.6));
                tree.left = createTree(width, newHeight, x, y, tree);
                tree.right = createTree(width, height - newHeight, x, y + newHeight, tree);
            }
        }

        return tree;
    }

    public function createRooms(tree:Node):Array<FlxSprite>
    {
        var rooms:Array<FlxSprite> = new Array<FlxSprite>();

        if (tree.isLeaf())
        {

            var w = FlxRandom.intRanged(30, tree.width - 10);
            var h = FlxRandom.intRanged(30, tree.height - 10);
            var x = FlxRandom.intRanged(1, tree.width - w - 10);
            var y = FlxRandom.intRanged(1, tree.height - h - 10);

            var r = new FlxSprite();
            r.makeGraphic(tree.width - 2, tree.height - 2, FlxColor.WHITE);
            r.x = tree.x + 1;
            r.y = tree.y + 1;

            rooms.push(r);
        }
        else
        {
            rooms = rooms.concat(createRooms(tree.left));
            rooms = rooms.concat(createRooms(tree.right));
        }

        return rooms;
    }
}