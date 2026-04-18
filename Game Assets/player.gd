extends CharacterBody2D

@export var max_health: int = 5
var health: int = 5
#var weapon: Resource
var attack_ready: bool = true
#var is_unarmed: bool
@export var speed: float = 10000
#var pickups: Array = []
var alive: bool = true

static var selectedItem: InventoryManager.Items = InventoryManager.Items.SmokeBomb

func _ready():
	health = max_health
	InventoryManager.Instance.OnHealPlayer.connect(HealPlayer)
	pass

func HealPlayer():
	if health >= max_health:
		return
	health += 1

func _process(delta: float) -> void:
	if alive:
		look_at(get_global_mouse_position())
		InputChecker()
		

func InputChecker():
	if Input.is_action_just_pressed("Attack") and attack_ready:
		pass
	if Input.is_action_just_pressed("Throw") and attack_ready:
		ThrowItem()
	var items = InventoryManager.Items
	if Input.is_action_just_pressed("Select_1"):
		selectedItem = items.SmokeBomb
	if Input.is_action_just_pressed("Select_2"):
		selectedItem = items.Lure
	if Input.is_action_just_pressed("Select_3"):
		selectedItem = items.Knife

func ThrowItem():
	var instance = InventoryManager.Instance
	if instance.UseItem(selectedItem):
		pass

func movement_method(delta):
	if alive:
		var input_dir = Input.get_vector("Left", "Right", "Up", "Down")
		velocity = input_dir * speed * delta

func _physics_process(delta: float) -> void:
	movement_method(delta)
	move_and_slide()

func damage(amount, type, angle):
	if alive:
		health -= amount
		if health <= 0:
			alive = false
			rotation_degrees = angle - 180

func equip():
	pass
