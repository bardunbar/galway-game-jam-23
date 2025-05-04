extends TextureButton
class_name TileButton

@onready var highlight_tex:TextureRect = $TextureRect

var cur_highlighted = false
var tile_type:TileGlobals.TILE_TYPE = TileGlobals.TILE_TYPE.GROUND

signal on_tile_button_highlighted(button:TileButton)

func set_type(new_type:TileGlobals.TILE_TYPE):
	tile_type = new_type
	texture_normal = TileGlobals.tile_defintions.texture_map[tile_type]
	
func set_highlighted(is_highlighted):
	cur_highlighted = is_highlighted
	highlight_tex.visible = is_highlighted

func _on_pressed() -> void:
	if not cur_highlighted:
		set_highlighted(true)
		on_tile_button_highlighted.emit(self)
