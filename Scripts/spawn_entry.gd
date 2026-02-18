class_name SpawnEntry extends Resource

@export var scene: PackedScene
## We only spawn one at a time, this is just for
## how many of this you wanna spawn before moving onto the next.
@export var count: int = 1
@export var spawn_rate: float = 1.0
