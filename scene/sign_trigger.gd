extends Area2D

@export_multiline var message: String = "O rio e a floresta estão poluídos, e isso está afetando a vida dos animais! Rápido, você deve recolher todo o lixo em até 3 minutos."

@export var dialog_ui_path: NodePath = ^"DialogUI"
@export var dialog_label_path: NodePath = ^"DialogUI/Panel/MarginContainer/TextLabel"

@export var hud_path_primary: NodePath = ^"HUD"
@export var hud_path_fallback: NodePath = ^"Hud_tscn"

@export var hud_timer_label_path_primary: NodePath = ^"HUD/TimerLabel"
@export var hud_timer_label_path_fallback: NodePath = ^"Hud_tscn/TimerLabel"

@export var close_on_exit: bool = true
@export var toggle_with_interact: bool = true

@export_range(1, 60, 1) var countdown_minutes: int = 3
@export var start_countdown_on_first_open: bool = true
@export var restart_scene_on_timeout: bool = true

var _player_in_range := false
var _dialog_open := false

var _dialog_ui: CanvasLayer
var _dialog_label: Label
var _hud: CanvasLayer
var _timer_label: Label

var _countdown_started := false
var _seconds_left: int = 0

@onready var _tick_timer: Timer = Timer.new()

func _ready() -> void:
	_dialog_ui = _get_current_scene_node(dialog_ui_path) as CanvasLayer
	_dialog_label = _get_current_scene_node(dialog_label_path) as Label

	_hud = (_get_current_scene_node(hud_path_primary) as CanvasLayer)
	if _hud == null:
		_hud = (_get_current_scene_node(hud_path_fallback) as CanvasLayer)

	_timer_label = (_get_current_scene_node(hud_timer_label_path_primary) as Label)
	if _timer_label == null:
		_timer_label = (_get_current_scene_node(hud_timer_label_path_fallback) as Label)

	if _dialog_ui == null:
		push_error("SignTrigger: não achei DialogUI em: %s" % str(dialog_ui_path))
		return
	if _dialog_label == null:
		push_error("SignTrigger: não achei TextLabel em: %s" % str(dialog_label_path))
		return

	_dialog_ui.visible = false

	_tick_timer.one_shot = false
	_tick_timer.wait_time = 1.0
	add_child(_tick_timer)
	if not _tick_timer.timeout.is_connected(_on_tick):
		_tick_timer.timeout.connect(_on_tick)

	_seconds_left = countdown_minutes * 60
	_update_timer_label()

	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
	if not body_exited.is_connected(_on_body_exited):
		body_exited.connect(_on_body_exited)

func _process(_delta: float) -> void:
	if _countdown_started and QuestState.is_tropic_garbage_done():
		_stop_countdown()

	if _player_in_range and Input.is_action_just_pressed("interact"):
		if toggle_with_interact:
			_toggle_dialog()
		else:
			_open_dialog()

	if _dialog_open and Input.is_action_just_pressed("ui_cancel"):
		_close_dialog()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		_player_in_range = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		_player_in_range = false
		if close_on_exit:
			_close_dialog()

func _toggle_dialog() -> void:
	if _dialog_open:
		_close_dialog()
	else:
		_open_dialog()

func _open_dialog() -> void:
	if _dialog_open:
		return

	# TOCA O SOM DE INTERAÇÃO AO ABRIR O DIÁLOGO
	SoundManager.play_interaction_sound()

	_dialog_open = true
	_dialog_ui.visible = true
	_dialog_label.text = message

	if is_instance_valid(_hud):
		_hud.visible = false

	if start_countdown_on_first_open and not _countdown_started:
		_start_countdown()

func _close_dialog() -> void:
	if not _dialog_open:
		return

	_dialog_open = false
	if is_instance_valid(_dialog_ui):
		_dialog_ui.visible = false

	if is_instance_valid(_hud):
		_hud.visible = true

func _start_countdown() -> void:
	if QuestState.is_tropic_garbage_done():
		_stop_countdown()
		return

	_countdown_started = true
	_seconds_left = countdown_minutes * 60
	_update_timer_label()

	_tick_timer.stop()
	_tick_timer.start()

func _stop_countdown(show_complete_text: bool = true) -> void:
	_countdown_started = false
	if is_instance_valid(_tick_timer):
		_tick_timer.stop()

	if show_complete_text and is_instance_valid(_timer_label):
		_timer_label.text = "OK"

func _on_tick() -> void:
	if not _countdown_started:
		_tick_timer.stop()
		return

	if QuestState.is_tropic_garbage_done():
		_stop_countdown()
		return

	_seconds_left -= 1
	if _seconds_left < 0:
		_seconds_left = 0

	_update_timer_label()

	if _seconds_left <= 0:
		_tick_timer.stop()
		if restart_scene_on_timeout and not QuestState.is_tropic_garbage_done():
			get_tree().reload_current_scene()

func _update_timer_label() -> void:
	if not is_instance_valid(_timer_label):
		return

	var m := _seconds_left / 60
	var s := _seconds_left % 60
	_timer_label.text = "%02d:%02d" % [m, s]

func _get_current_scene_node(path: NodePath) -> Node:
	if path.is_empty():
		return null
	var scene := get_tree().current_scene
	if scene == null:
		return null
	return scene.get_node_or_null(path)
