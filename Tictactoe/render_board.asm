.eqv SCREEN_WIDTH 128
.eqv SCREEN_HEIGHT 128
.eqv CELL_WIDTH 32
.eqv SCREEN_BASE_ADDRESS 0x10040000
.eqv LINE_COLOR 0xffffff
.eqv BOARD_COLOR 0x0
.text

li a0 1
li a7 93
ecall


void_render_board:
addi sp, sp, -16
sw ra, 0(sp)
sw s0, 4(sp)
sw s1, 8(sp)
sw s2, 12(sp)


li s0, CELL_WIDTH
li s2, 128

void_render_board_l1_start:

mv a0, s0
li a1 LINE_COLOR
call void_draw_hor_line_y

mv a0, s0
li a1 LINE_COLOR
call void_draw_ver_line_x

addi s0, s0, CELL_WIDTH
beq  s0, s2, void_render_board_l1_end
j void_render_board_l1_start

void_render_board_l1_end:

lw ra, 0(sp)
lw s0, 4(sp)
lw s1, 8(sp)
lw s2, 12(sp)
addi sp, sp, 16
ret

ebreak


#clear board
void_clear_board:
addi sp, sp, -16
sw ra, 0(sp)
sw s0, 4(sp)
sw s1, 8(sp)
sw s2, 12(sp)


li s0, 0
li s2, 128

void_clear_board_l1_start:

mv a0, s0
li a1 BOARD_COLOR
call void_draw_hor_line_y

addi s0, s0, 1
beq  s0, s2, void_render_board_l1_end
j void_clear_board_l1_start

void_clear_board_l1_end:

lw ra, 0(sp)
lw s0, 4(sp)
lw s1, 8(sp)
lw s2, 12(sp)
addi sp, sp, 16
ret

ebreak




# a0 = y coordinate
# a1 = color
void_draw_hor_line_y:
    # offset = y * SCREEN_WIDTH * 4
    li   t0, SCREEN_WIDTH
    mul  t0, a0, t0        # y * width
    slli t0, t0, 2         # *4 bytes

    li   t1, SCREEN_BASE_ADDRESS
    add  t1, t1, t0        # t1 = row start address

    mv   t2, a1
    li   t3, SCREEN_WIDTH # pixel counter

void_draw_hor_line_y_loop:
    sw   t2, 0(t1)         # draw pixel
    addi t1, t1, 4         # next pixel
    addi t3, t3, -1
    bnez t3, void_draw_hor_line_y_loop
    ret


ebreak

# a0 = x coordinate
# a1 color
void_draw_ver_line_x:
    li   t0, SCREEN_BASE_ADDRESS
    slli t1, a0, 2          # x * 4
    add  t0, t0, t1         # starting address at (x,0)

    mv   t2, a1
    li   t3, SCREEN_HEIGHT  # row counter
    li   t4, SCREEN_WIDTH
    slli t4, t4, 2          # row stride = width * 4

void_draw_ver_line_x_loop:
    sw   t2, 0(t0)
    add  t0, t0, t4         # next row
    addi t3, t3, -1
    bnez t3, void_draw_ver_line_x_loop

    ret
ebreak


