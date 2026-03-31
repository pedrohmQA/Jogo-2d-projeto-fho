extends CharacterBody2D

enum PlayerState {
	idle,
	walk,
	jump,
	swim,
}

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

@export var max_speed: float = 180.0
@export var acceleration: float = 400.0
@export var deceleration: float = 400.0
@export var max_jump_count: int = 2

const GRAVITY: float = 980.0
const JUMP_VELOCITY: float = -300.0

const SWIM_SPEED: float = 80.0
const SWIM_UP_VELOCITY: float = -80.0
const SWIM_DRIFT: float = 30.0
const SWIM_DRIFT_ACCELERATION: float = 3.0

var jump_count: int = 0
var direction: float = 0
var status: PlayerState
var in_water: bool = false


func _ready() -> void:
	go_to_idle_state()


func _physics_process(delta: float) -> void:
	if in_water:
		swim_physics(delta)
	elif not is_on_floor():
		velocity.y += GRAVITY * delta

	match status:
		PlayerState.idle:
			idle_state(delta)
		PlayerState.walk:
			walk_state(delta)
		PlayerState.jump:
			jump_state(delta)
		PlayerState.swim:
			swim_state(delta)

	move_and_slide()


# =====================
# STATES
# =====================

func go_to_idle_state():
	status = PlayerState.idle
	anim.scale = Vector2(1, 1)
	anim.play("idle")


func go_to_walk_state():
	status = PlayerState.walk
	anim.scale = Vector2(1, 1)
	anim.play("walk")


func go_to_jump_state():
	status = PlayerState.jump
	anim.scale = Vector2(1, 1)
	anim.play("jump")
	velocity.y = JUMP_VELOCITY
	jump_count += 1


func go_to_swim_state():
	status = PlayerState.swim
	anim.play("swim")
	anim.scale = Vector2(0.6, 0.6)
	jump_count = 0
	velocity.y = minf(velocity.y, 0.0)


func enter_water() -> void:
	in_water = true
	go_to_swim_state()


func exit_water() -> void:
	in_water = false
	anim.scale = Vector2(1, 1)
	status = PlayerState.jump
	anim.play("jump")
	jump_count = 1


# =====================
# STATE LOGIC
# =====================

func idle_state(delta):
	move(delta)

	if velocity.x != 0:
		go_to_walk_state()
		return

	if Input.is_action_just_pressed("jump"):
		go_to_jump_state()
		return


func walk_state(delta):
	move(delta)

	if velocity.x == 0:
		go_to_idle_state()
		return

	if Input.is_action_just_pressed("jump"):
		go_to_jump_state()
		return


func jump_state(delta):
	move(delta)

	if Input.is_action_just_pressed("jump") and jump_count < max_jump_count:
		go_to_jump_state()

	if is_on_floor():
		jump_count = 0
		if velocity.x == 0:
			go_to_idle_state()
		else:
			go_to_walk_state()
		return


func swim_physics(delta: float) -> void:
	velocity.y = move_toward(
		velocity.y,
		SWIM_DRIFT,
		SWIM_DRIFT * delta * SWIM_DRIFT_ACCELERATION
	)


func swim_state(delta: float) -> void:
	update_direction()

	if direction:
		velocity.x = move_toward(velocity.x, direction * SWIM_SPEED, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration * delta)

	if Input.is_action_pressed("jump"):
		velocity.y = SWIM_UP_VELOCITY


# =====================
# MOVEMENT
# =====================

func move(delta):
	update_direction()

	if direction:
		velocity.x = move_toward(velocity.x, direction * max_speed, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration * delta)


func update_direction():
	direction = Input.get_axis("left", "right")

	if direction < 0:
		anim.flip_h = true
	elif direction > 0:
		anim.flip_h = false
