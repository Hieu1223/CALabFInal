.eqv IN_ADDRESS_HEXA_KEYBOARD 0xFFFF0012
.eqv OUT_ADDRESS_HEXA_KEYBOARD 0xFFFF0014


.text

#only run this file
#unit width and height in pixel set to 4
#display width and height set to 512


main:
#render board
	call void_render_board
#set the handler to gameloop
	la t0, void_gameloop
#copy and pasted from lab 11

	csrrs zero, utvec, t0
	li t1, 0x100
	csrrs zero, uie, t1 # uie - ueie bit (bit 8 )
	csrrsi zero, ustatus, 1 # ustatus - enable uie (bit 0)
	li t1, IN_ADDRESS_HEXA_KEYBOARD
	li t3, 0x80 # bit 7 = 1 to enable interrupt
	sb t3, 0(t1)
	xor s0, s0, s0 # count = s0 = 0
loop:
	addi s0, s0, 1 # count = count + 1

sleep:
	addi a7, zero, 32
	li a0, 300 # Sleep 300 ms
	ecall
	j loop
end_main:
#------------------------------
li a7 10
ecall 


.include "render_board.asm"
.include "game_loop.asm"
