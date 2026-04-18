extends Node2D
class_name Pickup

@export var itemType: InventoryManager.Items

func PlayerTouched(_area: Node2D):
	if InventoryManager.Instance.GetItem(itemType):
		queue_free()
