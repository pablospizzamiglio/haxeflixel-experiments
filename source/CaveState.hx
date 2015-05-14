package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;

class CaveState extends FlxState
{
    private var _caveGen:CaveGenerator;
    private var _map:FlxTilemap;
    private var _overlay:FlxSpriteGroup;

    override public function create():Void
    {
        super.create();
        createMap();
        createOverlay();
    }

    private function createOverlay():Void
    {
        var _instructionText:FlxText = new FlxText(5, 5);
        _instructionText.text = "Press 1 to generate another cave";
        _instructionText.setFormat(null, 8, FlxColor.YELLOW, "center");
        _instructionText.setBorderStyle(FlxText.BORDER_OUTLINE, FlxColor.BLACK, 1);

        _overlay = new FlxSpriteGroup();
        _overlay.add(_instructionText);
        _overlay.scrollFactor.x = 0;
        _overlay.scrollFactor.y = 0;
        add(_overlay);
    }

    private function createMap():Void
    {
        _caveGen = new CaveGenerator(80, 45, 45, 4);
        var mapData:String = _caveGen.generate();

        _map = new FlxTilemap();
        _map.loadMap(mapData, AssetPaths.map__png, 8, 8);
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
        _overlay.destroy();
    }

    override public function update():Void
    {
        super.update();

        // Back to Menu
        if (FlxG.keys.justPressed.ESCAPE) mainMenu();

        // Generate new cave
        if (FlxG.keys.justPressed.ONE)
        {
            _map.destroy();
            _overlay.destroy();
            createMap();
            createOverlay();
        }
    }

}