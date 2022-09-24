extends Control

# Game loop variables
var isPlayerTurn: bool = false

var checkPoint: int = 0
var playDirection: int = 1 # 1 forward, -1 reverse
var timerCount: int = 0

var buttonList: Array = []


# Called when the node enters the scene tree for the first time.
func _ready():
	#updateDirection("TODO") # maybe this?
	# Maybe move into initialize?
	if Settings.mode == Settings.modes.NORMAL:
		playDirection = 1 # forward
	if Settings.mode == Settings.modes.REVERSE:
		playDirection = -1 #reverse
	initialize()
	getNextColor()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$ButtonRing.toggleButtonsKlickable(isPlayerTurn)
	
	if isPlayerTurn: #bool
		checkInput()
	else:
		#Change direction every turn if needed
		if Settings.mode == Settings.modes.FLIP:
			playDirection *= -1 #change every turn
		if Settings.mode == Settings.modes.RANDOM:
		#Generates a -1 or +1 only
			playDirection *= (randi()%2) * 2 - 1 #random
		getNextColor()


# Sets up the buttons' signal connections
func initialize():
	var buttons: Array = $ButtonRing.get_children()
	for btn in buttons:
		var name = str(btn.name.to_lower().split("_")[1])
		btn.connect("button_up", self, "_on_" + name + "_button_up")


# Custom functions in alphabetical order
func checkInput():
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
	
#	if Input.is_action_just_pressed("ui_accept"):
#		resetGame() # not fully implemented yet
	
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
	if checkPoint != buttonList.size():
		if playerChoice != null and $ButtonRing.areAllReleased():
			compareChoices(playerChoice)
	else:
		isPlayerTurn = false
		checkPoint = 0


func compareChoices(choice: TextureButton):
	if(choice == buttonList[checkPoint]):
		checkPoint += playDirection
	else:
		#TODO: Proper game over screen and transition
		get_tree().change_scene("res://scenes/Screens/Title.tscn")


# Generates a new color to guess
func getNextColor():
	randomize()
	var next: TextureButton
	var buttons: Array = $ButtonRing.get_children()
	var color: int = randi() % buttons.size()
	next = buttons[color]
	buttonList.append(next)
	isPlayerTurn = true
	# Delay before next order plays
	timerCount = 0
	$Timer.start(1)


# Plays the animation of a simulated button press
func playButtonPress():
	var button: TextureButton
	if timerCount != buttonList.size():
		button = buttonList[timerCount]
		$ButtonRing.releaseAll() # just in case
		button.simulatePress()
		button.startTimer(1)
		timerCount += 1

# Resets the game
func resetGame():
	$ButtonRing.releaseAll()
	buttonList.clear()
	checkPoint = 0
	isPlayerTurn = false


# Function to change check order
# Not all are needed every turn, probably obsolete
#func updateDirection(choice):
	#if choice == Settings.Modes.NORMAL:
		#playDirection = 1 # forward
	#if choice == Settings.Modes.REVERSE:
		#playDirection = -1 #reverse
	#if choice == Settings.Modes.FLIP:
		#playDirection *= -1 #change every turn
	#if choice == Settings.Modes.CHAOS:
		#Generates a -1 or +1 only
		#playDirection *= randi(1) * 2 -1 #random


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
	playButtonPress()
	# 1s light up + 1s till next = 2s
	$Timer.start(2)
