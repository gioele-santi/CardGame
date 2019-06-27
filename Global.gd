extends Node

var player_count = 1
var card_count = 16 setget card_count_change
var rows = 2
var cols = 8

var scale = 0.6 #scale for the cards
var top_left = Vector2(80, 85) #first position offset
var offset = Vector2(200*scale, 420*scale)
#space from center to center of cards

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func card_count_change(new_value: int):
	card_count = new_value
	match new_value:
		16:
			rows = 2
			cols = 8
			offset = Vector2(200*scale, 420*scale)
		20:
			rows = 4
			cols = 5
			offset = Vector2(330*scale, 210*scale)
		24:
			rows = 3
			cols = 8
			offset = Vector2(200*scale, 315*scale)
		28:
			rows = 4
			cols = 7
			offset = Vector2(220*scale, 210*scale)
		32:
			rows = 4
			cols = 8
			offset = Vector2(200*scale, 210*scale)
		36:
			rows = 4
			cols = 9
			offset = Vector2(180*scale, 210*scale)
		40:
			rows = 4
			cols = 10
			offset = Vector2(160*scale, 210*scale)

func card_count_get():
	return card_count