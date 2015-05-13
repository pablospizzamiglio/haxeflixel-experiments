package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.tile.FlxTilemap;

class CaveState extends FlxState
{
    private var _caveGen:CaveGenerator;
    private var _map:FlxTilemap;

    override public function create():Void
    {
        super.create();
        createMap();
    }

    private function createMap():Void
    {
        _caveGen = new CaveGenerator(320, 180, 45);
        var mapData:String = _caveGen.generate();

        // Loads tilemap of tilesize 16x16
        _map = new FlxTilemap();
        _map.loadMap(mapData, Reg.tileSet, 16, 16);

        add(_map);
    }

    private function mainMenu():Void
    {
        FlxG.switchState(new MenuState());
    }

    override public function destroy():Void
    {
        super.destroy();
        _map.destroy();
    }

    override public function update():Void
    {
        super.update();

        // Back to Menu
        if (FlxG.keys.pressed.ESCAPE) mainMenu();

        // Generate new cave
        if (FlxG.keys.pressed.ONE)
        {
            _map.destroy();
            createMap();
        }
    }

}