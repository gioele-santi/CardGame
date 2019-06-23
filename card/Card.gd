extends Area2D 

class_name Card

signal card_turn
enum {HEARTS, DIAMONDS, CLUBS, SPADES}
#var position = Vector2() Do I need this? It is a detail external to card
var card_size = Vector2()
var card = Vector2() #x = seed, y = number
#19 is joker
var lut = [19, 43, 17, 32, 26, 20, 14, 8, 2, 55, 49, 37, 25, 31,  3, 57, 51, 45, 39, 33, 27, 21, 15, 9, 56, 44, 50,  22, 38, 11, 5, 58, 52, 46, 40, 34, 28, 16, 4, 10,  18, 13, 7, 1, 54, 48, 42, 36, 30, 24, 12, 0, 6] 

var face_up = false
var can_flip = true

# Called when the node enters the scene tree for the first time.
func _ready():
	card_size = $CollisionShape2D.shape.extents *2
	$FlipBF.interpolate_property($Back, 'scale', $Back.scale, Vector2($Back.scale.x, 0), 0.5, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)

func start(_card: Vector2, _up: bool) -> void:
	card = _card
	var frame_idx = card.x * 13 + card.y
	$Front.frame = lut[frame_idx]
	face_up = _up
	$Back.visible = false if face_up else true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func flip()-> void:
	#add Tween to simulate turning
	$FlipSound.play()
	$Back.visible = ! $Back.visible
	face_up = ! face_up

func _on_Card_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton && event.pressed && can_flip:
		flip()
		emit_signal("card_turn", self) #Do I need position? Probably to flip back in error case