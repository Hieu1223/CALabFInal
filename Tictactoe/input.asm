.eqv IN_ADDRESS_HEXA_KEYBOARD  0xFFFF0012
.eqv OUT_ADDRESS_HEXA_KEYBOARD 0xFFFF0014

.data
message: .asciz "Key scan code: "

.text


# --------------------------------------------------
# get_key_xy
#   stores column -> key_x
#   stores row    -> key_y
# --------------------------------------------------
get_key:
    # ---------- scan keypad ----------
    li t6, 0                      # t6 = accumulated keycode

    li t1, IN_ADDRESS_HEXA_KEYBOARD
    li t2, 0x01
    sb t2, 0(t1)
    li t1, OUT_ADDRESS_HEXA_KEYBOARD
    lb t0, 0(t1)
    add t6, t6, t0

    li t1, IN_ADDRESS_HEXA_KEYBOARD
    li t2, 0x02
    sb t2, 0(t1)
    li t1, OUT_ADDRESS_HEXA_KEYBOARD
    lb t0, 0(t1)
    add t6, t6, t0

    li t1, IN_ADDRESS_HEXA_KEYBOARD
    li t2, 0x04
    sb t2, 0(t1)
    li t1, OUT_ADDRESS_HEXA_KEYBOARD
    lb t0, 0(t1)
    add t6, t6, t0

    li t1, IN_ADDRESS_HEXA_KEYBOARD
    li t2, 0x88
    sb t2, 0(t1)
    li t1, OUT_ADDRESS_HEXA_KEYBOARD
    lb t0, 0(t1)
    add t6, t6, t0

    andi t6, t6, 0xff              # masked keycode

    # ---------- decode column (x) ----------
    andi t0, t6, 0x0F              # column bits
    li   t1, 0                     # x counter

col_loop:
    andi t2, t0, 1
    bnez t2, col_done
    srli t0, t0, 1
    addi t1, t1, 1
    j col_loop

col_done:
    la t3, key_y
    sb t1, 0(t3)

    # ---------- decode row (y) ----------
    srli t0, t6, 4                 # row bits
    li   t1, 0                     # y counter

row_loop:
    andi t2, t0, 1
    bnez t2, row_done
    srli t0, t0, 1
    addi t1, t1, 1
    j row_loop

row_done:
    la t3, key_x
    sb t1, 0(t3)

    ret

 
