extends Sprite

onready var path: Path2D = get_parent()
onready var tween: Tween = $Tween

const cell_size: int = 24
const min_tween_speed: float = 0.1

var points: Array = []

var current_point: int = 0
var dist_left: int = 0

var tween_speed: float = 1.0

signal _on_move_completed

func move(point_offsets, dist):
	if dist == 0:
		emit_signal("_on_move_completed", current_point, false)
		return false
		
	points = point_offsets
	dist_left = dist
	current_point = current_point + dist_left / abs(dist_left)
	
	if current_point > point_offsets.size() - 1:
		dist_left = 0
		current_point = point_offsets.size() - 1
	
	tween.interpolate_property(
		self, "position",
		position, point_offsets[current_point], tween_speed,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)
	return tween.start()
func _process(delta):
	if Input.is_action_just_released("speed_up"):
		tween_speed += 0.1
	elif Input.is_action_just_released("speed_down"):
		if tween_speed - 0.1 >= min_tween_speed:
			tween_speed -= 0.1
		else:
			tween_speed = min_tween_speed
func _on_Tween_tween_completed(_object, _key):
	if dist_left > 0:
		dist_left -= 1
	elif dist_left < 0:
		dist_left += 1
	
	if dist_left != 0:
		return move(points, dist_left)
	emit_signal("_on_move_completed", current_point, true)
