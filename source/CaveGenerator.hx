package;

class CaveGenerator
{
    private var _cave:Array<Array<Bool>>;
    private var _maxColumns:Int;
    private var _maxRows:Int;
    private var _wallSpawningChance:Int;
    private var WALL_TILE:Bool = true;
    private var FLOOR_TILE:Bool = false;

    public function new(maxColumns:Int, maxRows:Int, wallSpawningChance:Int) {
        _maxColumns = maxColumns;
        _maxRows = maxRows;
        _wallSpawningChance = wallSpawningChance;
        _cave = initializeCave();
    }

    private function zeroFillMatrix():Array<Array<Bool>>
    {
        var matrix:Array<Array<Bool>> = new Array();

        for (row in 0..._maxRows)
        {
            matrix.push(new Array());

            for (column in 0..._maxColumns)
            {
                matrix[row].push(false);
            }
        }

        return matrix;
    }

    private function initializeCave():Array<Array<Bool>>
    {
        var cave:Array<Array<Bool>> = zeroFillMatrix();

        for (row in 0..._maxRows)
        {
            for (column in 0..._maxColumns)
            {
                if (Std.random(101) < _wallSpawningChance)
                {
                    cave[row][column] = WALL_TILE;
                }
                else
                {
                    cave[row][column] = FLOOR_TILE;
                }
            }
        }

        return cave;
    }

    private function getTileIndex(isWall:Bool):Int
    {
        var tileIndex:Int = 11; // Floor

        if (isWall)
        {
            tileIndex = 14; // Wall
        }

        return tileIndex;
    }

    private function generateCaveData():String
    {
        var caveData:String = "";

        for (row in 0..._maxRows)
        {
            for (column in 0..._maxColumns)
            {
                if (column == _maxColumns) {
                    caveData = caveData + getTileIndex(_cave[row][column]);
                }
                else
                {
                    caveData = caveData + getTileIndex(_cave[row][column]) + ",";
                }
            }

            if (row != _maxRows) caveData = caveData + "\n";
        }

        return caveData;
    }

    private function isOutOfBounds(row:Int, column:Int):Bool
    {
        return (row < 0 || row > (_maxRows - 1) || column < 0 || column > (_maxColumns - 1));
    }

    private function isWall(row:Int, column:Int):Bool
    {
        var isWall:Bool = false;

        if (isOutOfBounds(row, column) || _cave[row][column])
        {
            isWall = true;
        }

        return isWall;
    }

    private function countAdjacentWalls(currentRow:Int, currentColumn:Int):Int
    {
        var startingRow:Int = currentRow - 1;
        var endingRow:Int = currentRow + 1;
        var startingColumn:Int = currentColumn - 1;
        var endingColumn:Int = currentColumn + 1;

        var wallCount:Int = 0;

        for (row in startingRow...endingRow)
        {
            for (column in startingColumn...endingColumn)
            {
                if (row != currentRow && column != currentColumn)
                {
                    if (isWall(row, column)) wallCount++;
                }
            }
        }

        return wallCount;
    }

    public function softenCave():Void
    {
        var softCave:Array<Array<Bool>> = zeroFillMatrix();

        for (row in 0..._maxRows)
        {
            for (column in 0..._maxColumns)
            {
                var wallCount:Int = countAdjacentWalls(row, column);

                if (wallCount >= 5)
                {
                    softCave[row][column] = WALL_TILE;
                    //_cave[row][column] = WALL_TILE;
                }
                else
                {
                    softCave[row][column] = FLOOR_TILE;
                    //_cave[row][column] = FLOOR_TILE;
                }
            }
        }

        _cave = softCave;
    }

    public function generate():String
    {
        softenCave();

        return generateCaveData();
    }
}