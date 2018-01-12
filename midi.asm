    .module MIDI


openmidi:
    ld      de,_startmidimsg
    jp      $1ff2


playmiddlec:
    ld      de,_middlec
    ld      l,6

    ; fall through

spoogemidi:
    ld      a,1
    call    $1ffc

    ld      bc,$e007        ; write usart
    ld      a,$c0
    out     (c),a

    jp      $1ff6           ; get response


_startmidimsg:
    .asc    "OPEN MIDI"
    .byte   $ff


_middlec:
    .byte   $90, 60, 127    ; note on channel 0, middle c, on-velocity
    .byte   $80, 60, 0      ; note off channel 0, middle c, off-velocity

eqlo

midibuffer:
    .fill   256
