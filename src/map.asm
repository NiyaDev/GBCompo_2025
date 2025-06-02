
;; Generate basic map
generate_map_simple::
  ld hl, map
  ld bc, (MAP_SIZE_WIDTH * MAP_SIZE_HEIGHT)

.loop:
  push bc
  push hl
  call rand
  pop hl
  pop bc

  cp $7F
  jp nc, .lesser
  
.greater:
  ld a, $00
  ld [hl+], a
  jp .continue

.lesser:
  ld a, $01
  ld [hl+], a

.continue:
  dec bc
  ld a, b
  or a, c
  jp nz, .loop
 
  call set_map_tiles

  ret


;;
set_map_tiles::
  ld hl, _SCRN0
  ld de, map
  ld bc, (MAP_SIZE_WIDTH * MAP_SIZE_HEIGHT)
  xor a
  ld [floor_round], a

.loop:
  ld a, [de]
  cp 1
  jp nz, .air

.wall:
  ld a, [cross_temp]
  ld [hl+], a
  ld a, [cross_temp+1]
  ld [hl+], a

  push hl
  xor a
  ld a, l
  add 30
  ld l, a
  ld a, h
  adc 0
  ld h, a

  ld a, [cross_temp+2]
  ld [hl+], a
  ld a, [cross_temp+3]
  ld [hl], a
  pop hl
  jp .check_tile
  
.air:
  ld a, 0
  ld [hl+], a
  ld a, 0
  ld [hl+], a

  push hl
  xor a
  ld a, l
  add 30
  ld l, a
  ld a, h
  adc 0
  ld h, a

  ld a, 0
  ld [hl+], a
  ld a, 0
  ld [hl], a
  pop hl

.check_tile:
  ld a, [floor_round]
  inc a
  cp MAP_SIZE_WIDTH
  ld [floor_round], a
  jp nz, .final

  xor a
  ld [floor_round], a
  ld a, l
  add 30 + ((MAP_SIZE_WIDTH / 16) * 2)
  ld l, a
  ld a, h
  adc 0
  ld h, a

.final
  inc de
  dec bc
  ld a, b
  or c
  jp nz, .loop


