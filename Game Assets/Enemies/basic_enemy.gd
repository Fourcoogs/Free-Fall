class_name Enemy
extends CharacterBody2D

@export var health: int = 3
@export var patrolSpeed: float = 50
@export var huntSpeed: float = 90
@export var currentWaypoint: Waypoint

var currentSpeed: float
var alive: bool = true

var currentPath: Array
var pathCompleted: bool
var target: Vector2
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
	currentSpeed = patrolSpeed
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
			if pathCompleted:
				print("destination reached")
				currentWaypoint = currentWaypoint.nextWaypoint
				pathCompleted = false
			else:
				print("plotting")
				currentPath = Level.Instance.PlotToPosition(position, currentWaypoint.position)
				target = Level.Instance.MapToLocal(currentPath[0])

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
				target = Level.Instance.MapToLocal(currentPath[0])
				currentSpeed = patrolSpeed

func damage(amount, type, angle):
	health -= amount
	if health <= 0:
		aiState = states.Dead

func Movement(delta: float):
	if !currentPath.is_empty():
		#print("path is not empty")
		#var target: Vector2 = Level.Instance.MapToLocal(currentPath[0])
		#print (str(position) + " -> " + str(position.move_toward(target, currentSpeed * delta)) + " => " + str(target))
		position = position.move_toward(target, currentSpeed * delta)
		if (position == target):
			currentPath.pop_front()
			if currentPath.is_empty():
				pathCompleted = true
				return
			target = Level.Instance.MapToLocal(currentPath[0])
	pass

func HuntMovement(delta: float):
	push_error("HuntMovement not programmed")
	pass

#func CustomMoveToward(target: Vector2, speed: float):
	#if position == target:
		#return
	#var direction = position.direction_to(target)
	#var lower: bool = false
	#var righter: bool = false
	#if position.x > target.x:
		#righter = true
	#if position.y > target.y:
		#lower = true
	#position += direction * speed
	#if lower:
		#if position.y <= target.y:
			#position.y = target.y
	#else:
		#if position.y >= target.y:
			#position.y = target.y
	#if righter:
		#if position.x <= target.x:
			#position.x = target.x
	#else:
		#if position.x >= target.x:
			#position.x = target.x 
	#pass

func _physics_process(delta: float) -> void:
	Movement(delta)
	move_and_slide()
