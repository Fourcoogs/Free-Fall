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
var player: Node2D

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
		states.Alert:
			Alert()
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

func Alert():
	look_at(player.position)

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
		states.Alert:
			currentPath.clear()
			$AlertArrow.play()
			$AnimatedSprite2D.pause()
			pass
		states.Hunt:
			pass

func AlertFinished():
	ChangeState(states.Hunt)

func damage(amount, type, angle):
	health -= amount
	if health <= 0:
		ChangeState(states.Dead)

func PlayerSpotted(body: Node2D):
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(global_position, body.global_position, 1 << 1)
	var result = space_state.intersect_ray(query)
	if !result:
		#currentPath.clear()
		player = body
		ChangeState(states.Alert)
	pass

func Movement(delta: float):
	if !currentPath.is_empty():
		look_at(target)
		position = position.move_toward(target, currentSpeed * delta)
		if (position == target):
			currentPath.pop_front()
			if currentPath.is_empty():
				pathCompleted = true
				return
			target = Level.Instance.MapToLocal(currentPath[0])
	pass

func _physics_process(delta: float) -> void:
	Movement(delta)
	move_and_slide()
