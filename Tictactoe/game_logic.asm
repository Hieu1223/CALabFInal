.text



li a0 1
li a7 93
ecall

# a0 = board state
# return a0 = 1 if valid, 0 if invalid
check_valid_move:
    mv   t6, a0          # save board

    # ---- load key_x ----
    la   t0, key_x
    lw   t1, 0(t0)       # t1 = x

    # ---- load key_y ----
    la   t0, key_y
    lw   t2, 0(t0)       # t2 = y

    # ---- pos = y*4 + x ----
    slli t2, t2, 2       # y * 4
    add  t2, t2, t1      # pos

    # ---- mask = 1 << pos ----
    li   t3, 1
    sll  t3, t3, t2

    # ---- check occupied ----
    and  t4, t6, t3
    beqz t4, valid_move

invalid_move:
    li   a0, 0
    ret

valid_move:
    li   a0, 1
    ret
ebreak







# a0 = player board (16-bit)
# returns a0 = 1 if win, 0 otherwise
#apply bitmask over the player state and check if the masked bit field is equal to the mask (the same pattern as the mask)
check_win:
    li t0, 0xF000   # row 4
    li t1, 0x0F00   # row 3
    li t2, 0x00F0   # row 2
    li t3, 0x000F   # row 1

    # check rows
    and t4, a0, t0
    beq t4, t0, on_win
    and t4, a0, t1
    beq t4, t1, on_win
    and t4, a0, t2
    beq t4, t2, on_win
    and t4, a0, t3
    beq t4, t3, on_win

    # check columns
    li t0, 0x1111
    li t1, 0x2222
    li t2, 0x4444
    li t3, 0x8888

    and t4, a0, t0
    beq t4, t0, on_win
    and t4, a0, t1
    beq t4, t1, on_win
    and t4, a0, t2
    beq t4, t2, on_win
    and t4, a0, t3
    beq t4, t3, on_win

    # check diagonals
    li t0, 0x8421    # top-left to bottom-right
    li t1, 0x1248    # top-right to bottom-left

    and t4, a0, t0
    beq t4, t0, on_win
    and t4, a0, t1
    beq t4, t1, on_win

    # no win
    li a0, 0
    ret

on_win:
    li a0, 1
    ret
ebreak








# a0 = current board state
# uses key_x and key_y globals
# returns a0 = updated board state
make_move:
    # ---- load key_x ----
    la   t0, key_x
    lw   t1, 0(t0)        # t1 = x

    # ---- load key_y ----
    la   t0, key_y
    lw   t2, 0(t0)        # t2 = y

    # ---- pos = y*4 + x ----
    slli t2, t2, 2        # t2 = y*4
    add  t2, t2, t1       # t2 = pos

    # ---- mask = 1 << pos ----
    li   t3, 1
    sll  t3, t3, t2       # t3 = mask

    # ---- update board ----
    or   a0, a0, t3       # a0 = board | mask

    ret
ebreak

