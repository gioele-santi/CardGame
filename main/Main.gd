extends Node

export (PackedScene) var Card

#I want to add a style to associate other meanings to card, so provide a fixed couple

#cards disposition
var scale = 0.6
var offset = Vector2(160*scale, 210*scale) #help with position, then calculate dinamically
var screen_size
var rows = 4
var cols = 10
var cards = rows * cols

#game 'state' check
var first_card: Card
var second_card: Card

func _ready():
	randomize() #set random seed for this session
	screen_size = get_viewport().get_visible_rect().size
	start_new_game()

func start_new_game():
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

func place_card(type: Vector2, pos: int):
	var c = Card.instance()
	c.start(type, false)
	$Cards.add_child(c)
	c.connect('card_turn_up', self, 'turned_up_card')
	c.connect('card_turn_down', self, 'turned_down_card')
	var row = int(pos / cols)
	var col = pos % cols
	c.scale = Vector2(scale, scale)
	c.position = Vector2(offset.x*col+80, offset.y*row+105)

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
	first_card = null
	second_card = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_FlipTimer_timeout():
	first_card.flip()
	second_card.flip()
	first_card = null
	second_card = null
	for c in $Cards.get_children():
			c.can_flip = true

func _on_MatchTimer_timeout():
	#TODO: add score mgmt
	first_card.queue_free()
	second_card.queue_free()
	first_card = null
	second_card = null
	for c in $Cards.get_children():
			c.can_flip = true
