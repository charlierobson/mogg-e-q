    .module SELLR

_SELID = user_

id2x:
    sla     a
    sla     a
    add     a,3
    ret


selectedfader:
    .byte   0


selectaLR:
    ld      (iy+y_),10
    ld      (iy+_SELID),1
    jr      _draw

_loop:
    ld      a,(left)
    cp      1
    call    z,_goleft

    ld      a,(right)
    cp      1
    call    z,_goright

_draw:
    ld      a,(iy+_SELID)
    ld      (selectedfader),a
    call    id2x
    ld      (iy+x_),a

    ld      l,(iy+aL_)
    ld      h,(iy+aH_)
    ld      (hl),0
    inc     hl
    ld      (hl),0

    call    xy2dfile

    ld      (iy+aL_),l
    ld      (iy+aH_),h
    ld      (hl),$98
    inc     hl
    ld      (hl),$98
    YIELD
    jr      _loop


_goleft:
    ld      a,(iy+_SELID)
    dec     a
    ret     m
    ld      (iy+_SELID),a
    ret

_goright:
    ld      a,(iy+_SELID)
    inc     a
    cp      4
    ret     z
    ld      (iy+_SELID),a
    ret
