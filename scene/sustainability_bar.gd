extends Control

@export var textures_dir := "res://sprites/barra_sustentabilidade"
@export var max_points := 9
@export var frames_are_descending := true

@onready var bar_texture := $TextureRect as TextureRect

var _frames: Array[Texture2D] = []
var _last_index := -1

func _ready() -> void:
	_load_frames()
	_update_bar()
	set_process(true)

func _process(_delta: float) -> void:
	_update_bar()

func _load_frames() -> void:
	_frames.clear()

	var dir := DirAccess.open(textures_dir)
	if dir == null:
		return

	var file_names: Array[String] = []
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and file_name.to_lower().ends_with(".png"):
			file_names.append(file_name)
		file_name = dir.get_next()
	dir.list_dir_end()

	file_names.sort_custom(Callable(self, "_compare_sprite_names"))

	for name in file_names:
		var texture := load("%s/%s" % [textures_dir, name]) as Texture2D
		if texture != null:
			_frames.append(texture)

func _compare_sprite_names(a: String, b: String) -> bool:
	return _extract_index(a) < _extract_index(b)

func _extract_index(file_name: String) -> int:
	var base := file_name.get_basename()
	var tail := base.trim_prefix("sprite_")
	var number_text := tail.split(" ")[0]
	if not number_text.is_valid_int():
		return 0
	return int(number_text)

func _update_bar() -> void:
	if bar_texture == null or _frames.is_empty():
		return

	var points := clampi(QuestState.get_sustainability_points(), 0, max_points)
	var frame_index := _points_to_frame(points)
	if frame_index == _last_index:
		return

	_last_index = frame_index
	bar_texture.texture = _frames[frame_index]

func _points_to_frame(points: int) -> int:
	var max_index := _frames.size() - 1
	if max_index <= 0:
		return 0
	if max_points <= 0:
		return max_index

	var ratio := float(points) / float(max_points)
	var index := int(round(ratio * float(max_index)))
	index = clampi(index, 0, max_index)
	if frames_are_descending:
		return max_index - index
	return index
