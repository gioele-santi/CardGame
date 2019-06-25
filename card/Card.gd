extends Area2D 

class_name Card

signal card_turn_up
signal card_turn_down

enum {HEARTS, DIAMONDS, CLUBS, SPADES}
var card = Vector2() #x = seed, y = number
#19 is joker
var lut = [19, 43, 17, 32, 26, 20, 14, 8, 2, 55, 49, 37, 25, 31,  3, 57, 51, 45, 39, 33, 27, 21, 15, 9, 56, 44, 50,  22, 38, 11, 5, 58, 52, 46, 40, 34, 28, 16, 4, 10,  18, 13, 7, 1, 54, 48, 42, 36, 30, 24, 12, 0, 6] 

var face_up = false
var can_flip = true
var tween_speed = 0.3 # turn is 0.6 seconds as it is split in two

# Called when the node enters the scene tree for the first time.
func _ready():
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
	var upface: Sprite = $Front if face_up else $Back
	$Flip/Begin.interpolate_property(upface, 'scale', Vector2(1, 1), Vector2(0, 1), tween_speed, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Flip/Begin.start()

func _on_Flip_Begin_tween_completed(object, key):
	print("Flip Begin - Object: ", object, " - Key: ", key)
	$Flip/Sound.play()
	var upface: Sprite = $Front if face_up else $Back
	var downface: Sprite = $Front if !face_up else $Back
	upface.visible = !upface.visible
	downface.visible = !downface.visible
	upface.scale = Vector2(1,1) #keep scale got from previous tween
	downface.scale = Vector2(0,1) #as previous line
	$Flip/End.interpolate_property(downface, 'scale', Vector2(0,1), Vector2(1, 1), tween_speed, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Flip/End.start()
	face_up = ! face_up #finally invert orientation

func _on_Flip_End_tween_completed(object, key):
	print("Flip End - Object: ", object, " - Key: ", key)
	can_flip = true #enable again flipping
	if face_up:
		emit_signal("card_turn_up", self)
	else:
		emit_signal("card_turn_down", self)