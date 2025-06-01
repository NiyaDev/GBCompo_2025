
section "jump_table", ROM0[$0000]
;; Uses jump table located after call
; Destroys - a, hl
; Inputs   - a=Offset, hl=Return addr
; Size     - 13b
RST00::
  pop hl
  push hl
  add a
  add l
  ld l, a
  ld a, 0
  adc h
  ld h, a

RST08::
  ld a, [hl+]
  ld h, [hl]
  ld l, a
  jp hl


section "far_call", ROM0[$0010]
;; Switches ROM bank and calls function offset
; Destroys - a, b, c
; Inputs   - h=Bank, l=offset
; Size     - 22b
RST10::
  ; Save bank number
  ld a, [rRAMB]
  push af

  ; Change bank
  ld a, h
  ld [rROMB0], a

  ; Double offset and add it to $4001
  add hl, hl
  ld h, 0
  ld bc, $4001
  add hl, bc

  ; Call function
  call RST08

  ; switch bank back
  pop af
  ld [rROMB0],a
  ret


