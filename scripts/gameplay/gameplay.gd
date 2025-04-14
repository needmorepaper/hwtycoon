class_name Gameplay extends MarginContainer 
## TODO: This script is getting long. Should probably be split into different scripts. Gameplay and Gameplay_UI?

## How long does each day take in seconds at 1x speed
const tick = 0.5 

# BUG: Initial delay after first game_speed change.
var timer: Timer = Timer.new()

var date_time: Classes.DateTime = Classes.DateTime.new()

var finances: Classes.Finances = Classes.Finances.new()

var product: Classes.Product

enum GameSpeed {UNPAUSED, PAUSED, NORMAL, FAST, FASTER}

## Used by the player to set the game_speed.
var selected_game_speed: GameSpeed: 
	set(value):
		selected_game_speed = value
		game_speed = value


## Used by gameplay to set the game_speed.
var game_speed: GameSpeed: 
	set(value):
		if (value == GameSpeed.UNPAUSED):
			value = selected_game_speed
		game_speed = value
		match value:
			GameSpeed.PAUSED:
				%Speed0TextureButton.set_pressed_no_signal(true)
				%Speed1TextureButton.set_pressed_no_signal(false)
				%Speed2TextureButton.set_pressed_no_signal(false)
				%Speed3TextureButton.set_pressed_no_signal(false)
				timer.paused = true
			GameSpeed.NORMAL:
				%Speed0TextureButton.set_pressed_no_signal(false)
				%Speed1TextureButton.set_pressed_no_signal(true)
				%Speed2TextureButton.set_pressed_no_signal(false)
				%Speed3TextureButton.set_pressed_no_signal(false)
				timer.set_wait_time(tick / 1)
				timer.paused = false
			GameSpeed.FAST:
				%Speed0TextureButton.set_pressed_no_signal(false)
				%Speed1TextureButton.set_pressed_no_signal(false)
				%Speed2TextureButton.set_pressed_no_signal(true)
				%Speed3TextureButton.set_pressed_no_signal(false)
				timer.set_wait_time(tick / 2.5)
				timer.paused = false
			GameSpeed.FASTER:
				%Speed0TextureButton.set_pressed_no_signal(false)
				%Speed1TextureButton.set_pressed_no_signal(false)
				%Speed2TextureButton.set_pressed_no_signal(false)
				%Speed3TextureButton.set_pressed_no_signal(true)
				timer.set_wait_time(tick / 5)
				timer.paused = false


## Dictionary of various gameplay screens
var Screens: Dictionary = {
	OFFICE = Classes.Screen.new("OFFICE", false, true, false),
	PAUSE_MENU = Classes.Screen.new("PAUSE_MENU", false, false, false),
	DROP_DOWN = Classes.Screen.new("DROP_DOWN", false, true, false),
	
	# Dropdown-able
	NEW_HARDWARE = Classes.Screen.new("New Hardware", true, false, true),
	RESEARCH = Classes.Screen.new("R&D", true, false, false),
	PRODUCTS = Classes.Screen.new("Products", true, false, false),
	COMPANIES = Classes.Screen.new("Companies", true, false, false),
	MILESTONES = Classes.Screen.new("Milestones", true, false, false),
	MARKET = Classes.Screen.new("Market", true, false, false),
	BANK = Classes.Screen.new("Bank", true, false, false)
	}


## Defines the active screen
var active_screen: Classes.Screen:
	## TODO: This is gonna be a *huge* mess as more screens get implemented.\
	set(value):
		active_screen = value
		match value:
			Screens.OFFICE:
				game_speed = GameSpeed.UNPAUSED
				%PauseMenuButtonMarginContainer.visible = true
				%PauseMenuMarginContainer.visible = false
				%DropdownMarginContainer.visible = false
				%NewHardwareMarginContainer.visible = false
			Screens.PAUSE_MENU:
				game_speed = GameSpeed.PAUSED
				%PauseMenuButtonMarginContainer.visible = false
				%PauseMenuMarginContainer.visible = true
				%DropdownMarginContainer.visible = false
				%NewHardwareMarginContainer.visible = false
			Screens.DROP_DOWN:
				game_speed = GameSpeed.PAUSED
				%PauseMenuButtonMarginContainer.visible = true
				%PauseMenuMarginContainer.visible = false
				%DropdownMarginContainer.visible = true
				%NewHardwareMarginContainer.visible = false
			Screens.NEW_HARDWARE: # TODO: Define Screen.NEW_HARDWARE
				game_speed = GameSpeed.PAUSED
				%PauseMenuButtonMarginContainer.visible = false
				%PauseMenuMarginContainer.visible = false
				%DropdownMarginContainer.visible = false
				%NewHardwareMarginContainer.visible = true
			Screens.RESEARCH: # TODO: Define Screen.RESEARCH
				pass
			Screens.MARKET: # TODO: Define Screen.MARKET
				pass
			Screens.BANK: # TODO: Define Screen.BANK
				pass


