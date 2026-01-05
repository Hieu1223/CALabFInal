.eqv IN_ADDRESS_HEXA_KEYBOARD 0xFFFF0012
.eqv OUT_ADDRESS_HEXA_KEYBOARD 0xFFFF0014
.global is_ended
.data 
is_ended: .word 0
win_message0: .asciz "Player 0 wins press OK to play again"
win_message1: .asciz "Player 1 wins press OK to play again"
draw_message: .asciz "Draw press OK to play again"
.text

#only run this file
#unit width and height in pixel set to 4
#display width and height set to 512
#base adderss set to heapv

main:
#render board
	call void_render_board
#set the handler to gameloop
	la a0, void_gameloop
#copy and pasted from lab 11
	call set_interupt_handler
loop:
	la t0 won
	lw t0 0(t0)
	bnez t0 win
sleep:
	addi a7, zero, 32
	li a0, 300 # Sleep 300 ms
	ecall
	j loop
win:
	la t0 won
	lw t0 0(t0)
	li t1 2
	
	beq t0 t1 display_draw
	
	la t0 player_turn
	lw t0 0(t0)
	beqz t0 display_win_0
	bnez t0 display_win_1
	
	display_draw:
	la a0 draw_message
	j run_display
	
	display_win_0:
	la a0 win_message0
	j run_display
	
	display_win_1:
	la a0 win_message1
	
	
	
	
	run_display:
	li a1 1
	li a7 55
	ecall
	call clear_game_logic
	call void_clear_board
	j main


end_main:
#------------------------------
li a7 10
ecall 


set_interupt_handler:
#copy and pasted from lab 11

	csrrs zero, utvec, a0
	li t1, 0x100
	csrrs zero, uie, t1 # uie - ueie bit (bit 8 )
	csrrsi zero, ustatus, 1 # ustatus - enable uie (bit 0)
	li t1, IN_ADDRESS_HEXA_KEYBOARD
	li t3, 0x80 # bit 7 = 1 to enable interrupt
	sb t3, 0(t1)
	ret
.include "render_board.asm"
.include "game_loop.asm"
