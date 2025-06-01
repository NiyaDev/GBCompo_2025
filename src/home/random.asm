
section "random_gen", ROM0[$0098]
;; Generates a pseudo-random number
; Uses LCG formula: x[n+1] = ($65 * x[n] + $1A)
; Destroys - a, c, hl
; Returns  - a=HiState, c=LoState
; Size     - 15b
rand::
  ld hl, randstate+0
  ld a,[hl]
  add $1A
  ld [hl+], a
  adc a, [hl]
  ld [hl+], a
  adc a, [hl]
  ld [hl+], a
  ld c, a
  adc a, [hl]
  ld [hl], a

  ret
