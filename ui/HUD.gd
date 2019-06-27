extends CanvasLayer

var playerLbl = []
var playerBox = []

func _ready():
	playerLbl = [$HBoxContainer/P1/Label, $HBoxContainer/P2/Label, $HBoxContainer/P3/Label, $HBoxContainer/P4/Label]
	playerBox = [$HBoxContainer/P1/TextureRect, $HBoxContainer/P2/TextureRect, $HBoxContainer/P3/TextureRect, $HBoxContainer/P4/TextureRect]
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
		var alpha = 1 if i == player_number else 0.25
		playerBox[i].modulate = Color(1,1,1,alpha)

func update_score(player: int, score: int):
	playerLbl[player].text = "P%d: %05d" % [player+1, score]


func set_player_number(count: int):
	var player_count = int(clamp(count, 1, 4))
	for i in range(player_count):
		$HBoxContainer.get_child(i).visible = true

func game_over_panel(winner: int, score: int):
	$ConfirmationDialog.window_title = "Game Over"
	if winner > 0:
		$ConfirmationDialog.dialog_text = "Player %d wins with %d points.\n Play again?" % [winner, score]
	$ConfirmationDialog.popup_centered()

func _on_ConfirmationDialog_confirmed():
	get_tree().change_scene("res://main/Main.tscn")


func _on_ConfirmationDialog_popup_hide():
	#cancel
	get_tree().change_scene("res://ui/Start.tscn")
