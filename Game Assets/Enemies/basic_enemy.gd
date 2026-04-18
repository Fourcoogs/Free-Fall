class_name Enemy
extends CharacterBody2D

@export var health: int = 3
@export var patrolSpeed: float = 5000
@export var huntSpeed: float = 9000
@export var currentWaypoint: Waypoint

var currentSpeed: float
var alive: bool = true

var tileMap: TileMapLayer
var grid: AStarGrid2D
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
	Level.Instance.OnGridReady.connect(GetTileAndGrid)
	pass
	
func GetTileAndGrid(tilemap, aStarGrid):
	tileMap = tilemap
	grid = aStarGrid

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
				currentPath = PlotToPosition(currentWaypoint.position)

func Hunt():
	pass

func Attack():
	pass

func ChangeState(newState: states):
	aiState = newState
	match newState:
		states.Patrol:
			if isMoving:
				currentPath = PlotToPosition(currentWaypoint.position)
				currentSpeed = patrolSpeed

func PlotToPosition(newPosition: Vector2):
	return grid.get_id_path(tileMap.local_to_map(position),tileMap.local_to_map(newPosition))

func damage(amount, type, angle):
	health -= amount
	if health <= 0:
		aiState = states.Dead

func Movement(delta: float):
	if !currentPath.is_empty():
		var target = tileMap.map_to_local(currentPath[0])
		global_position = global_position.move_toward(target, currentSpeed * delta)
		if (global_position == target):
			currentPath.pop_front()
	pass

func HuntMovement(delta: float):
	push_error("HuntMovement not programmed")
	pass

func _physics_process(delta: float) -> void:
	Movement(delta)
	move_and_slide()
