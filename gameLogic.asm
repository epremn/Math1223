.data
    valid_message: .asciiz "Valid choice!"
    invalid_message: .asciiz "Invalid choice, try again."
    SIZE: .word 4  # Example size, you can adjust it as needed
    revealed: .space 64         # 4x4 revealed grid, each cell 4 bytes (initialized to 0 for false)

.text
gameLogic:
    # Validate user choice and process game logic
    # Reveal cells or hide them based on match
    # Check if game is over and exit if necessary

# isValidChoice method
isValidChoice:
    # Input: $a0 = row1, $a1 = col1, $a2 = row2, $a3 = col2
    # Check if the selected cells are the same
    beq $a0, $a2, check_col_eq   # If row1 == row2, check column equality
    li $v0, 1                     # If rows are different, valid choice
    jr $ra                         # Return

check_col_eq:
    beq $a1, $a3, invalid_choice  # If column1 == column2, invalid choice
    li $v0, 1                     # If rows are same, but columns are different, valid choice
    jr $ra                         # Return

invalid_choice:
    li $v0, 0                     # Return false (invalid choice)
    jr $ra                         # Return

# revealCells method
revealCells:
    # Input: $a0 = row1, $a1 = col1, $a2 = row2, $a3 = col2
    # Mark cells as revealed

    la $t0, SIZE                  # Load address of SIZE into $t0
    lw $t0, 0($t0)                # Load value of SIZE into $t0

    # Reveal first cell
    mul $t1, $a0, $t0             # Row offset for first cell (row1 * SIZE)
    mul $t2, $a1, 4               # Column offset for first cell (col1 * 4)
    add $t1, $t1, $t2             # Final offset for first cell
    la $t3, revealed              # Base address of revealed array
    add $t3, $t3, $t1             # Address of revealed[row1][col1]
    li $t4, 1                     # True (cell revealed)
    sw $t4, 0($t3)                # Store true in revealed[row1][col1]

    # Reveal second cell
    mul $t1, $a2, $t0             # Row offset for second cell (row2 * SIZE)
    mul $t2, $a3, 4               # Column offset for second cell (col2 * 4)
    add $t1, $t1, $t2             # Final offset for second cell
    add $t3, $t3, $t1             # Address of revealed[row2][col2]
    sw $t4, 0($t3)                # Store true in revealed[row2][col2]

    jr $ra                        # Return

# hideCells method
hideCells:
    # Input: $a0 = row1, $a1 = col1, $a2 = row2, $a3 = col2
    # Mark cells as hidden

    la $t0, SIZE                  # Load address of SIZE into $t0
    lw $t0, 0($t0)                # Load value of SIZE into $t0

    # Hide first cell
    mul $t1, $a0, $t0             # Row offset for first cell (row1 * SIZE)
    mul $t2, $a1, 4               # Column offset for first cell (col1 * 4)
    add $t1, $t1, $t2             # Final offset for first cell
    la $t3, revealed              # Base address of revealed array
    add $t3, $t3, $t1             # Address of revealed[row1][col1]
    li $t4, 0                     # False (cell hidden)
    sw $t4, 0($t3)                # Store false in revealed[row1][col1]

    # Hide second cell
    mul $t1, $a2, $t0             # Row offset for second cell (row2 * SIZE)
    mul $t2, $a3, 4               # Column offset for second cell (col2 * 4)
    add $t1, $t1, $t2             # Final offset for second cell
    add $t3, $t3, $t1             # Address of revealed[row2][col2]
    sw $t4, 0($t3)                # Store false in revealed[row2][col2]

    jr $ra                        # Return

# isGameOver method
isGameOver:
    # Check if all cells have been revealed

    la $t0, SIZE                  # Load address of SIZE into $t0
    lw $t0, 0($t0)                # Load value of SIZE into $t0
    li $t1, 0                     # Row index (0)
game_over_loop:
    bge $t1, $t0, game_over_done  # If row index >= SIZE, end checking

    li $t2, 0                     # Column index (0)
game_over_col_loop:
    bge $t2, $t0, game_over_row_inc  # If col index >= SIZE, next row

    # Check if revealed[row][col] is false
    la $t3, revealed              # Base address of revealed array
    mul $t4, $t1, $t0             # Row offset
    mul $t5, $t2, 4               # Column offset
    add $t4, $t4, $t5             # Final offset for revealed[row][col]
    add $t3, $t3, $t4             # Address of revealed[row][col]
    lw $t6, 0($t3)                # Load revealed status

    # If any cell is not revealed, game is not over
    beqz $t6, game_over_not_done

    addi $t2, $t2, 1              # Increment column index
    j game_over_col_loop

game_over_row_inc:
    addi $t1, $t1, 1              # Increment row index
    j game_over_loop

game_over_not_done:
    li $v0, 0                     # Return false (game not over)
    jr $ra

game_over_done:
    li $v0, 1                     # Return true (game over)
    jr $ra

