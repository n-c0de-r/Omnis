extends Control

# Game loop variables
var isPlayerTurn: bool = false

var checkPoint: int = 0 # Which button is compared
var timerCount: int = 0

var buttonList: Array = []
var guessList: Array = []


# Called when the node enters the scene tree for the first time.
func _ready():
	_setTexts($ButtonRing.get_rotation() / 90)
	_togglePlayer(isPlayerTurn)
	_connectSignals()
	_getNextColor()
	$Timer.start(2 * Numbers.timerFactor)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	if isPlayerTurn: #bool
		_checkInput()
		
	elif (!isPlayerTurn && checkPoint == guessList.size()):
		checkPoint = 0
		# Get as many new buttons as counter
		for i in Numbers.spiralCounter:
			_getNextColor()
		_rotateButtons()

# Sets up the buttons' signal connections
func _connectSignals():
	var buttons: Array = $ButtonRing.get_children()
	for btn in buttons:
		var name = str(btn.name.to_lower().split("_")[1])
		btn.connect("button_up", self, "_on_" + name + "_button_up")


# Custom functions in alphabetical order
func _checkInput():
	var playerChoice: TextureButton
	
	#TODO: This looks messy, keyboard presses
	if Input.is_action_just_pressed("ui_up"):
		$ButtonRing.blue.simulatePress()
	elif Input.is_action_just_pressed("ui_down"):
		$ButtonRing.yellow.simulatePress()
	elif Input.is_action_just_pressed("ui_right"):
		$ButtonRing.red.simulatePress()
	elif Input.is_action_just_pressed("ui_left"):
		$ButtonRing.green.simulatePress()
	
	if Input.is_action_just_pressed("ui_cancel"):
		resetGame() # not fully implemented yet
	
	#TODO: This is messy too, keyboard releases
	if Input.is_action_just_released("ui_up"):
		playerChoice = $ButtonRing.blue.simulateRelease()
	elif Input.is_action_just_released("ui_down"):
		playerChoice = $ButtonRing.yellow.simulateRelease()
	elif Input.is_action_just_released("ui_right"):
		playerChoice = $ButtonRing.red.simulateRelease()
	elif Input.is_action_just_released("ui_left"):
		playerChoice = $ButtonRing.green.simulateRelease()
	
	# Compares player choices, only if no button is pressed
	if checkPoint < guessList.size():
		if playerChoice != null and $ButtonRing.areAllReleased():
			_compareChoices(playerChoice)
	else:
		_togglePlayer(!isPlayerTurn)


func _compareChoices(choice: TextureButton):
	if(choice == guessList[checkPoint]):
		checkPoint += Numbers.playDirection
	else:
		#TODO: Proper game over screen and transition
		get_tree().change_scene("res://scenes/Screens/Title.tscn")


# Generates a new color to guess
func _getNextColor():
	randomize()
	# Get next button for replay
	var next: TextureButton
	var buttons: Array = $ButtonRing.get_children()
	var color: int = randi() % buttons.size()
	next = buttons[color]
	buttonList.append(next)
	
	# Gets shifted button for guessing
	next = buttons[(color + Numbers.mirrorShift)% buttons.size()]
	
	# Get amount of presses of each button
	for i in Numbers.doubleCounter:
		guessList.append(next)
	
	# Delay before next order plays
	timerCount = 0
	$Timer.start(1 * Numbers.timerFactor)


# Plays the animation of a simulated button press
func _playButtonPress():
	var button: TextureButton
	button = buttonList[timerCount]
	$ButtonRing.releaseAll() # just in case
	button.simulatePress()
	button.startTimer(1 * Numbers.timerFactor)
	timerCount += 1


# Resets the game
func resetGame():
	$ButtonRing.releaseAll()
	buttonList.clear()
	guessList.clear()
	checkPoint = 0
	isPlayerTurn = false


# Signal callbacks, it's a mess...
func _on_blue_button_up():
	Input.action_release("ui_up")
func _on_red_button_up():
	Input.action_release("ui_right")
func _on_yellow_button_up():
	Input.action_release("ui_down")
func _on_green_button_up():
	Input.action_release("ui_left")


# Delays the next press animation
func _on_Timer_timeout():
	if timerCount < buttonList.size():
		_playButtonPress()
		# 1s light up + 1s till next = 2s
		$Timer.start(2 * Numbers.timerFactor)
	else:
		_togglePlayer(!isPlayerTurn)


func _rotateButtons():
	# TODO: Make animations programatically
#	var animPlayer: AnimationPlayer = AnimationPlayer.new()
#	var animation: Animation = Animation.new()
#	$ButtonRing.add_child(animPlayer)
#	animPlayer.add_animation("RotateClockwise", animation)
#	animation.add_track(Animation.TYPE_VALUE)
#	animation.track_insert_key(0, 0.0, $ButtonRing.get_rotation())
#	animation.track_insert_key(0, 1.0, $ButtonRing.get_rotation()+90)
#	animPlayer.play("RotateClockwise")
#	$ButtonRing.remove_child(animPlayer)
	pass


func _setTexts(shift: int):
	var size: int = $ButtonRing.get_children().size()
	var colors: Array = ["Blue", "Red", "Yellow", "Green"]
	for i in size:
		var label: Label = $TextRing.get_child((i+shift) % size)
		label.text = colors[i]

# Changes state of buttons and player turn
func _togglePlayer(flag: bool):
	isPlayerTurn = flag
	
	# Visualize player turn
	$TxtBtn_Center.set_pressed_no_signal(flag)
	
	# Update info texts
	if flag:
		$TextRing/CENTER.text = "Your\nTurn"
	else:
		$TextRing/CENTER.text = "Com\nTurn"
		
	# Set buttons clickable or not
	$ButtonRing.toggleButtonsKlickable(flag)
