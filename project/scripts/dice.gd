extends CanvasLayer

onready var control: Control = $Control
onready var sprite: AnimatedSprite = $Control/AnimatedSprite
onready var timer: Timer = $Timer

const dice_anim_start: String = "dice_roll_in"
const dice_anim_end: String = "dice_roll_out"

var rng = RandomNumberGenerator.new()

var dice_rolling: bool = false
var frame_size: int

func _ready():
	frame_size = sprite.frames.animations[0].size() + 1
func _pick_rand_int(min_int: int, max_int: int):
	rng.randomize()
	return rng.randi_range(min_int, max_int)

func _on_Timer_timeout():
	sprite.frame = _pick_rand_int(0, frame_size)
func _on_AnimationPlayer_animation_started(anim_name):
	if anim_name == dice_anim_start:
		dice_rolling = true
		timer.start()
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == dice_anim_end:
		dice_rolling = false
		timer.stop()
