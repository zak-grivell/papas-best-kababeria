extends Sprite2D;


@onready var beer = $Beer
@onready var beer_top = $BeerTop
@onready var head = $Head

@onready var y_offset: float = beer.texture.get_height()

func _ready() -> void:
	beer_top.position.y = y_offset
	head.position.y = y_offset
	beer.position.y = y_offset

func render_drink(glass_progress, head_portion):
	head.position.y = max((1 - glass_progress) * y_offset, 0)
		
	var beer_pos = (1 - glass_progress * (1 - head_portion)) * y_offset
	
	beer.position.y = max(beer_pos, 0)
	beer_top.position.y = max(beer_pos, 0)
