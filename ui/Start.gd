extends CanvasLayer

onready var player_lbl = $ControlContainer/VBoxContainer/MarginContainer2/Label
onready var player_slider = $ControlContainer/VBoxContainer/MarginContainer5/HSlider
onready var card_lbl = $ControlContainer/VBoxContainer/MarginContainer4/CardLbl
onready var card_slider = $ControlContainer/VBoxContainer/MarginContainer3/CardSlider

# Called when the node enters the scene tree for the first time.
func _ready():
	var player_format_string = "%d player" if Global.player_count == 1 else "%d players"
	player_lbl.text = player_format_string % Global.player_count
	player_slider.value = Global.player_count
	
	var card_format_string = "%d cards"
	card_lbl.text = card_format_string % Global.card_count
	card_slider.value = Global.card_count

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_NewGame_pressed():
	get_tree().change_scene("res://main/Main.tscn")


func _on_HSlider_value_changed(value):
	var player_format_string = "%d player" if value == 1 else "%d players"
	player_lbl.text = player_format_string % int(value)
	Global.player_count = int(value)


func _on_CardSlider_value_changed(value):
	Global.card_count = int(value)
	var card_format_string = "%d cards"
	card_lbl.text = card_format_string % Global.card_count
	
