
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
    var _rooms:Array<Room>;

    override public function create():Void
    {
        super.create();

        _dungeonTree = createTree(80, 45);
        _rooms = createRooms(_dungeonTree);

        FlxG.log.add("_dungeonTree.size() = " + _dungeonTree.size());
        FlxG.log.add("_dungeonTree.countLeaves() = " + _dungeonTree.countLeaves());
        FlxG.log.add("_dungeonTree.countNodes() = " + _dungeonTree.countNodes());
        FlxG.log.add("_dungeonTree.depth() = " + _dungeonTree.depth());
        FlxG.log.add("_rooms.length = " + _rooms.length);

        for (room in _rooms)
        {
            var sRoom = new FlxSprite();
            sRoom.makeGraphic(room.width * 8, room.height * 8, FlxColor.WHITE);
            sRoom.x = room.x * 8;
            sRoom.y = room.y * 8;

            add(sRoom);
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
                var newWidth = Std.int(FlxRandom.floatRanged(tree.width * 0.35, tree.width * 0.55));
                tree.left = createTree(newWidth, height, x, y, tree);
                tree.right = createTree(width - newWidth, height, x + newWidth, y, tree);
            }
            else
            {
                var newHeight = Std.int(FlxRandom.floatRanged(tree.height * 0.35, tree.height * 0.55));
                tree.left = createTree(width, newHeight, x, y, tree);
                tree.right = createTree(width, height - newHeight, x, y + newHeight, tree);
            }
        }

        return tree;
    }

    public function createRooms(tree:Node):Array<Room>
    {
        var rooms:Array<Room> = new Array<Room>();

        if (tree.isLeaf())
        {
            var width = Std.int(FlxRandom.floatRanged(tree.width * 0.45, tree.width * 0.85));
            var height = Std.int(FlxRandom.floatRanged(tree.height * 0.45, tree.height * 0.85));
            var x = tree.x + Std.int(FlxRandom.floatRanged(1, tree.width - width - 1));
            var y = tree.y + Std.int(FlxRandom.floatRanged(1, tree.height - height - 1));

            tree.room = new Room(x, y, width, height);
            rooms.push(tree.room);
        }
        else
        {
            rooms = rooms.concat(createRooms(tree.left));
            rooms = rooms.concat(createRooms(tree.right));
        }

        return rooms;
    }

    public function connectRooms(tree:Node):Void
    {

    }
}