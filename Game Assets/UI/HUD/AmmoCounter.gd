extends Label

@export var itemType: InventoryManager.Items

func _ready():
	var type = InventoryManager.Items
	var instance = InventoryManager.Instance
	match itemType:
		type.SmokeBomb:
			instance.OnSmokeBombsUpdated.connect(UpdateText)
			UpdateText(instance.smokeBombsHeld)
		type.Lure:
			instance.OnLuresUpdated.connect(UpdateText)
			UpdateText(instance.luresHeld)
		type.Knife:
			instance.OnKnivesUpdated.connect(UpdateText)
			UpdateText(instance.knivesHeld)

func UpdateText(newText: int):
	text = str(newText)
