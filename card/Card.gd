extends Area2D 

class_name Card

signal card_turn_up
signal card_turn_down

enum {HEARTS, DIAMONDS, CLUBS, SPADES}
#var card_size = Vector2()
var card = Vector2() #x = seed, y = number
#19 is joker
var lut = [19, 43, 17, 32, 26, 20, 14, 8, 2, 55, 49, 37, 25, 31,  3, 57, 51, 45, 39, 33, 27, 21, 15, 9, 56, 44, 50,  22, 38, 11, 5, 58, 52, 46, 40, 34, 28, 16, 4, 10,  18, 13, 7, 1, 54, 48, 42, 36, 30, 24, 12, 0, 6] 

var face_up = false
var can_flip = true
var tween_speed = 0.3

# Called when the node enters the scene tree for the first time.
func _ready():
	#card_size = $CollisionShape2D.shape.extents *2
	#start(Vector2(), true) #only for test animation in scene alone
	pass

func start(_card: Vector2, _up: bool) -> void:
	card = _card
	var frame_idx = card.x * 13 + card.y
	$Front.frame = lut[frame_idx]
	face_up = _up
	if face_up:
		$Back.scale = Vector2(0,1)
		$Front.scale = Vector2(1,1)
	else:
		$Back.scale = Vector2(1,1)
		$Front.scale = Vector2(0,1)
	$Back.visible = !face_up
	$Front.visible = face_up

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Card_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton && event.pressed && can_flip:
		flip()

func flip()-> void:
	can_flip = false # block flipping while animating 
	if face_up:
		$Flip/FrontBack1.interpolate_property($Front, 'scale', Vector2(1, 1), Vector2(0, 1), tween_speed, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		$Flip/FrontBack1.start()
	else:
		$Flip/BackFront1.interpolate_property($Back, 'scale', Vector2(1, 1), Vector2(0, 1), tween_speed, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		$Flip/BackFront1.start()

func _flip_half_tween_completed(object, key):
	$Back.visible = ! $Back.visible
	$Front.visible = ! $Front.visible
	if face_up:
		$Front.scale = Vector2(1,1)
		$Back.scale = Vector2(0,1)
		$Flip/FrontBack2.interpolate_property($Back, 'scale', Vector2(0,1), Vector2(1, 1), tween_speed, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		$Flip/FrontBack2.start()
	else:
		$Front.scale = Vector2(0,1)
		$Back.scale = Vector2(1,1)
		$Flip/BackFront2.interpolate_property($Front, 'scale', Vector2(0,1), Vector2(1, 1), tween_speed, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		$Flip/BackFront2.start()
	face_up = ! face_up #finally invert orientation

func _flip_tween_completed(object, key):
	$Flip/Sound.play()
	can_flip = true #enable again flipping
	if face_up:
		emit_signal("card_turn_up", self)
	else:
		emit_signal("card_turn_down", self)