extends Control

var currentInput: String = ""

# Game loop variables
var isPlayerTurn: bool = false

var checkPoint: int = 0 # Which button is compared
var timerCount: int = 0

var colors: Array = []
var ring: Array = []

var buttonList: Array = []
var guessList: Array = []


# Called when the node enters the scene tree for the first time.
func _ready():
	ring = $Buttons.ring
	for btn in ring:
		colors.append(btn.name)
	_setButtons()
	_connectSignals()
	_getNextColor()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	if isPlayerTurn: #bool
		_checkInput()
		
	elif (!isPlayerTurn && checkPoint == guessList.size()):
		checkPoint = 0
		Utils.update()
		if "Rotate" in Utils.trials:
			_rotate() 
		
		# Get as many new buttons as counter
		for i in Utils.spiralCounter:
			_getNextColor()

# Sets up the buttons' signal connections
func _connectSignals():
#	var buttons: Array = $Buttons.all
	for btn in ring:
		var name = str(btn.name.to_lower())
		btn.connect("button_up", self, "_on_" + name + "_button_up")

# Custom functions in alphabetical order
func _checkInput():
	#var lastInput = currentInput
	var playerChoice: String = ""
	
	#TODO: This looks messy, keyboard presses
	if Input.is_action_just_pressed("ui_up"):
		$Buttons.press(colors[0])
	elif Input.is_action_just_pressed("ui_right"):
		$Buttons.press(colors[1])
	elif Input.is_action_just_pressed("ui_down"):
		$Buttons.press(colors[2])
	elif Input.is_action_just_pressed("ui_left"):
		$Buttons.press(colors[3])
	
	if Input.is_action_just_pressed("ui_cancel"):
		_resetGame() # not fully implemented yet
	
	#TODO: This is messy too, keyboard releases
	if Input.is_action_just_released("ui_up"):
		playerChoice = $Buttons.release(colors[0])
	elif Input.is_action_just_released("ui_right"):
		playerChoice = $Buttons.release(colors[1])
	elif Input.is_action_just_released("ui_down"):
		playerChoice = $Buttons.release(colors[2])
	elif Input.is_action_just_released("ui_left"):
		playerChoice = $Buttons.release(colors[3])
	print(playerChoice)
	# Compares player choices, only if no button is pressed
	if checkPoint < guessList.size():
		if playerChoice != "" and $Buttons.areAllReleased():
			_compareChoices(playerChoice)
	else:
		_togglePlayer()


func _compareChoices(choice: String):
	if(choice == guessList[checkPoint]):
		checkPoint += Utils.playDirection
	else:
		#TODO: Proper game over screen and transition
		get_tree().change_scene("res://scenes/Screens/Title.tscn")


# Generates a new color to guess
func _getNextColor():
	randomize()
	# Get next button for replay
	var next: String
	var color: int = randi() % ring.size()
	next = colors[color]
	# shown list
	buttonList.append(next)
	
	# Gets shifted button for guessing if needed
	next = colors[(color + Utils.mirrorShift) % colors.size()]
	
	# Get amount of presses of each button
	for i in Utils.doubleCounter:
		guessList.append(next)
	# Play the visible list
	$Buttons.playList(buttonList)


# Resets the game
func _resetGame():
	$Buttons.releaseAll()
	buttonList.clear()
	guessList.clear()
	checkPoint = 0
	isPlayerTurn = false

# Rotates the playfield and the button order
func _rotate():
	var direction: int = Utils.randomOne()
	# Make buttons react according to new positions
	if direction == 1: # clockwise / right rotation
		colors.push_front(colors.pop_back())
	else:
		colors.push_back(colors.pop_front())
	# Rotate the colors
	$Buttons.rotateButtons(direction)


# Sets texts and symbols of the buttons
func _setButtons():
	var symbols: Array = Utils.symbols[Utils.symbolset]
	var texts: Array = Utils.texts[Utils.textset]
	$Buttons.setSymbols(Utils.symbolset, symbols)
	$Buttons.setTexts(Utils.textset, texts)


# Signal callbacks, it's a mess...
func _on_blue_button_up():
	Input.action_release("ui_up")
func _on_red_button_up():
	Input.action_release("ui_right")
func _on_yellow_button_up():
	Input.action_release("ui_down")
func _on_green_button_up():
	Input.action_release("ui_left")


# Changes state of buttons and player turn
func _togglePlayer():
	isPlayerTurn = !isPlayerTurn
	if isPlayerTurn:
		$Buttons.toggleButtonsClickable(isPlayerTurn)


func _on_Buttons_animation_done():
	_togglePlayer()
