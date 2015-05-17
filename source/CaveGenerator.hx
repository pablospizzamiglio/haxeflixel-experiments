package;

import flixel.util.FlxRandom;

class CaveGenerator
{
    private var _cave:Array<Array<Bool>>;
    private var _height:Int;
    private var _width:Int;
    private var _wallSpawningChance:Int;
    private var _maxCycles:Int;
    private var WALL_TILE:Bool = true;
    private var FLOOR_TILE:Bool = false;

    public function new(height:Int, width:Int, wallSpawningChance:Int, maxCycles:Int) {
        _height = height;
        _width = width;
        _wallSpawningChance = wallSpawningChance;
        _maxCycles = maxCycles;
    }

    private function zeroFillMatrix():Array<Array<Bool>>
    {
        var matrix:Array<Array<Bool>> = new Array();

        for (x in 0..._width)
        {
            matrix.push(new Array());

            for (y in 0..._height)
            {
                matrix[x].push(FLOOR_TILE);
            }
        }

        return matrix;
    }

    private function initializeCave():Array<Array<Bool>>
    {
        var cave:Array<Array<Bool>> = zeroFillMatrix();

        for (x in 0..._width)
        {
            for (y in 0..._height)
            {
                if (x == 0 || y == 0 || x == (_width - 1) || y == (_height - 1))
                {
                    cave[x][y] = WALL_TILE;
                }
                else if (FlxRandom.chanceRoll(_wallSpawningChance))
                {
                    cave[x][y] = WALL_TILE;
                }
                else
                {
                    cave[x][y] = FLOOR_TILE;
                }
            }
        }

        return cave;
    }

    private function getTileIndex(isWall:Bool):Int
    {
        var tileIndex:Int = 1; // Floor

        if (isWall)
        {
            tileIndex = 2; // Wall
        }

        return tileIndex;
    }

    private function generateCaveData():String
    {
        var caveData:String = "";

        for (x in 0..._width)
        {
            for (y in 0..._height)
            {
                if (y == _height - 1) {
                    caveData = caveData + getTileIndex(_cave[x][y]);
                }
                else
                {
                    caveData = caveData + getTileIndex(_cave[x][y]) + ",";
                }
            }

            if (x != _width - 1) caveData = caveData + "\n";
        }

        return caveData;
    }

    private function isOutOfBounds(x:Int, y:Int):Bool
    {
        return x < 0 || x > (_width - 1) || y < 0 || y > (_height - 1);
    }

    private function isWall(x:Int, y:Int):Bool
    {
        return isOutOfBounds(x, y) || _cave[x][y];
    }

    private function countWallsInRadius(centerX:Int, centerY:Int, radius:Int):Int
    {
        var wallCount:Int = 0;

        for (x in -radius...(radius + 1))
        {
            for (y in -radius...(radius + 1))
            {
                if (isWall(centerX + x, centerY + y)) wallCount++;
            }
        }

        return wallCount;
    }

    private function applyAutomaton(cycles:Int):Void
    {
        for (i in 0...cycles)
        {
            var softCave:Array<Array<Bool>> = zeroFillMatrix();

            for (x in 0..._width)
            {
                for (y in 0..._height)
                {
                    var wallCountR1:Int = countWallsInRadius(x, y, 1);
                    var wallCountR2:Int = countWallsInRadius(x, y, 2);

                    if (wallCountR1 >= 5 || wallCountR2 <= 2)
                    {
                        softCave[x][y] = WALL_TILE;
                    }
                    else
                    {
                        softCave[x][y] = FLOOR_TILE;
                    }
                }
            }

            _cave = softCave;
        }
    }

    private function applyAutomaton2(cycles:Int):Void
    {
        for (i in 0...cycles) {
            var softCave:Array<Array<Bool>> = zeroFillMatrix();

            for (x in 0..._width)
            {
                for (y in 0..._height)
                {
                    var wallCount:Int = countWallsInRadius(x, y, 1);

                    if (wallCount >= 5)
                    {
                        softCave[x][y] = WALL_TILE;
                    }
                    else
                    {
                        softCave[x][y] = FLOOR_TILE;
                    }
                }
            }

            _cave = softCave;
        }
    }

    public function generate():String
    {
        _cave = initializeCave();
        applyAutomaton(_maxCycles);
        applyAutomaton2(_maxCycles - 1);

        return generateCaveData();
    }
}