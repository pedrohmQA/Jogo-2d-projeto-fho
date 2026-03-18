extends KinematicBody2D

# Exported variables to adjust Camera2D limit
export var camera_limit_bottom_normal: int = 208
export var camera_limit_bottom_water: int = 320

func _apply_camera_limit_bottom():
    var camera = get_viewport().get_camera_2d()
    if camera:
        camera.limit_bottom = self.position.y + (camera_limit_bottom_normal if !is_in_water else camera_limit_bottom_water)

func enter_water():
    is_in_water = true
    _apply_camera_limit_bottom()

func exit_water():
    is_in_water = false
    _apply_camera_limit_bottom()