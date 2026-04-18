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
	grid.region = tileMap.get_used_rect()
	grid.cell_size = Vector2i(16, 16)
	grid.update()
	OnGridReady.emit(tileMap, grid)
	
