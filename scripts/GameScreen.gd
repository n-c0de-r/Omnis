extends Control

# Constants to use
enum btnNames {NONE, BLUE, RED, YELLOW, GREEN}
# Old attempt in animation with self modulation, might need again or delete later!
#const fullCols: Array = [Color.transparent, Color.blue, Color.red, Color.yellow, Color.green]
#const halfCols: Array = [Color.transparent, Color.darkblue, Color.darkred, Color.darkgoldenrod, Color.darkgreen]

# Game loop variables
var checkPoint: int = 0
var playerChoice: int = 0
var isGameOver: bool = false
var isPlayerTurn: bool = false

var moveList: Array = [1, 2, 4]
var nextButton: TextureButton

onready var timer1: Timer = $Timer
onready var timer2: Timer = $Timer2

# Called when the node enters the scene tree for the first time.
func _ready():
	getNextColor()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(!isGameOver): #bool
		if(isPlayerTurn): #bool
			checkInput()
		else:
			getNextColor()
	else:
		if(Input.is_action_just_pressed("ui_accept")):
			resetGame() # not implemented yet


# Custom functions in alphabetical order
func checkInput():
	playerChoice = 0
	
	if Input.is_action_just_pressed("ui_up") and !$TxtBtn_BLUE.pressed:
		playerChoice = btnNames.BLUE
		#compareChoices(ButtonColors.BLUE)
	elif Input.is_action_just_pressed("ui_down") and !$TxtBtn_YELLOW.pressed:
		playerChoice = btnNames.YELLOW
		#compareChoices(ButtonColors.YELLOW)
	elif Input.is_action_just_pressed("ui_right") and !$TxtBtn_RED.pressed:
		playerChoice = btnNames.RED
		#compareChoices(ButtonColors.RED)
	elif Input.is_action_just_pressed("ui_left") and !$TxtBtn_GREEN.pressed:
		playerChoice = btnNames.GREEN
		#compareChoices(ButtonColors.GREEN)
		
	if(checkPoint != moveList.size()):
		if (playerChoice != 0):
			compareChoices(playerChoice)
	else:
		isPlayerTurn = false
		checkPoint = 0
		



func compareChoices(choice):
	if(choice == moveList[checkPoint]):
		checkPoint += 1
	else:
		print("Wrong move. Game Over!")
		isGameOver = true
		get_tree().change_scene("res://scenes/TitleScreen.tscn")


# Generates a new color to guess
func getNextColor():
	randomize()
	var nextColor: int = (randi() % (btnNames.size()-1)+1)
	#moveList.append(nextColor)
	playList()


# Play the guess list visually to the player
func playList():
	var s: String
	# Just for gebugging to see the current order
	var list: String = "Round " + str(moveList.size()) + ":"
	
	for c in moveList:
		# Gets the next button in order to simulate
		s = btnNames.keys()[c]
		nextButton = get_node("TxtBtn_%s" % s)
		timer1.start(1)
		
		# debugging, delete later
		list += " " + s
	# debugging, delete later
	print(list)
	
	isPlayerTurn = !isPlayerTurn


# Resets the game
func resetGame():
	moveList.clear()
	checkPoint = 0
	isPlayerTurn = false


# Simulate mouse down on the button by changing
# it's state. Texture takes care of the visuals
func simulatePress(btn: TextureButton):
	# Simulates a button press visually to the player
	btn.set_toggle_mode(true)
	btn.set_pressed_no_signal(true)
	timer2.start(2)


# Simulate mouse down on the button by changing
# it's state. Texture takes care of the visuals
func simulateRelease(btn: TextureButton):
	# Simulate mouse released on the button just visually
	btn.set_pressed_no_signal(false)
	btn.set_toggle_mode(false)


# Signal callbacks
func _on_TxtBtn_BLUE_button_up():
	Input.action_press("ui_up")

func _on_TxtBtn_RED_button_up():
	Input.action_press("ui_right")

func _on_TxtBtn_YELLOW_button_up():
	Input.action_press("ui_down")

func _on_TxtBtn_GREEN_button_up():
	Input.action_press("ui_left")

func _on_Timer_timeout():
	simulatePress(nextButton)

func _on_Timer2_timeout():
	simulateRelease(nextButton)
