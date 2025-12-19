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

#a0 = player state, ret a0 = 0 not win/ 1 win
check_win:


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

