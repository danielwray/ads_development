#tool
extends TileMap

# variables
export var tile_id = 0 setget set_tile_id
var tile_range_x_min = -10
export var tile_range_x = 200 setget set_tile_range_x
export var tile_range_y = 10 setget set_tile_range_y

func _ready():
	update_foreground_tileset()

func update_foreground_tileset():
#	for x in range(tile_range_x_min, tile_range_x):
#		for y in range(0, 3):
#			set_cell(x, y, 1)
#	for x in range(tile_range_x_min, tile_range_x):
#		for y in range(4, 5):
#			set_cell(x, y, 5)
#	for x in range(tile_range_x_min, tile_range_x):
#		for y in range(6, 9):
#			set_cell(x, y, 0)
#	for x in range(tile_range_x_min, tile_range_x):
#		for y in range(10, 10):
#			set_cell(x, y, 6)
#	for x in range(tile_range_x_min, tile_range_x):
#		for y in range(11, 15):
#			set_cell(x, y, 1)
#	update()
	pass

func set_tile_id(id):
	tile_id = id
	update_foreground_tileset()

func set_tile_range_x(value):
	tile_range_x = value
	update_foreground_tileset()

func set_tile_range_y(value):
	tile_range_y = value
	update_foreground_tileset()
