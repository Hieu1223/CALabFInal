.extern board 64
.text

li a0 1
li a7 93
ecall

#0 = nothing, 1 = o  2 = x
int_check_win:
ret
ebreak