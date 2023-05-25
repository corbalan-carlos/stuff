module New(
Values,
Row,
Tile,
first,
second,
third,
rowToString) where
import System.Random
data TileMap = TileMap (Int,Int) (Int,Int) (Int,Int) (Int,Int) deriving (Show)
data PercTile = PercTile Int [Int] [Int] [Int] [Int] deriving (Show)
data Values = Empty| Full
type Row = (Values,Values,Values)
type Tile = (Row, Row, Row)
data NumberedTile = NTile Int Tile
instance Show Values where 
    show Empty = show ' '
    show Full =  show '#'
first4:: (x,x,x,x) -> x
first4 (x,_,_,_) = x
second4:: (x,x,x,x) -> x
second4 (_,x,_,_) = x
third4:: (x,x,x,x) -> x
third4 (_,_,x,_) = x
fourth4 :: (x,x,x,x) -> x
fourth4 (_,_,_,x) = x
first:: (x,x,x) -> x
first (x,_,_) = x
second:: (x,x,x) -> x
second (_,x,_) = x
third:: (x,x,x) -> x
third (_,_,x) = x
rowToString:: Row -> [Char]
rowToString x= show  $ (first x):(second x):(third x):[]
showFullRow:: ((Row,Row,Row) -> Row) -> (Tile,Tile,Tile) -> String
showFullRow f x=show $ (rowToString $ f (first x)):(rowToString $ f (second x)):(rowToString $ f (third x)):[]
printable:: [Tile] -> [String]
printable [] = []
printable (x:y:z:xs) = (showFullRow first (x,y,z)): (showFullRow second (x,y,z)) : (showFullRow third (x,y,z)) : printable xs
getMemberN:: [a] -> Int -> a
getMemberN (x:xs) 1 = x
getMemberN (x:xs) y= getMemberN xs (y-1)
getAll:: [(Int,Int)] -> [(Int,Int)] -> [TileMap]
getAll [] _ = []
getAll (x:xs) a = (getRight x a):getAll xs a 
getRight:: (Int,Int) -> [(Int,Int)] -> TileMap
getRight (x,y) a = if x+1 > (length a) then getLeft (0,0) (x,y) a else getLeft (getMemberN  a (x+1)) (x,y) a
getLeft:: (Int,Int) -> (Int,Int) -> [(Int,Int)] -> TileMap
getLeft (a,b) (x,y) c = if x-1 < 1 then getDown (0,0) (a,b) (x,y) c else getDown (getMemberN  c (x-1)) (a,b) (x,y) c
getDown:: (Int,Int) -> (Int,Int) -> (Int,Int)-> [(Int,Int)] -> TileMap
getDown (a,b) (c,d) (x,y) e = if (x+3) >(length e) then getUp (0,0) (a,b) (c,d) (x,y) e else getUp (getMemberN  e( x+3)) (a,b) (c,d) (x,y) e
getUp:: (Int,Int) -> (Int,Int) -> (Int,Int) -> (Int,Int) -> [(Int,Int)] -> TileMap
getUp (a,b) (c,d) (e,f) (x,y) g = if (x-3) < 1 then TileMap (a,b) (c,d) (e,f) (0,0) else TileMap (getMemberN  g (x-3)) (a,b) (c,d) (e,f)
getPercTile:: [(Int,Int)] -> Int-> TileMap -> [(Int,Int)] -> ([Int],[Int],[Int],[Int]) ->  PercTile
getPercTile y tileId (TileMap a b c d) [] x = PercTile tileId (first4 x) (second4 x) (third4 x) (fourth4 x)
getPercTile y tileId (TileMap a b c d) (tileExplored:restOfTiles) x = if tileId==(snd tileExplored) then getPercTile y tileId (TileMap a b c d) restOfTiles x' else getPercTile y tileId (TileMap a b c d) restOfTiles x where 
        (TileMap a' b' c' d') = getRight tileExplored y 
        x' = ((snd  a'):(first4 x),(snd b'):(second4 x), (snd c'):(third4 x), (snd d'):(fourth4 x))

main = do
    putStrLn $show $ getPercTile tileN 5 (getRight (5,5) tileN) tileN ([],[],[],[])
    putStr (unlines $  printable tileMap)
    where    tile1=((Full,Full,Full),(Full,Empty,Empty),(Full,Empty,Empty))::Tile
             tile2=((Full,Full,Full),(Empty,Empty,Empty),(Empty,Empty,Empty))::Tile
             tile3=((Full,Full,Full),(Empty,Empty,Full),(Empty,Empty,Full))::Tile
             tile4=((Full,Empty,Empty),(Full,Empty,Empty),(Full,Empty,Empty))::Tile
             tile5=((Empty,Empty,Empty),(Empty,Empty,Empty),(Empty,Empty,Empty))::Tile
             tile6=((Empty,Empty,Full),(Empty,Empty,Full),(Empty,Empty,Full))::Tile
             tile7=((Full,Empty,Empty),(Full,Empty,Empty),(Full,Full,Full))::Tile
             tile9=((Empty,Empty,Full),(Empty,Empty,Full),(Full,Full,Full))::Tile
             tile10=((Empty,Empty,Empty),(Empty,Empty,Empty),(Full,Full,Full))::Tile
             tileN=[(1,1),(2,2),(3,3),(4,4),(5,5),(6,6),(7,7),(8,5),(9,9),(10,6),(11,5),(12,4),(13,1),(14,5),(15,3),(16,4),(17,5),(18,6),(19,7),(20,10),(21,9)]
             tileMap=[tile1,tile2,tile3,tile4,tile5,tile6,tile7,tile5,tile9,tile6,tile5,tile4, tile1,tile5,tile3,tile4,tile5,tile6,tile7,tile10,tile9]
            
