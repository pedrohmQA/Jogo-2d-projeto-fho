extends CanvasLayer

@export var resume_button_path: NodePath
@export var restart_button_path: NodePath
@export var quit_button_path: NodePath

@onready var btn_resume: Button = get_node_or_null(resume_button_path) as Button
@onready var btn_restart: Button = get_node_or_null(restart_button_path) as Button
@onready var btn_quit: Button = get_node_or_null(quit_button_path) as Button

func _ready() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS

	if btn_resume == null or btn_restart == null or btn_quit == null:
		push_error("PauseMenu: botão(s) null. Confira os NodePaths exportados no Inspector.")
		push_error("resume=" + str(resume_button_path) + " -> " + str(btn_resume))
		push_error("restart=" + str(restart_button_path) + " -> " + str(btn_restart))
		push_error("quit=" + str(quit_button_path) + " -> " + str(btn_quit))
		return

	btn_resume.pressed.connect(resume)
	btn_restart.pressed.connect(restart_level)
	btn_quit.pressed.connect(quit_to_desktop)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_pause"):
		toggle()
		get_viewport().set_input_as_handled()

func toggle() -> void:
	visible = not visible
	get_tree().paused = visible

func resume() -> void:
	visible = false
	get_tree().paused = false

func restart_level() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func quit_to_desktop() -> void:
	get_tree().paused = false
	get_tree().quit()
