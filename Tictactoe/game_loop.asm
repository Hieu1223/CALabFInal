.global key_x
.global key_y
.global won
.global player_turn
.data
msg: .asciz "Game update\n"
x_state: .word 0 #the board state is divided into x_state and o_state, both are bit field
o_state: .word 0 
key_x: .word 0
key_y: .word 0
player_turn: .word 0
won: .word 0
invalid_move_message: .asciz "Invalid move"
.text

li a0 1
li a7 93
ecall


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
or a0 a0 t0 #x_state or o_state to get the bitfield representing filled cell


call check_valid_move
bnez a0 on_invalid_move_end

on_invalid_move:
#put an error dialog with invalid_move_message
la a0 invalid_move_message
li a1 0
li a7 55
ecall
j game_loop_end
on_invalid_move_end:


#make move

la a0 player_turn #check turn
lw a0 0(a0)

bnez a0 o_make_move
#update x_state
x_make_move:
la a0 x_state
lw a0 0(a0)
call make_move
la t0 x_state
sw a0 0(t0)
call check_win
j end_make_move

#update o_state
o_make_move:
la a0 o_state
lw a0 0(a0)
call make_move
la t0 o_state
sw a0 0(t0)
call check_win
j end_make_move


end_make_move:
#store win flag
la t0 won
sw a0 0(t0)

#--------------------------
#handle rendering
#render_x_x_y to render x and render_o_x_y to render o
la t0 key_x 
lw a0 0(t0) 
la t0 key_y          #get key (x,y)
lw a1 0(t0)


la t0 player_turn
lw t0 0(t0)               #render the apporiate symbol
bnez t0 o_render

x_render:
call render_x_x_y
j end_render


o_render:
call render_o_x_y
j end_render

end_render:
#---------------

skip_swap: #skip swapping when detected game won
la t0 won
lw t0 0(t0)
bnez t0 game_loop_end


#swap player turn
swap_turn:
la t1 player_turn
lw t0 0(t1)
xori t0 t0 1
sw t0 0(t1)



game_loop_end:
#set the end flag at the end to render the last symbol (doesnt work)
la t0 won
lw a0 0(t0)
la t0 is_ended
sw a0 0(t0) 
#----------------------


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
