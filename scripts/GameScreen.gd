extends Control

enum ButtonColors {NONE, BLUE, RED, YELLOW, GREEN}

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

func checkInput():
	playerChoice = 0
	
	if Input.is_action_just_pressed("ui_up") and !$TxtBtn_BLUE.pressed:
		playerChoice = ButtonColors.BLUE
		#compareChoices(ButtonColors.BLUE)
	elif Input.is_action_just_pressed("ui_down") and !$TxtBtn_YELLOW.pressed:
		playerChoice = ButtonColors.YELLOW
		#compareChoices(ButtonColors.YELLOW)
	elif Input.is_action_just_pressed("ui_right") and !$TxtBtn_RED.pressed:
		playerChoice = ButtonColors.RED
		#compareChoices(ButtonColors.RED)
	elif Input.is_action_just_pressed("ui_left") and !$TxtBtn_GREEN.pressed:
		playerChoice = ButtonColors.GREEN
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

func getNextColor():
	randomize()
	var nextColor: int = (randi() % (ButtonColors.size()-1)+1)
	moveList.append(nextColor)
	playList()

func playList():
	#print("Round " + str(moveList.size()))
	var list: String = "Round " + str(moveList.size()) + ":"
	for c in moveList:
		list += " " + str(ButtonColors.keys()[c])
	print(list)
		
	#print("Your turn! make your inputs.")
	isPlayerTurn = !isPlayerTurn

func resetGame():
	moveList.clear()
	checkPoint = 0
	isPlayerTurn = false


func _on_TxtBtn_BLUE_button_up():
	Input.action_press("ui_up")

func _on_TxtBtn_RED_button_up():
	Input.action_press("ui_right")

func _on_TxtBtn_YELLOW_button_up():
	Input.action_press("ui_down")

func _on_TxtBtn_GREEN_button_up():
	Input.action_press("ui_left")
