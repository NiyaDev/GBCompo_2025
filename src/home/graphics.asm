
section "home_graphics", ROM0[$00A7]
;; Waits for blank to do graphics stuff
; Destroys - a
; Size     - b
wait_vblank::
  ldh a, [rLY]
  cp 144
  jp c, wait_vblank
  ret

;; Turns off lcd
lcd_toggle::
  ldh a, [rLCDC]
  xor LCDCF_ON
  ldh [rLCDC], a
  ret

;; 
copy_bg_tile_data::
  ld de, test_graphics
  ld hl, _VRAM
  ld bc, test_graphics.end - test_graphics
.loop:
  ld a, [de]
  ld [hl+], a
  inc de
  dec bc
  ld a, b
  or c
  jr nz, .loop

  ret

