extends Node2D

onready var card: CanvasLayer = $Card
onready var dice: CanvasLayer = $Dice
onready var info_text: CanvasLayer = $InfoText

onready var anim_plr: AnimationPlayer = $AnimationPlayer

enum anims {
	CARD_SLIDE_IN,
	CARD_SLIDE_OUT,
	
	DICE_IN,
	DICE_OUT,
	
	DICE_ROLL_IN,
	DICE_ROLL_MID,
	DICE_ROLL_OUT
}

const anims_dict: Dictionary = {
	anims.CARD_SLIDE_IN: "card_slide_in",
	anims.CARD_SLIDE_OUT: "card_slide_out",
	
	anims.DICE_IN: "dice_in",
	anims.DICE_OUT: "dice_out",
	
	anims.DICE_ROLL_IN: "dice_roll_in",
	anims.DICE_ROLL_MID: "dice_roll_mid",
	anims.DICE_ROLL_OUT: "dice_roll_out"
}

var anim_queue: Array = []
var playing_queue: bool = false
var playing_queue_name: String = ""

signal queue_finished

func _ready():
	play_anim(anims.CARD_SLIDE_OUT)
	play_anim(anims.DICE_IN)
func get_anim_id(anim):
	return anims_dict[anim]
func add_anim_queue(anim):
	anim_queue.append(anim)
	
func play_anim(anim):
	return anim_plr.play(get_anim_id(anim))
func play_anim_queue():
	if anim_queue.size() > 0:
		play_anim(anim_queue[0])
		anim_queue.remove(0)
		
		return
	if playing_queue:
		playing_queue = false
	return emit_signal("queue_finished", playing_queue_name)
func play_all_anim_queue(run_name: String):
	if !playing_queue:
		playing_queue = true
		playing_queue_name = run_name
		play_anim_queue()

func gen_card():
	card.gen_card()
	play_anim(anims.CARD_SLIDE_IN)

func _on_AnimationPlayer_animation_finished(anim_name):
	if playing_queue:
		play_anim_queue()
