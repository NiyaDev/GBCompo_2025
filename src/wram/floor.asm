
section "current_floor", WRAM0[$C010]
floor_number:: ds 2
floor_type:: ds 1
floor_round:: ds 1
map:: ds TILE_SIZE * (MAP_SIZE_WIDTH * MAP_SIZE_HEIGHT)

