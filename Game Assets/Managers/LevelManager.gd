extends Node

static var _instance: InventoryManager
static var Instance: InventoryManager:
	get:
		if _instance == null:
			_instance = InventoryManager.new()
		return _instance
		
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
