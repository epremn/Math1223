.data
    SIZE:           .word 4
    prompt1:        .asciiz "Enter the number of the first cell (1-16): "
    prompt2:        .asciiz "Enter the number of the second cell (1-16): "
    notMatch:       .asciiz "Not a match. Try again.\n"
    matchMessage:   .asciiz "Match found!\n"
    board:          .space 64   # Space for 4x4 board (each cell 4 bytes)
    invalidChoiceMsg: .asciiz "Invalid choice, please select covered cells.\n"
    

.text
userInput:
    li   $v0, 4
    la   $a0, prompt1
    syscall

    li   $v0, 5
    syscall
    sub  $t0, $v0, 1

    lw   $t1, SIZE
    div  $t0, $t1
    mflo $t2
    mfhi $t3

    li   $v0, 4
    la   $a0, prompt2
    syscall

    li   $v0, 5
    syscall
    sub  $t4, $v0, 1

    div  $t4, $t1
    mflo $t5
    mfhi $t6

    jal  isValidChoice
    beqz $v0, invalidChoice

    jal  revealCells
    jal  printBoard

    lw   $t7, board($t2)
    lw   $t8, board($t5)
    beq  $t7, $t8, matchFound

    li   $v0, 4
    la   $a0, notMatch
    syscall

    li   $v0, 35
    li   $a0, 2
    syscall

invalidChoice:
    li   $v0, 4
    la   $a0, invalidChoiceMsg
    syscall
    j   done

matchFound:
    li   $v0, 4
    la   $a0, matchMessage
    syscall

done:
    jr  $ra

isValidChoice:
    li   $t9, 4
    bltz $t2, invalid
    bge  $t2, $t9, invalid
    bltz $t3, invalid
    bge  $t3, $t9, invalid
    bltz $t5, invalid
    bge  $t5, $t9, invalid
    bltz $t6, invalid
    bge  $t6, $t9, invalid
    bne  $t2, $t5, valid
    bne  $t3, $t6, valid

invalid:
    li   $v0, 0
    jr   $ra

valid:
    li   $v0, 1
    jr   $ra

revealCells:
    # Code to reveal the cells at (row1, col1) and (row2, col2)
    # Here, assuming reveal operation updates cells
    # Example reveal action (update the board to "revealed" state)
    # The exact implementation will depend on how you want the cells to be "revealed"
    # Placeholder:
    # sw instruction to change cell values, if required, here
    jr  $ra

printBoard:
    # Code to print the board state
    # Implement display logic here
    jr  $ra



    
