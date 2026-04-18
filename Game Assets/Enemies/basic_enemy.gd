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
var playerInView: bool = false
var canAttack: bool = true

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
	player = PlayerManager.Instance.currentPlayer
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
	if playerInView:
		PlayerSearch()

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
	currentPath = Level.Instance.PlotToPosition(position, player.position)

func Attack():
	look_at(player.position)
	if canAttack:
		FireAttack()

func FireAttack():
	print("pew!")
	canAttack = false
	$AttackTimer.start()

func ReadyAttack():
	canAttack = true

func ChangeState(newState: states):
	currentPath.clear()
	aiState = newState
	$AnimatedSprite2D.play("Walking")
	$SearchTimer.stop()
	$StunTimer.stop()
	$SleepTimer.stop()
	match newState:
		states.Patrol:
			if isMoving:
				currentPath = Level.Instance.PlotToPosition(position, currentWaypoint.position)
				target = Level.Instance.MapToLocal(currentPath[0])
				currentSpeed = patrolSpeed
		states.Alert:
			$AlertArrow.play()
			$AnimatedSprite2D.pause()
			pass
		states.Hunt:
			$SearchTimer.start()
			currentSpeed = huntSpeed
			pass
		states.Attack:
			$AnimatedSprite2D.play("FiringAttack")
		states.Stunned:
			$AnimatedSprite2D.play("Stun")
			$StunTimer.start()
		states.Downed:
			$AnimatedSprite2D.play("Downed")
			$SleepTimer.start()

func AlertFinished():
	ChangeState(states.Hunt)
func ReturnToPatrol():
	ChangeState(states.Patrol)
func Recombobulate():
	ChangeState(states.Hunt)
func Wakeup():
	health = 3
	ReturnToPatrol()

func damage(amount):
	health -= amount
	if health <= 0:
		ChangeState(states.Downed)
	else:
		ChangeState(states.Stunned)

func PlayerSpotted(body: Node2D):
	player = body
	playerInView = true

func PlayerLost(body: Node2D):
	if (aiState == states.Attack):
		ChangeState(states.Hunt)
	playerInView = false

func PlayerSearch():
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(global_position, player.global_position, 1 << 1)
	var result = space_state.intersect_ray(query)
	if !result:
		if aiState == states.Patrol:
			ChangeState(states.Alert)
		if aiState == states.Hunt:
			ChangeState(states.Attack)
	else:
		if aiState == states.Attack:
			ChangeState(states.Hunt)

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
