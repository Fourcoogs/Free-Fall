extends Node2D
class_name PlayerManager

static var _instance: PlayerManager
static var Instance: PlayerManager:
	get:
		if (_instance == null):
			_instance = PlayerManager.new()
		return _instance

var currentPlayer: Player

func _init():
	if _instance != null && _instance != self:
		queue_free()
	else:
		_instance = self

func ConnectPlayer(newPlayer: Player):
	currentPlayer = newPlayer
	pass
