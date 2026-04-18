extends Node2D
class_name Level

static var _instance: Level
static var Instance: Level:
	get:
		return _instance

@export var tileMap: TileMapLayer
var grid: AStarGrid2D

signal OnGridReady(mapValue: TileMapLayer, gridValue: AStarGrid2D)

func _init():
	_instance = self

func _ready():
	grid = AStarGrid2D.new()
	var usedRect = tileMap.get_used_rect()
	grid.region = usedRect
	#grid.offset = usedRect.position
	grid.cell_size = Vector2i(100, 100)
	grid.update()
	#OnGridReady.emit(tileMap, grid)

func PlotToPosition(currentPosition:Vector2, newPosition: Vector2):
	var returnable: Array = grid.get_id_path(tileMap.local_to_map(currentPosition),tileMap.local_to_map(newPosition))
	returnable.pop_front()
	print(returnable)
	return returnable

func MapToLocal(vector: Vector2i):
	print(str(vector))
	return tileMap.map_to_local(vector)

func LocalToMap(vector: Vector2):
	return tileMap.local_to_map(vector)
