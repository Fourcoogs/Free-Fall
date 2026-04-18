class_name Enemy
extends CharacterBody2D

@export var health: int = 3
@export var patrolSpeed: float = 5000
@export var huntSpeed: float = 9000
@export var currentWaypoint: Waypoint

var currentSpeed: float
var alive: bool = true

var currentPath: Array
var isMoving: bool = false

enum states
{
	Patrol, 
	Alert,
	Hunt,
	Attack,
	Stunned,
	Downed,
	Dead
}
var aiState: states = states.Patrol

func _ready():
	if (is_instance_valid(currentWaypoint)):
		isMoving = true
	pass

func _process(delta: float) -> void:
	match aiState:
		states.Dead:
			return
		states.Patrol:
			Patrol()
		states.Hunt:
			Hunt()
		states.Attack:
			Attack()
		states.Downed:
			pass

func Patrol():
	if isMoving:
		if currentPath.is_empty():
			if !is_instance_valid(currentWaypoint):
				isMoving = false
				return
			if currentWaypoint.global_position == global_position:
				currentWaypoint = currentWaypoint.nextWaypoint
			else:
				print("plotting")
				currentPath = Level.Instance.PlotToPosition(position, currentWaypoint.position)

func Hunt():
	pass

func Attack():
	pass

func ChangeState(newState: states):
	aiState = newState
	match newState:
		states.Patrol:
			if isMoving:
				currentPath = Level.Instance.PlotToPosition(position, currentWaypoint.position)
				currentSpeed = patrolSpeed

func damage(amount, type, angle):
	health -= amount
	if health <= 0:
		aiState = states.Dead

func Movement(delta: float):
	if !currentPath.is_empty():
		#print("path is not empty")
		var target: Vector2 = Level.Instance.MapToLocal(currentPath[0])
		position = target #position.move_toward(target, currentSpeed * delta)
		velocity = position * currentSpeed * delta
		if (position == target):
			currentPath.pop_front()
	pass

func HuntMovement(delta: float):
	push_error("HuntMovement not programmed")
	pass

func _physics_process(delta: float) -> void:
	Movement(delta)
	move_and_slide()
