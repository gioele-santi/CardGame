extends Node

export (PackedScene) var Card

#I want to add a style to associate other meanings to card, so provide a fixed couple

#cards disposition
var scale = 0.6 #scale for the cards
var top_left = Vector2(80, 85) #first position offset
var offset = Vector2(160*scale, 210*scale) #space from center to center of cards
var rows = 3 #4
var cols = 4#10 #keep space for interface
var cards = rows * cols

#game 'state' check
var playing = false
var current_player = 0
export (int) var player_count = 2
var combo_count = 1
var player_score = []
var first_card: Card
var second_card: Card

func _ready():
	randomize() #set random seed for this session
	start_new_game()

func _process(delta):
	if $Cards.get_children().size() == 0 && playing:
		playing = false 
		var max_score = 0
		var winner = -1
		for i in range(player_count):
			if player_score[i] > max_score:
				max_score = player_score[i]
				winner = i
		print("Game over: Player %d wins with %d points." % [winner+1, max_score])
		#go back to main screen, check points, save record....

func start_new_game():
	# card shuffle
	var available_pos = range(cards)
	var usedCards = []
	#must also divide positions in rows according to total number
	while available_pos.size() > 0: #probably it will generate an error as it will be modified
		#choose card type
		var ctype = Vector2(randi() % 4, randi()%13)
		#avoid repeating couples
		while usedCards.count(ctype) != 0:
			ctype = Vector2(randi() % 4, randi()%13)
		usedCards.append(ctype) #check for repetition
		
		for i in range(2): #make ctype Vector3 and use z to choose coupled card (same for poker cards)
			var idx = randi() % available_pos.size()
			var pos = available_pos[idx]
			place_card(ctype, pos)
			available_pos.remove(idx)
	
	#set up player(s)
	$HUD.set_player_number(player_count)
	$HUD.select_player(current_player)
	for i in range(player_count):
		player_score.append(0)
	playing = true

func place_card(type: Vector2, pos: int):
	var c = Card.instance()
	c.start(type, false)
	$Cards.add_child(c)
	c.connect('card_turn_up', self, 'turned_up_card')
	c.connect('card_turn_down', self, 'turned_down_card')
	var row = int(pos / cols)
	var col = pos % cols
	c.scale = Vector2(scale, scale)
	c.position = Vector2(offset.x*col+top_left.x, offset.y*row+top_left.y) 

func turned_up_card(card: Card):
	if first_card != null:
		second_card = card
		#block flipping to avoid errors
		for c in $Cards.get_children():
			c.can_flip = false
		if card.card == first_card.card:
			$MatchTimer.start()
		else:
			$FlipTimer.start()
	else:
		first_card = card

func turned_down_card(card: Card):
	reset()

func reset():
	first_card = null
	second_card = null
	for c in $Cards.get_children():
		c.can_flip = true

func _on_FlipTimer_timeout():
	first_card.flip()
	second_card.flip()
	combo_count = 1 #reset value
	current_player = (current_player +1) % player_count
	$HUD.select_player(current_player)
	reset()

func _on_MatchTimer_timeout():
	#TODO: add score mgmt
	$Move1.interpolate_property(first_card, 'position', first_card.position, $HUD.player_position(current_player), 0.8, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Move2.interpolate_property(second_card, 'position', second_card.position, $HUD.player_position(current_player), 0.9, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Move1.start()
	$Move2.start()
	#move this part to tween complete (problem, they are two)
	yield($Move1, "tween_completed")
	yield($Move2, "tween_completed")
	first_card.queue_free()
	second_card.queue_free()
	player_score[current_player] += 5 * combo_count
	combo_count += 1 #add combo mgmt
	$HUD.update_score(current_player, player_score[current_player])
	reset()
