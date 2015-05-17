
package ;

import flash.display.Sprite;

class Room extends Sprite
{
    // var width:Int;
    // var height:Int;

    public function new(w:Int, h:Int, x:Int, y:Int)
    {
        super();
        this.graphics.beginFill(0xffffff);
        this.graphics.drawRect(x, y, w, h);
        this.graphics.endFill();
    }
}