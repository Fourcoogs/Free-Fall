extends CharacterBody2D
class_name Player

@export var max_health: int = 5
var health: int = 5
#var weapon: Resource
var attack_ready: bool = true
#var is_unarmed: bool
@export var speed: float = 10000
#var pickups: Array = []
var alive: bool = true
var punchRight: bool = true

static var selectedItem: InventoryManager.Items = InventoryManager.Items.SmokeBomb

func _init():
	PlayerManager.Instance.ConnectPlayer(self)

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
	if Input.is_action_pressed("Attack") and attack_ready:
		Attack()
	if Input.is_action_pressed("Throw") and attack_ready:
		ThrowItem()
	var items = InventoryManager.Items
	if Input.is_action_just_pressed("Select_1"):
		selectedItem = items.SmokeBomb
	if Input.is_action_just_pressed("Select_2"):
		selectedItem = items.Lure
	if Input.is_action_just_pressed("Select_3"):
		selectedItem = items.Knife

func Attack():
	attack_ready = false
	$PunchArea.monitoring = true
	$AttackCooldown.start()
	if punchRight:
		$AnimatedSprite2D.play("PunchRight")
	else:
		$AnimatedSprite2D.play("PunchLeft")
	punchRight = !punchRight
	$PunchDuration.start()
	pass

func PunchLands(body: Node2D):
	if body is Enemy:
		body.damage(1)
	pass

func DeactivatePunch():
	$PunchArea.monitoring = false

func ThrowItem():
	attack_ready = false
	$AttackCooldown.start()
	var instance = InventoryManager.Instance
	var item = instance.UseItem(selectedItem)
	if item is Node2D:
		if item is SmokeBomb:
			item.rotation = rotation
			get_parent().add_child(item)
			item.position = position

func ReadyAttack():
	attack_ready = true

func ResetAnimation():
	if alive:
		$AnimatedSprite2D.play("Idle")

func movement_method(delta):
	if alive:
		var input_dir = Input.get_vector("Left", "Right", "Up", "Down")
		velocity = input_dir * speed * delta

func _physics_process(delta: float) -> void:
	movement_method(delta)
	move_and_slide()

func damage(amount: int):
	if alive:
		health -= amount
		if health <= 0:
			alive = false

func equip():
	pass
