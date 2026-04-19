extends Node2D
class_name Level

static var _instance: Level
static var Instance: Level:
	get:
		return _instance

@export var musicTheme: AudioStream
var tileMap: TileMapLayer
var grid: AStarGrid2D

signal OnGridReady(mapValue: TileMapLayer, gridValue: AStarGrid2D)

func _init():
	_instance = self

func _ready():
	if musicTheme != null:
		AudioManager.stream = musicTheme
		AudioManager.play()
	tileMap = $TileMapLayer
	grid = AStarGrid2D.new()
	var usedRect = tileMap.get_used_rect()
	grid.region = usedRect
	#grid.offset = usedRect.position
	grid.cell_size = Vector2i(32, 32)
	grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	grid.update()
	var coords = tileMap.get_used_cells()
	for i in coords:
		var data = tileMap.get_cell_tile_data(i)
		if data.get_custom_data("BlockNav"):
			#print("setting solid")
			grid.set_point_solid(i)
			#tileMap.set_cell(i, 6, Vector2i(3, 0))
		#print(i, grid.is_point_solid(i))
	#OnGridReady.emit(tileMap, grid)

func PlotToPosition(currentPosition:Vector2, newPosition: Vector2):
	var returnable: Array = grid.get_id_path(tileMap.local_to_map(currentPosition),tileMap.local_to_map(newPosition))
	returnable.pop_front()
	#print(returnable)
	return returnable

func MapToLocal(vector: Vector2i):
	#print(str(vector))
	return to_global(tileMap.map_to_local(vector))

func LocalToMap(vector: Vector2):
	return tileMap.local_to_map(tileMap.to_local(vector))
