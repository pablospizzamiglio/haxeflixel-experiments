package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.util.FlxDestroyUtil;

using flixel.util.FlxSpriteUtil;


/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
    private var _cameraControlStateButton:FlxButton;
    private var _caveStateButton:FlxButton;
    private var _dungeonStateButton:FlxButton;

    /**
     * Function that is called up when to state is created to set it up.
     */
    override public function create():Void
    {
        super.create();

        // _cameraControlStateButton = new FlxButton(50, 50, "Camera", switchToCameraControlState);
        // _cameraControlStateButton.screenCenter();
        // add(_cameraControlStateButton);

        _caveStateButton = new FlxButton(50, 70, "Cave", switchToCaveState);
        // _caveStateButton.screenCenter();
        add(_caveStateButton);

        _dungeonStateButton = new FlxButton(50, 90, "Dungeon", switchToDungeonState);
        // _dungeonStateButton.screenCenter();
        add(_dungeonStateButton);
    }

    private function switchToCameraControlState():Void
    {
        FlxG.switchState(new CameraControlState());
    }

    private function switchToCaveState():Void
    {
        FlxG.switchState(new CaveState());
    }

    private function switchToDungeonState():Void
    {
        FlxG.switchState(new DungeonState());
    }

    /**
     * Function that is called when this state is destroyed - you might want to
     * consider setting all objects this state uses to null to help garbage collection.
     */
    override public function destroy():Void
    {
        super.destroy();
        _cameraControlStateButton = FlxDestroyUtil.destroy(_cameraControlStateButton);
        _caveStateButton = FlxDestroyUtil.destroy(_caveStateButton);
        _dungeonStateButton = FlxDestroyUtil.destroy(_dungeonStateButton);
    }

    /**
     * Function that is called once every frame.
     */
    override public function update():Void
    {
        super.update();
    }
}