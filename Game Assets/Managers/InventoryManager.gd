extends Node
class_name InventoryManager

static var _instance: InventoryManager
static var Instance: InventoryManager:
	get:
		if _instance == null:
			_instance = InventoryManager.new()
		return _instance

#items
var _smokeBombs: int = 0
var smokeBombsHeld: int:
	get:
		return _smokeBombs
	set(value):
		_smokeBombs = value
		OnSmokeBombsUpdated.emit(value)
signal OnSmokeBombsUpdated(newAmount: int)
var initialSmokeBombsHeld: int = 0
@export var maxSmokeBombs: int = 3

var _lures: int = 0
var luresHeld: int:
	get:
		return _lures
	set(value):
		_lures = value
		OnLuresUpdated.emit(value)
signal OnLuresUpdated(newAmount: int)
var initialLuresHeld: int = 0
@export var maxLures: int = 3

var _knives: int = 0
var knivesHeld: int:
	get:
		return _knives
	set(value):
		_knives = value
		OnKnivesUpdated.emit(value)
signal OnKnivesUpdated(newAmount: int)
var initialKnivesHeld: int = 0
@export var maxKnives: int = 3

var _parachutes: int = 0
var parachutesHeld: int:
	get:
		return _parachutes
	set(value):
		_parachutes = value
		OnParachutesUpdated.emit(value)
signal OnParachutesUpdated(newAmount: int)
var initialParachutesHeld: int = 0

var isKeyHeld: bool = false
signal OnKeyPickedUp

signal OnHealPlayer

enum Items
{
	SmokeBomb, Lure, Knife, Key, Parachute, Health
}

func _init():
	if _instance != null && _instance != self:
		queue_free()
	else:
		_instance = self

func GetItem(type: Items):
	match type:
		Items.SmokeBomb:
			if smokeBombsHeld == maxSmokeBombs:
				return false
			else:
				smokeBombsHeld += 1
				return true
		Items.Lure:
			if luresHeld == maxLures:
				return false
			else:
				luresHeld += 1
				return true
		Items.Knife:
			if knivesHeld == maxKnives:
				return false
			else:
				knivesHeld += 1
				return true
		Items.Parachute:
			parachutesHeld += 1
			return true
		Items.Key:
			isKeyHeld = true
			OnKeyPickedUp.emit()
			return true
		Items.Health:
			OnHealPlayer.emit()
			return true

func UseItem(type: Items):
	match type:
		Items.SmokeBomb:
			if smokeBombsHeld > 0:
				smokeBombsHeld -= 1
				return true
			return false
		Items.Lure:
			if luresHeld > 0:
				luresHeld -= 1
				return true
			return false
		Items.Knife:
			if knivesHeld > 0:
				knivesHeld -= 1
				return true
			return false
	return false

func ResetItems():
	smokeBombsHeld = initialSmokeBombsHeld
	luresHeld = initialLuresHeld
	knivesHeld = initialKnivesHeld
	parachutesHeld = initialParachutesHeld
	isKeyHeld = false
	pass

func NewLevelLoaded():
	initialSmokeBombsHeld = smokeBombsHeld
	initialLuresHeld = luresHeld
	initialKnivesHeld = knivesHeld
	initialParachutesHeld = parachutesHeld
	isKeyHeld = false
