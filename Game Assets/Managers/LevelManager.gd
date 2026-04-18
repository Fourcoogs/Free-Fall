extends Node
class_name LevelManager

var currentLevel = -1
var preloadedLevelArray = null

static var _instance: LevelManager
static var Instance: LevelManager:
	get:
		if _instance == null:
			_instance = LevelManager.new()
		return _instance

func _init():
	if _instance != null && _instance != self:
		queue_free()
	else:
		_instance = self
		
func _ready() -> void:
	pass#LEVEL_1_SCENE = preload("res://Levels/level_2.tscn")

func Reset():
	preloadedLevelArray = ["res://Levels/level_1.tscn",
	"res://Levels/level_2.tscn", "res://Levels/level_3.tscn","res://Levels/level_4.tscn"]
	
	Engine.get_main_loop().change_scene_to_file(preloadedLevelArray[currentLevel])

func nextLevel():
	preloadedLevelArray = ["res://Levels/level_1.tscn",
	"res://Levels/level_2.tscn", "res://Levels/level_3.tscn","res://Levels/level_4.tscn"]
	
	currentLevel = currentLevel + 1
	
	if currentLevel >= 0 and currentLevel < preloadedLevelArray.size():
		Engine.get_main_loop().change_scene_to_file(preloadedLevelArray[currentLevel])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
