.global key_x
.global key_y

.data
msg: .asciz "Game update\n"
x_state: .word 0
o_state: .word 0
key_x: .word 0
key_y: .word 0
player_turn: .word 0
.text

li a0 1
li a7 93


void_gameloop:
addi sp sp -20
sw a0 0(sp)
sw a7 4(sp)
sw t0 8(sp)
sw t1 12(sp)
sw t2 16(sp)


#this is used to get key code and store into key_x and key_y
call get_key_code
call translate_key_code
la t0 x_state
lw a0 0(t0)
mv a0 t0

#this block of code doesnt work
call check_valid_move
li a7 1
ecall
mv a0 t0
call make_move
la t0 x_state
sw a0 0(t0)
li a7 35
ecall
#--------------------------


#handle rendering
#render_x_x_y to render x and render_o_x_y to render o
la t0 x_state
la t0 key_x
lw a0 0(t0)
la t0 key_y
lw a1 0(t0)

call render_x_x_y

#---------------


lw a0 0(sp)
lw a7 4(sp)
lw t0 8(sp)
lw t1 12(sp)
lw t2 16(sp)
addi sp sp 20
uret
ebreak

.include "render_x_o.asm"
.include "input.asm"
.include "game_logic.asm"
