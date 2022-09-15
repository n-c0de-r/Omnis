extends Control

# Constants to use
enum btnNames {NONE, BLUE, RED, YELLOW, GREEN}

# Game loop variables
var isPlayerTurn: bool = false

var checkPoint: int = 0
var deltaTime: float = 0

var moveList: Array = []
var buttonList: Array = []
var nextButton: TextureButton
var playerChoice: TextureButton


# Called when the node enters the scene tree for the first time.
func _ready():
	getNextColor()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	deltaTime += _delta
	
	if isPlayerTurn: #bool
		checkInput()
	else:
		getNextColor()
	
	if Input.is_action_just_pressed("ui_accept"):
		resetGame() # not fully implemented yet


# Custom functions in alphabetical order
func checkInput():
	playerChoice = null
	
	if Input.is_action_just_pressed("ui_up") and !$TxtBtn_BLUE.pressed:
		playerChoice = $TxtBtn_BLUE
	elif Input.is_action_just_pressed("ui_down") and !$TxtBtn_YELLOW.pressed:
		playerChoice = $TxtBtn_YELLOW
	elif Input.is_action_just_pressed("ui_right") and !$TxtBtn_RED.pressed:
		playerChoice = $TxtBtn_RED
	elif Input.is_action_just_pressed("ui_left") and !$TxtBtn_GREEN.pressed:
		playerChoice = $TxtBtn_GREEN
		
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
		print("Wrong move. Game Over!")
		get_tree().change_scene("res://scenes/TitleScreen.tscn")


# Generates a new color to guess
func getNextColor():
	randomize()
	var nextColor: int = randi() % (btnNames.size()-1)+1
	var s: String = btnNames.keys()[nextColor]
	nextButton = get_node("TxtBtn_%s" % s)
	buttonList.append(nextButton)
	playList()


# Play the guess list visually to the player
func playList():
	var s: String
	
	# Just for debugging to see the current order
	var list: String = "Round " + str(buttonList.size()) + ":"
	
	for btn in buttonList:
		# debugging, delete later
		s = str(btn.name).split("_")[1]
		simulatePress(btn) #real code
		
		# debugging, delete later
		list += " " + s
	# debugging, delete later
	print(list)
	
	isPlayerTurn = !isPlayerTurn


# Resets the game
func resetGame():
	buttonList.clear()
	checkPoint = 0
	isPlayerTurn = false


# Simulate mouse down on the button by changing
# it's state. Texture takes care of the visuals
func simulatePress(btn: TextureButton):
	var start: int = deltaTime
	#TODO: timing and delays should go here but
	# I can't figure it out, and give up for now
	
	# Simulates a button press visually to the player
	if !btn.pressed:
		btn.set_toggle_mode(!btn.pressed)
		btn.set_pressed_no_signal(!btn.pressed)
	else:
		btn.set_pressed_no_signal(!btn.pressed)
		btn.set_toggle_mode(!btn.pressed)


# Signal callbacks
func _on_TxtBtn_BLUE_button_up():
	Input.action_press("ui_up")

func _on_TxtBtn_RED_button_up():
	Input.action_press("ui_right")

func _on_TxtBtn_YELLOW_button_up():
	Input.action_press("ui_down")

func _on_TxtBtn_GREEN_button_up():
	Input.action_press("ui_left")
