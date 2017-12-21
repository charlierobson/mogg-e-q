    .module SELLR

selectedfader:
    .byte   0

selectaLR:
    ld      a,7
    ld      (iy+x_),a
    ld      (selectedfader),a
    ld      (iy+y_),8

_loop:
    ld      a,(left)
    cp      1
    call    z,_goleft

    ld      a,(right)
    cp      1
    call    z,_goright

    ld      a,(iy+x_)
    ld      (selectedfader),a

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
    ld      a,(iy+x_)
    sub     4
    ret     m
    ld      (iy+x_),a
    ret

_goright:
    ld      a,(iy+x_)
    add     a,4
    cp      19
    ret     z
    ld      (iy+x_),a
    ret
