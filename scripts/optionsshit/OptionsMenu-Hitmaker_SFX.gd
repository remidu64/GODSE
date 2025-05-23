extends Panel

@onready var SFXList: ItemList = $HitmarkerSFXList
@onready var SelectedItem: Label = $Label2

var item_name: String

func _ready() -> void:
	SFXList.select(Options.get_option("HitmarkerSound"))
	
func _physics_process(delta: float) -> void:
	match SFXList.get_selected_items()[0]:
		0:
			item_name = "GODSE Style"
		1:
			item_name = "Meme Style"
			
	SelectedItem.text = "Selected Item: "+item_name
	
func save_option():
	Options.set_option("HitmarkerSound", SFXList.get_selected_items()[0])
	
