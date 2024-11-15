.data
    SIZE: .word 4               # Define SIZE (e.g., 4 for a 4x4 grid)
    board_values: .space 64     # Space for 16 values (4x4 grid, each value is 4 bytes)
    board: .space 64            # 4x4 board grid, each cell 4 bytes (16 cells in total)
    revealed: .space 64         # 4x4 revealed grid, each cell 4 bytes (initialized to 0 for false)
.text
initializeBoard:
    # Load SIZE into $t0
    lw $t0, SIZE($zero)         # $t0 = SIZE (e.g., 4)
    mul $t1, $t0, $t0           # $t1 = SIZE * SIZE (total number of cells)
    la $t2, board_values        # $t2 = address of board_values array
    li $t3, 1                   # $t3 = value to assign (start from 1)
    li $t4, 0                   # $t4 = index for iteration (starting from 0)

# Fill values in board_values array
fill_values:
    bge $t4, $t1, shuffle_values  # If index >= SIZE*SIZE, jump to shuffle step
    div $t4, $t0                   # Divide index by SIZE (quotient in LO, remainder in HI)
    mfhi $t5                       # $t5 = remainder (index % SIZE)
    addi $t5, $t5, 1               # $t5 = (index % SIZE) + 1 (values range from 1)
    sw $t5, 0($t2)                 # Store value into board_values array at current index
    addi $t2, $t2, 4               # Move to next element in board_values array
    addi $t4, $t4, 1               # Increment index
    j fill_values                  # Repeat until all values are filled

shuffle_values:
   j shuffleArray               # Call shuffle function to shuffle board values
    # Assuming shuffleArray is another function to randomize the values (you'll need to implement this)

    # Initialize board and revealed arrays
    lw $t0, SIZE($zero)            # Load SIZE from memory into $t0 (use lw instead of li)
    li $t6, 0                      # $t6 = index for board and revealed arrays

init_board:
    bge $t6, $t1, done_initializing  # If index >= SIZE*SIZE, finish initialization

    # Calculate row and column of the board based on the index
    div $t6, $t0                   # Divide index by SIZE to get row and column
    mfhi $t7                       # $t7 = row index
    mflo $t8                       # $t8 = column index

    # Calculate address of board[row][col]
    la $t9, board                  # $t9 = base address of board
    mul $t2, $t7, $t0              # $t2 = row * SIZE
    add $t2, $t2, $t8              # $t2 = row * SIZE + col
    sll $t2, $t2, 2                # Multiply index by 4 (word size) for proper offset
    add $t9, $t9, $t2              # Address of board[i][j]

    # Load the value from board_values and assign it to board[i][j]
    la $t4, board_values           # $t4 = base address of board_values
    lw $t5, 0($t4)                 # Load value from current position in board_values
    sw $t5, 0($t9)                 # Store value into board[i][j]

    # Initialize revealed[i][j] to false (0)
    la $t9, revealed               # $t9 = base address of revealed array
    add $t9, $t9, $t2              # Address of revealed[i][j]
    li $t5, 0                      # Set to false (0)
    sw $t5, 0($t9)                 # Store false in revealed[i][j]

    addi $t6, $t6, 1               # Increment index
    j init_board                   # Repeat for the next index

done_initializing:
    jr $ra                          # Return from function

shuffleArray:
    # Input: $a0 = address of array
    #        $a1 = length of the array
    # Output: The array is shuffled in place

    sub $t0, $a1, 1            # $t0 = i = array.length - 1 (initialize loop variable)        