## Defines hardware types
var Hardwares: Dictionary = {
	CPU = Classes.Hardware.new("CPU", 
		preload("res://resources/imported_resources/hardw_cpu-sheet0.png"), 
		preload("res://resources/imported_resources/hardw_cpu-sheet1.png"), 
		true),
	GPU = Classes.Hardware.new("GPU", 
		preload("res://resources/imported_resources/hardw_gpu-sheet0.png"), 
		preload("res://resources/imported_resources/hardw_gpu-sheet1.png"), 
		true)
}


## Defines architecture types
var Architectures: Dictionary = {
	DefaultCPUArchitecture = Classes.Architecture.new("Default CPU Architecture", Hardwares.CPU),
	DefaultGPUArchitecture = Classes.Architecture.new("Default GPU Architecture", Hardwares.GPU)
}


## Defines process nodes
var ProcessNodes: Array = [
	Classes.ProcessNode.new("15 μm", 15000)
]


func _ready():
	date_time.count = date_time.dict_to_day_count(Global.player_company.starting_date_time)
	print(date_time.count)
	
	date_time.changed.connect(_on_date_time_changed)
	date_time.day_incremented.connect(_on_day_incremented)
	date_time.month_incremented.connect(_on_month_incremented)
	date_time.year_incremented.connect(_on_year_incremented)
	
	selected_game_speed = GameSpeed.PAUSED
	
	active_screen = Screens.OFFICE
	
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)
	timer.start()
	
	product = Classes.Product.new(date_time)
	# TODO: design_cost is logged in the finance screen as a total at the start of design, but is taken from balance monthly. design_cost_per_month = product.design_cost / (product.design_time / date_time.days_in_month)
	finances.expenses += product.design_cost


func _process(_delta):
	%DateRichTextLabel.text = "%s" % [date_time.count_to_string()]
	%ProfitRichTextLabel.text = "$%sk" % snapped((Global.player_company.profit/1000.1),0.01)


func _on_date_time_changed(value):
	Global.player_company.days_elapsed = value


func _on_day_incremented(_day):
	var weeks_since_sale: int = floor((date_time.count / 7) - (product.product_release_day / 7) + 1) # Add 1 to account for the Fencepost problem.
	var profit_per_sale: float = product.retail_price - product.production_cost
	var number_of_sales: int = 2 ## TODO: Calculate the number of sales per day. Based off popularity and hype?
	
	if (date_time.count == product.product_release_day):
		product._on_product_release_day(date_time)
	
	if (date_time.count >= product.product_release_day):
		if (weeks_since_sale > product.weeks_on_sale): # INFO: The profit from the sales of a product show up in the finances log screen grouped by weeks, whereas the profit is added to the players account daily.
			product.weeks_on_sale = weeks_since_sale
			product._on_weeks_since_product_release(date_time)
		
		if (profit_per_sale > 0): # Update finances with sale profits.
			product.weekly_sales += number_of_sales
			finances.income += profit_per_sale * number_of_sales 
		elif (profit_per_sale < 0):
			product.weekly_sales += number_of_sales
			finances.expenses += profit_per_sale * number_of_sales


func _on_month_incremented(_month):
	finances.expenses += Global.player_company.monthly_rent # Charge rent each month. Value set by PlayerCompany.


func _on_year_incremented(_year):
	if (finances.annual_profit >= 1000):
		var tax_rate = Global.player_company.tax_rate # The yearly tax rate. Value set by PlayerCompany.
		var tax = finances.annual_profit * tax_rate
		finances.expenses += tax
		finances.annual_profit = 0 # Reset annual_profit each year.
		finances.annual_expenses = 0 # Reset annual_expenses each year.


func _on_timer_timeout():
	date_time.increment()


func _on_speed_0_texture_button_toggled(toggled_on):
	if (toggled_on && active_screen.unpausable):
		selected_game_speed = GameSpeed.PAUSED
	else:
		%Speed0TextureButton.set_pressed_no_signal(true)

func _on_speed_1_texture_button_toggled(toggled_on):
	if (toggled_on && active_screen.unpausable):
		selected_game_speed = GameSpeed.NORMAL
	else:
		%Speed1TextureButton.set_pressed_no_signal(false)
		%Speed0TextureButton.set_pressed_no_signal(true)


func _on_speed_2_texture_button_toggled(toggled_on):
	if (toggled_on && active_screen.unpausable):
		selected_game_speed = GameSpeed.FAST
	else:
		%Speed2TextureButton.set_pressed_no_signal(false)
		%Speed0TextureButton.set_pressed_no_signal(true)

func _on_speed_3_texture_button_toggled(toggled_on):
	if (toggled_on && active_screen.unpausable):
		selected_game_speed = GameSpeed.FASTER
	else:
		%Speed3TextureButton.set_pressed_no_signal(false)
		%Speed0TextureButton.set_pressed_no_signal(true)

func _on_office_texture_button_pressed():
	if (active_screen == Screens.OFFICE):
		active_screen = Screens.DROP_DOWN
	elif (active_screen == Screens.DROP_DOWN):
		active_screen = Screens.OFFICE


func _on_background_button_pressed():
	if (active_screen == Screens.DROP_DOWN):
		active_screen = Screens.OFFICE


func _on_pause_menu_button_pressed():
	game_speed = GameSpeed.PAUSED
	active_screen = Screens.PAUSE_MENU
