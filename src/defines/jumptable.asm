
;; Calls jump table with offset
macro call_jumptable
  ld a, \1
  rst $00
endm

;; Calls function at offset on bank
macro call_far
  ld h, \1
  ld l, \2
  rst $10
endm

