extends CharacterBody2D

@export var max_health: int = 5
var health: int = 5
#var weapon: Resource
var attack_ready: bool = true
#var is_unarmed: bool
@export var speed: float = 10000
#var pickups: Array = []
var alive: bool = true

func _ready():
	health = max_health
	InventoryManager.Instance.OnHealPlayer.connect(HealPlayer)
	pass

func HealPlayer():
	health += 1

func _process(delta: float) -> void:
	if alive:
		look_at(get_global_mouse_position())
		if Input.is_action_pressed("Attack") and attack_ready:
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
