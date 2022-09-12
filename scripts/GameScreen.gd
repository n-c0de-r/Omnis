extends Control

# Constants to use
enum btnNames {NONE, BLUE, RED, YELLOW, GREEN}
const fullCols: Array = [Color.transparent, Color.blue, Color.red, Color.yellow, Color.green]
const halfCols: Array = [Color.transparent, Color.darkblue, Color.darkred, Color.darkgoldenrod, Color.darkgreen]

# Game loop variables
var moveList: Array = []
var isGameOver: bool = false
var isPlayerTurn: bool = false
var playerChoice: int = 0
var checkPoint: int = 0

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
			resetGame()


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


# Generates a new color to guess
func getNextColor():
	randomize()
	var nextColor: int = (randi() % (btnNames.size()-1)+1)
	moveList.append(nextColor)
	playList()


# Play the guess list visually to the player
func playList():
	var s: String
	var list: String = "Round " + str(moveList.size()) + ":"
	
	for c in moveList:
		s = btnNames.keys()[c]
		simulatePress(c, s)
		list += " " + s
		
	print(list)
	
	isPlayerTurn = !isPlayerTurn


# Resets the game
func resetGame():
	moveList.clear()
	checkPoint = 0
	isPlayerTurn = false


# Simulates a button press visually to the player
func simulatePress(c: int, s: String):
	var b: bool = true
	var btn: TextureButton
	
	btn = get_node("TxtBtn_%s" % s)
	btn.set_toggle_mode(b)
	btn.set_pressed_no_signal(b)
	yield(get_tree().create_timer(1.0), "timeout")
	btn.set_pressed_no_signal(!b)
	btn.set_toggle_mode(!b)



# Signal callbacks
func _on_TxtBtn_BLUE_button_up():
	Input.action_press("ui_up")

func _on_TxtBtn_RED_button_up():
	Input.action_press("ui_right")

func _on_TxtBtn_YELLOW_button_up():
	Input.action_press("ui_down")

func _on_TxtBtn_GREEN_button_up():
	Input.action_press("ui_left")
