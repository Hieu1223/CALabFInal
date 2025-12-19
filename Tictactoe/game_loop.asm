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
addi sp sp -28
sw a0 0(sp)
sw a7 4(sp)
sw t0 8(sp)
sw t1 12(sp)
sw t2 16(sp)

#this is used to get key code and store into key_x and key_y
call get_key_code
call translate_key_code

#check if move_valid
la a0 x_state
lw a0 0(a0)
la t0 o_state
lw t0 0(t0)
or a0 a0 t0
call check_valid_move
beqz a0 game_loop_end

#make move
x_make_move:
la a0 x_state
lw a0 0(a0)
call make_move
la t0 x_state
sw a0 0(t0)
j end_make_move


y_make_move:
la a0 o_state
lw a0 0(a0)
call make_move
la t0 o_state
sw a0 0(t0)
j end_make_move


end_make_move:

#--------------------------
#handle rendering
#render_x_x_y to render x and render_o_x_y to render o
la t0 key_x
lw a0 0(t0)
la t0 key_y
lw a1 0(t0)

la t0 player_turn
lw t0 0(t0)
bnez t0 o_render

x_render:
call render_x_x_y
j end_render
o_render:
call render_o_x_y
j end_render

end_render:
#---------------
swap_turn:
la t1 player_turn
lw t0 0(t1)
xori t0 t0 1
sw t0 0(t1)
mv a0 t0
li a7 1
ecall

game_loop_end:
lw a0 0(sp)
lw a7 4(sp)
lw t0 8(sp)
lw t1 12(sp)
lw t2 16(sp)
addi sp sp 28
uret
ebreak

.include "render_x_o.asm"
.include "input.asm"
.include "game_logic.asm"
