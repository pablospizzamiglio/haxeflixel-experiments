package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.tile.FlxTilemap;
import openfl.Assets;
import flixel.util.FlxPoint;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class CameraControlState extends FlxState
{
    var map:FlxTilemap;
    var player:FlxSprite;

    /**
     * Function that is called up when to state is created to set it up.
     */
    override public function create():Void
    {
        super.create();

        map = new FlxTilemap();
        var mapData:String = Assets.getText("assets/data/map-data.csv");
        var mapImage:String = "assets/images/basictiles_2.png";
        map.loadMap(mapData, mapImage, 16, 16);

        add(map);

        // Note: tile 99 is going to be our player object
        var playerCoords:Array<FlxPoint> = map.getTileCoords(99, false);
        var playerPosition:FlxPoint = playerCoords[0];
        player = new FlxSprite(playerPosition.x, playerPosition.y);

        // Note: when loading graphic for FlxSprite, the default
        // index is 0, so we reset it back to 99 (the player's tile image)
        player.loadGraphic(mapImage, false, 16, 16);
        player.animation.frameIndex = 99;

        add(player);

        // Reset the tile under the player to "11", the grass tile
        var playerTiles:Array<Int> = map.getTileInstances(99);
        var playerTile:Int = playerTiles[0];
        map.setTileByIndex(playerTile, 11, true);

        // Extend the camera a little to cover for shake area
        var ext = 50;
        FlxG.camera.setSize(FlxG.width + ext, FlxG.height + ext);
        FlxG.camera.setPosition( - ext / 2, - ext / 2);

        // Follow the pillar... er, player.
        FlxG.camera.follow(player, flixel.FlxCamera.STYLE_TOPDOWN, null, 10);

        // Set the camera bounds
        FlxG.camera.setBounds(0, 0, map.width, map.height);
    }

    private function mainMenu():Void
    {
        FlxG.switchState(new MenuState());
    }

    /**
     * Function that is called when this state is destroyed - you might want to
     * consider setting all objects this state uses to null to help garbage collection.
     */
    override public function destroy():Void
    {
        super.destroy();
    }

    /**
     * Function that is called once every frame.
     */
    override public function update():Void
    {
        super.update();

        // Reset velocity by default, if not moving
        player.velocity.set(0,0);

        // Back to Menu
        if (FlxG.keys.pressed.ESCAPE) mainMenu();

        // Move player
        if (FlxG.keys.pressed.W) player.velocity.y = -100;
        if (FlxG.keys.pressed.S) player.velocity.y = 100;
        if (FlxG.keys.pressed.A) player.velocity.x = -100;
        if (FlxG.keys.pressed.D) player.velocity.x = 100;

        // Shake camera
        var duration = 0.5;
        if (FlxG.keys.pressed.ONE)
        {
            // Shake vertically AND horizontally, and flash white color.
            FlxG.camera.shake(0.01, duration);
            FlxG.camera.flash(0xFFFFFFFF, duration);
        }
        if (FlxG.keys.pressed.TWO)
        {
            // Shake vertically only, and flash red color.
            FlxG.camera.shake(0.01, duration, null, true, flixel.FlxCamera.SHAKE_VERTICAL_ONLY);
            FlxG.camera.flash(0xFFFF0000, duration);
        }
        if (FlxG.keys.pressed.THREE)
        {
            // Shake horizontally only, and flash black color.
            FlxG.camera.shake(0.01, duration, null, true, flixel.FlxCamera.SHAKE_HORIZONTAL_ONLY);
            FlxG.camera.flash(0xFF000000, duration);
        }
    }
}