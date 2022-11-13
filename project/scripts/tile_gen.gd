extends TileMap
class_name InteractiveTileMap

export(Dictionary) var tile_scenes := {
	1: preload("res://scenes/tiles/event_tile.tscn")
}

onready var half_cell_size = (cell_size * 0.5) # * scale.x

var replaced: bool = false

func _ready():
	get_tree().connect("idle_frame", self, "_on_timeout")

func _on_timeout() -> void:
	if !replaced:
		_replace_tiles_with_scenes()
		replaced = true

func _replace_tiles_with_scenes(scene_dictionary: Dictionary = tile_scenes):
	for tile_pos in get_used_cells():
		var tile_id = get_cell(tile_pos.x, tile_pos.y)
		
		if scene_dictionary.has(tile_id):
			var object_scene = scene_dictionary[tile_id]
			_replace_tile_with_object(tile_pos, object_scene)
	
func _replace_tile_with_object(tile_pos: Vector2, object_scene: PackedScene, parent: Node = get_tree().current_scene):
	if get_cellv(tile_pos) != INVALID_CELL:
		set_cellv(tile_pos, -1)
		update_bitmask_region()
	if object_scene:
		var obj = object_scene.instance()
		var obj_pos = map_to_world(tile_pos) * scale.x + half_cell_size
		
		add_child(obj)
		obj.global_position = obj_pos
#		obj.get_parent().move_child(obj, 3)
