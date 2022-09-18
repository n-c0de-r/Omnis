extends Control

# Game loop variables
var isPlayerTurn: bool = false

var checkPoint: int = 0
var timerCount: int = 0

var buttonList: Array = []

#onready var timer: Timer = $Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	initialize()
	getNextColor()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	if isPlayerTurn: #bool
		checkInput()
	else:
		getNextColor()
	
#	if Input.is_action_just_pressed("ui_accept"):
#		resetGame() # not fully implemented yet


# Sets up the buttons' signal connections, messy solution
func initialize():
	$ButtonRing.blue.connect("button_up", self, "_on_blue_button_up")
	$ButtonRing.red.connect("button_up", self, "_on_red_button_up")
	$ButtonRing.yellow.connect("button_up", self, "_on_yellow_button_up")
	$ButtonRing.green.connect("button_up", self, "_on_green_button_up")


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
	
	#TODO: This is messy too
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


func compareChoices(choice):
	if(choice == buttonList[checkPoint]):
		checkPoint += 1
	else:
		#TODO: Proper game over screen and transition
		get_tree().change_scene("res://scenes/TitleScreen.tscn")


# Generates a new color to guess
func getNextColor():
	var buttons: Array = $ButtonRing.get_children()
	var color: int = randi() % buttons.size()
	var next: TextureButton
	
	randomize()
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
	# 1s light up, 1s till next
	$Timer.start(2)
