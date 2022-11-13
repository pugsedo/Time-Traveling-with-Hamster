extends Path2D

onready var tilemap: TileMap = $TileMap

var hamsters: Array = []

const cell_size: int = 24
const event_spacing: int = 8
const event_rand: int = 2
const plr_count: int = 2

var plrs: Array = []
var point_offsets: Array = []
var event_points: Array = []

var current_plr: int = 0

var can_roll_dice: bool = true
var can_move: bool = false

var rng = RandomNumberGenerator.new()

var auto_play: bool = false

func _list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(load(path + file))

	dir.list_dir_end()
	return files
func _pick_rand_int(min_int: int, max_int: int):
	rng.randomize()
	return rng.randi_range(min_int, max_int)
func _ready():
	var current_event_spacing = event_spacing
	
	for i in curve.get_point_count():
		var point_offset = curve.get_point_position(i)
		var tile = 0
		
		if current_event_spacing == 0:
			if _pick_rand_int(0, event_rand) == 0:
				current_event_spacing = event_spacing
				tile = 1
				
				event_points.append(i)
		else:
			current_event_spacing -= 1
		
		tilemap.set_cellv(tilemap.world_to_map(point_offset),  tile)
		point_offsets.append(point_offset)
	
	hamsters = _list_files_in_directory("res://scenes/characters/hamsters/")
	
	var hamster = 0
		
	for plr in plr_count:
		if hamster > hamsters.size() - 1:
			hamster = 0
		
		var obj = hamsters[hamster].instance()
		var obj_pos = point_offsets[0]
		
		add_child(obj)
		obj.position = obj_pos
		obj.connect("_on_move_completed", self, "_on_move_completed")
		plrs.append(obj)
		
		hamster += 1
		
	Gui.connect("queue_finished", self, "_on_anim_queue_finished")
	Gui.anim_plr.connect("animation_finished", self, "_on_anim_finished")
	Gui.card.connect("plr_response", self, "_plr_response")
	
	Gui.info_text.set_text("player " + String(current_plr + 1) + " turn", true)
func _on_click(play_anim, dist):
	can_move = false
	
	if play_anim:
		Gui.play_anim(Gui.anims.DICE_OUT)
		
	plrs[current_plr].move(point_offsets, dist)
func _process(_delta):
	if Input.is_action_just_released("ui_select"):
		auto_play = !auto_play
	if auto_play or Input.is_action_just_pressed("click"):
		if can_move:
			return _on_click(true, Gui.dice.sprite.frame + 1)
		elif can_roll_dice:
			can_roll_dice = false
			Gui.anim_queue = [
				Gui.anims.DICE_ROLL_IN,
				Gui.anims.DICE_ROLL_MID,
				Gui.anims.DICE_ROLL_OUT
			]
			
			Gui.play_all_anim_queue("DICE_ROLL")
			
func _on_move_completed(plr_point, event_tile: bool):
	if event_tile and plr_point in event_points:
		return Gui.gen_card()
	
	current_plr += 1
	
	if current_plr > plrs.size() - 1:
		current_plr = 0
	
	Gui.info_text.set_text("player " + String(current_plr + 1) + " turn", true)
	Gui.add_anim_queue(Gui.anims.DICE_IN)
	Gui.play_all_anim_queue("dice_in")
func _on_anim_queue_finished(run_name):
	if run_name == "DICE_ROLL":
		can_move = true
func _on_anim_finished(anim_name):
	if anim_name == "dice_in":
		can_roll_dice = true
func _plr_response(dist):
	print('plr responded ', dist)
	Gui.add_anim_queue(Gui.anims.CARD_SLIDE_OUT)
	Gui.play_all_anim_queue("card_slide_out")
	_on_click(false, dist)
