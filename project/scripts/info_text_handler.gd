extends CanvasLayer

onready var control: Control = $Control
onready var label: RichTextLabel = $Control/RichTextLabel
onready var anim_plr: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	set_text('', false)
func set_text(text: String, play_anim: bool) -> void:
	label.bbcode_text = '[center][wave amp=50 freq=6]' + text
	label.rect_size = label.get_font("normal_font").get_string_size(label.text)
	label.rect_position = control.rect_size / 2 - label.rect_size / 2
	
	if play_anim:
		anim_plr.play("text_in")
