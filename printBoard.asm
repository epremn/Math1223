.data
    # Strings for printing
    boardHeader:    .asciiz "Current board:\n"
    rowSeparator:   .asciiz " +---+---+---+---+\n"
    separator:      .asciiz " | "
    questionMark:   .asciiz "? "
    boardFooter:    .asciiz "\n +---+---+---+---+\n"
    SIZE:           .word 4                # Example board size, adjust as needed
    revealed: .space 64         # 4x4 revealed grid, each cell 4 bytes (initialized to 0 for false)
    board: .space 64            # 4x4 board grid, each cell 4 bytes (16 cells in total)

.text
printBoard:
    # Load SIZE from memory
    lw   $t7, SIZE($zero)     # Load SIZE into $t7 for use in loops

    # Print board header
    li   $v0, 4               # Syscall for print string
    la   $a0, boardHeader     # Load address of board header string
    syscall                   # Print board header string

    # Loop through rows (i)
    li   $t0, 0               # Initialize i = 0 (row index)
loop_rows:
    bge  $t0, $t7, done       # If i >= SIZE, exit loop

    # Print row separator
    li   $v0, 4               # Syscall for print string
    la   $a0, rowSeparator    # Load address of row separator string
    syscall                   # Print row separator

    # Loop through columns (j)
    li   $t1, 0               # Initialize j = 0 (column index)
loop_columns:
    bge  $t1, $t7, next_row   # If j >= SIZE, go to next row

    # Calculate index of the current cell in revealed and board arrays
    mul  $t2, $t0, $t7        # t2 = i * SIZE (row start index)
    add  $t2, $t2, $t1        # t2 = i * SIZE + j (current cell index)

    # Load revealed[i][j] value (0 = hidden, 1 = revealed)
    lb   $t3, revealed($t2)   # Load revealed[i][j] into $t3

    # Check if the cell is revealed or hidden
    beq  $t3, $zero, print_hidden  # If not revealed, print "?"

    # Cell is revealed: Load value from board[i][j]
    mul  $t4, $t0, $t7        # t4 = i * SIZE (row start index)
    add  $t4, $t4, $t1        # t4 = i * SIZE + j (current cell index)
    lw   $t5, board($t4)      # Load board[i][j] value into $t5

    # Print revealed cell value (integer)
    li   $v0, 1               # Syscall for print integer
    move $a0, $t5             # Move board[i][j] value to $a0
    syscall                   # Print the integer

    # Print column separator
    j print_separator         # Jump to print column separator

print_hidden:
    # Print hidden value (question mark "?")
    li   $v0, 4               # Syscall for print string
    la   $a0, questionMark    # Load address of "?" string
    syscall                   # Print "?"

print_separator:
    # Print column separator "|"
    li   $v0, 4               # Syscall for print string
    la   $a0, separator       # Load address of column separator "|"
    syscall                   # Print column separator

    # Move to the next column
    addi $t1, $t1, 1          # Increment j (move to next column)
    j loop_columns            # Continue looping through columns

next_row:
    # Print row separator after each row
    li   $v0, 4               # Syscall for print string
    la   $a0, rowSeparator    # Load address of row separator string
    syscall                   # Print row separator

    # Move to the next row
    addi $t0, $t0, 1          # Increment i (move to next row)
    j loop_rows               # Continue looping through rows

done:
    # Print footer line for the board
    li   $v0, 4               # Syscall for print string
    la   $a0, boardFooter     # Load address of footer string
    syscall                   # Print footer string

    # Done with printing the board
    jr   $ra                  # Return from function

