extends CanvasLayer

export(Resource) var cards_res

onready var event_text: RichTextLabel = $Control/TextureRect/EventText
onready var response_text_1: RichTextLabel = $Control/TextureRect/ResponseButton1/ResponseText1
onready var response_text_2: RichTextLabel = $Control/TextureRect/ResponseButton2/ResponseText2

onready var cards: Array = cards_res.event_cards

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var chosen_card: Dictionary

var responses_enabled: bool = false

signal plr_response(dist)

func _ready():
	print(cards)

func _pick_rand_int(min_int: int, max_int: int):
	rng.randomize()
	return rng.randi_range(min_int, max_int)
func _shuffle_cards(list: Array):
	randomize()
	list.shuffle()
func _pick_rand_card():
	randomize()
	return cards[_pick_rand_int(0, cards.size() - 1)]
func gen_card():
	if !cards:
		return
	
	_shuffle_cards(cards)
	
	chosen_card = _pick_rand_card()
	event_text.text = chosen_card["event_msg"]
	
	_shuffle_cards(chosen_card["responses"])
	
	response_text_1.text = chosen_card["responses"][0][0]
	response_text_2.text = chosen_card["responses"][1][0]
	
	responses_enabled = true
	
func _on_ResponseButton1_pressed():
	if responses_enabled:
		print('first respond btn ', chosen_card["responses"][0][1])
		emit_signal("plr_response", chosen_card["responses"][0][1])
		responses_enabled = false
func _on_ResponseButton2_pressed():
	if responses_enabled:
		print('second respond btn ', chosen_card["responses"][1][1])
		emit_signal("plr_response", chosen_card["responses"][1][1])
		responses_enabled = false
