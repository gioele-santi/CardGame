extends CanvasLayer

var playerLbl = []

func _ready():
	playerLbl = [$HBoxContainer/P1/Label, $HBoxContainer/P2/Label, $HBoxContainer/P3/Label, $HBoxContainer/P4/Label]
	reset()
	pass

func reset():
	for i in range(4):
		var container: MarginContainer = $HBoxContainer.get_child(i)
		container.visible = false
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func player_position(player: int) -> Vector2:
	var container: MarginContainer = $HBoxContainer.get_child(player)
	return container.rect_global_position + container.rect_size/2
	#return Vector2()


func select_player(player_number: int):
	#it does not stay fixed
	for i in range(4):
		$HBoxContainer.get_child(i).margin_top = -15 if i == player_number else 0

func update_score(player: int, score: int):
	playerLbl[player].text = "P%d: %05d" % [player+1, score]

func set_player_number(count: int):
	var player_count = int(clamp(count, 1, 4))
	for i in range(player_count):
		$HBoxContainer.get_child(i).visible = true