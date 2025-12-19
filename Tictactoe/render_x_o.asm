.eqv CELL_WIDTH 32
.eqv LINE_COLOR 0xffffff
.eqv SCREEN_BASE_ADDRESS 0x10010000
.eqv SCREEN_WIDTH 128
.data
circle_pixel_array: .word 


.text

li a0 1
li a7 93
ecall


# x: a0 , y: a1   (BOARD coordinates)
# a0 = board x, a1 = board y
render_x_x_y:
    li   t0, CELL_WIDTH
    mul  t1, a0, t0        # t1 = cell_px
    mul  t2, a1, t0        # t2 = cell_py

    li   t3, 0             # i = 0
    li   t4, LINE_COLOR
    li   t5, SCREEN_BASE_ADDRESS

x_loop:
    # ---- diag 1 (px+i, py+i) ----
    add  t6, t1, t3        # px
    add  a0, t2, t3        # py

    slli a0, a0, 7         # py * 128
    add  a0, a0, t6
    slli a0, a0, 2
    add  a0, a0, t5
    sw   t4, 0(a0)

    # ---- diag 2 (px+31-i, py+i) ----
    li   a1, 31
    sub  a1, a1, t3
    add  t6, t1, a1
    add  a0, t2, t3

    slli a0, a0, 7
    add  a0, a0, t6
    slli a0, a0, 2
    add  a0, a0, t5
    sw   t4, 0(a0)

    addi t3, t3, 1
    li   a1, CELL_WIDTH
    blt  t3, a1, x_loop

    ret
ebreak


# a0 = board x, a1 = board y
render_o_x_y:
    # cell_px = board_x * 32
    li   t0, CELL_WIDTH
    mul  t0, a0, t0

    # cell_py = board_y * 32
    li   t1, CELL_WIDTH
    mul  t1, a1, t1

    li   t3, 0              # j = 0 (y inside cell)

o_y_loop:
    li   t2, 0              # i = 0 (x inside cell)

o_x_loop:
    # dx = i - 16
    addi t4, t2, -16
    mul  t4, t4, t4         # dx²

    # dy = j - 16
    addi t5, t3, -16
    mul  t5, t5, t5         # dy²

    add  t6, t4, t5         # dx² + dy²

    # if d < 210 skip
    li   a2, 210
    blt  t6, a2, o_skip

    # if d > 240 skip
    li   a2, 240
    bgt  t6, a2, o_skip

    # screen_x = cell_px + i
    add  a2, t0, t2

    # screen_y = cell_py + j
    add  a3, t1, t3

    # addr = BASE + ((y * 128 + x) * 4)
    slli a4, a3, 7           # y * 128
    add  a4, a4, a2
    slli a4, a4, 2
    li   a5, SCREEN_BASE_ADDRESS
    add  a4, a4, a5

    li   a6, LINE_COLOR
    sw   a6, 0(a4)

o_skip:
    addi t2, t2, 1
    li   a2, CELL_WIDTH
    blt  t2, a2, o_x_loop

    addi t3, t3, 1
    blt  t3, a2, o_y_loop

    ret
ebreak