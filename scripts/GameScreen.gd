extends Control

# Game loop variables
var isPlayerTurn: bool = false

var checkPoint: int = 0
var timerCount: int = 0

var buttonList: Array = []
var nextButton: TextureButton
var playerChoice: TextureButton

onready var timer: Timer = $Timer


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


# Sets up the buttons' signal connections
func initialize():
	$ButtonRing.blue.connect("button_up", self, "_on_blue_button_up")
	$ButtonRing.red.connect("button_up", self, "_on_red_button_up")
	$ButtonRing.yellow.connect("button_up", self, "_on_yellow_button_up")
	$ButtonRing.green.connect("button_up", self, "_on_green_button_up")


# Custom functions in alphabetical order
func checkInput():
	playerChoice = null
	
	if Input.is_action_just_pressed("ui_up") and !$ButtonRing.blue.pressed:
		playerChoice = $ButtonRing.blue
	elif Input.is_action_just_pressed("ui_down") and !$ButtonRing.yellow.pressed:
		playerChoice = $ButtonRing.yellow
	elif Input.is_action_just_pressed("ui_right") and !$ButtonRing.red.pressed:
		playerChoice = $ButtonRing.red
	elif Input.is_action_just_pressed("ui_left") and !$ButtonRing.green.pressed:
		playerChoice = $ButtonRing.green
	
	if checkPoint != buttonList.size():
		if playerChoice != null:
			compareChoices(playerChoice)
	else:
		isPlayerTurn = false
		checkPoint = 0


func compareChoices(choice):
	if(choice == buttonList[checkPoint]):
		checkPoint += 1
	else:
		get_tree().change_scene("res://scenes/TitleScreen.tscn")


# Generates a new color to guess
func getNextColor():
	randomize()
	var buttons: Array = $ButtonRing.get_children()
	var nextColor: int = randi() % buttons.size()
	nextButton = buttons[nextColor]
	buttonList.append(nextButton)
	isPlayerTurn = true
	timerCount = 0
	timer.start(1)


# Resets the game
func resetGame():
	buttonList.clear()
	checkPoint = 0
	isPlayerTurn = false


# Signal callbacks
func _on_blue_button_up():
	Input.action_press("ui_up")
func _on_red_button_up():
	Input.action_press("ui_right")
func _on_yellow_button_up():
	Input.action_press("ui_down")
func _on_green_button_up():
	Input.action_press("ui_left")


# Plays the button order, simulating delayed presses
func _on_Timer_timeout():
	if timerCount != buttonList.size():
		nextButton = buttonList[timerCount]
		nextButton.simulateRelease()
		nextButton.simulatePress()
		timerCount += 1
		timer.start(2)
