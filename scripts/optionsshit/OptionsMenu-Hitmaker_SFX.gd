extends Panel

@onready var SFXList: ItemList = $HitmarkerSFXList
@onready var SelectedItem: Label = $Label2

func _ready() -> void:
	SFXList.select(0)
	
func _physics_process(delta: float) -> void:
	SelectedItem.text = "Selected Item: %s" % SFXList.get_selected_items()
	
func save_option():
	Options.set_option("HitmarkerSound", SFXList.get_selected_items())
	
