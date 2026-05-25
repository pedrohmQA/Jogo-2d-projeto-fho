extends CharacterBody2D

enum PlayerState {
	idle,
	walk,
	jump,
	swim,
	duck,
}

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var som_pulo: AudioStreamPlayer2D = $SomPulo

const DEATH_SCREEN_SCENE: PackedScene = preload("res://scene/telademorte.tscn")

@export var max_speed: float = 100.0
@export var acceleration: float = 180
@export var deceleration: float = 400.0
@export var max_jump_count: int = 2

@export var respawn_position: Vector2
@export var fall_limit: float = 1000.0

const GRAVITY: float = 980.0
const JUMP_VELOCITY: float = -330.0

const SWIM_SPEED: float = 80.0
const SWIM_UP_VELOCITY: float = -80.0
const SWIM_DRIFT: float = 30.0
const SWIM_DRIFT_ACCELERATION: float = 3.0

var jump_count: int = 0
var direction: float = 0
var status: PlayerState
var in_water: bool = false
var is_dead: bool = false

func _ready() -> void:
	if respawn_position == Vector2.ZERO:
		respawn_position = global_position

	var scene_path := get_tree().current_scene.scene_file_path
	if QuestState.has_checkpoint_for_scene(scene_path):
		respawn_position = QuestState.get_checkpoint_position()
		global_position = respawn_position

	go_to_idle_state()

func _physics_process(delta: float) -> void:
	if global_position.y > fall_limit:
		die()
		return

	if in_water:
		swim_physics(delta)
	elif not is_on_floor():
		velocity.y += GRAVITY * delta

	if is_on_floor() and Input.is_action_pressed("down"):
		if status != PlayerState.duck:
			go_to_duck_state()
	else:
		if status == PlayerState.duck and not Input.is_action_pressed("down"):
			update_direction()
			if direction != 0:
				go_to_walk_state()
			else:
				go_to_idle_state()

	match status:
		PlayerState.idle:
			idle_state(delta)
		PlayerState.walk:
			walk_state(delta)
		PlayerState.jump:
			jump_state(delta)
		PlayerState.swim:
			swim_state(delta)
		PlayerState.duck:
			duck_state(delta)

	move_and_slide()

func respawn() -> void:
	is_dead = false
	global_position = respawn_position
	velocity = Vector2.ZERO
	jump_count = 0
	in_water = false
	anim.scale = Vector2(1, 1)
	go_to_idle_state()

func voltar_ao_inicio():
	respawn()

func die() -> void:
	if is_dead:
		return

	is_dead = true
	velocity = Vector2.ZERO
	set_physics_process(false)

	var death_layer := CanvasLayer.new()
	death_layer.layer = 1000
	death_layer.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	get_tree().current_scene.add_child(death_layer)

	var death_screen = DEATH_SCREEN_SCENE.instantiate()
	death_layer.add_child(death_screen)
	death_screen.show_screen()

func go_to_duck_state() -> void:
	status = PlayerState.duck
	anim.play("duck")
	velocity.x = 0

func go_to_idle_state() -> void:
	status = PlayerState.idle
	anim.play("idle")

func go_to_walk_state() -> void:
	status = PlayerState.walk
	anim.play("walk")

func go_to_jump_state() -> void:
	status = PlayerState.jump
	anim.play("jump")
	velocity.y = JUMP_VELOCITY
	jump_count += 1
	som_pulo.play()

func go_to_fall_state() -> void:
	status = PlayerState.jump
	anim.play("jump")

func go_to_swim_state() -> void:
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

func duck_state(_delta: float) -> void:
	velocity.x = 0
	if not is_on_floor():
		go_to_fall_state()
		return
	if Input.is_action_just_pressed("jump"):
		go_to_jump_state()

func idle_state(delta: float) -> void:
	move(delta)
	if not is_on_floor():
		go_to_fall_state()
		return
	if velocity.x != 0:
		go_to_walk_state()
		return
	if Input.is_action_just_pressed("jump"):
		go_to_jump_state()

func walk_state(delta: float) -> void:
	move(delta)
	if not is_on_floor():
		go_to_fall_state()
		return
	if velocity.x == 0:
		go_to_idle_state()
		return
	if Input.is_action_just_pressed("jump"):
		go_to_jump_state()

func jump_state(delta: float) -> void:
	move(delta)
	if Input.is_action_just_pressed("jump") and jump_count < max_jump_count:
		go_to_jump_state()
	if is_on_floor():
		jump_count = 0
		if Input.is_action_pressed("down"):
			go_to_duck_state()
		elif velocity.x == 0:
			go_to_idle_state()
		else:
			go_to_walk_state()

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

func move(delta: float) -> void:
	update_direction()
	if direction:
		velocity.x = move_toward(velocity.x, direction * max_speed, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration * delta)

func update_direction() -> void:
	direction = Input.get_axis("left", "right")
	if direction < 0:
		anim.flip_h = true
	elif direction > 0:
		anim.flip_h = false
