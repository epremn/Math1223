.data
    SIZE:           .word 4              # Board size (4x4 grid)
    promptCell1:    .asciiz "Enter the number of the first cell (1-16): "
    promptCell2:    .asciiz "Enter the number of the second cell (1-16): "
    notAMatch:      .asciiz "Not a match. Try again.\n"
    matchFound:     .asciiz "Match found!\n"
    invalidChoice:  .asciiz "Invalid choice, please select covered cells.\n"
    completionMsg:  .asciiz "Congratulations! You completed the game in "
    board_values: .space 64     # Space for 16 values (4x4 grid, each value is 4 bytes)
    revealed: .space 64         # 4x4 revealed grid, each cell 4 bytes (initialized to 0 for false)
    boardHeader:    .asciiz "Current board:\n"

.text
.globl main

main:
    # Initialize the board
    jal initializeBoard

    # Get start time
    li   $v0, 30             # Syscall for current time
    syscall
    move $s0, $v0            # Store start time in $s0 (startTime)

    # Print the current board
    jal printBoard

    # Prompt for the first cell
    li   $v0, 4
    la   $a0, promptCell1
    syscall
    li   $v0, 5              # Syscall for reading integer
    syscall
    sub  $a0, $v0, 1         # Adjust for 0-indexing

    # Load the board size into $t0
    lw   $t0, SIZE           # Load SIZE into $t0
    div  $a0, $t0            # Divide cell1 by SIZE
    mfhi $t1                 # Row1 = quotient (row index)
    mflo $t2                 # Col1 = remainder (column index)

    # Prompt for the second cell
    li   $v0, 4
    la   $a0, promptCell2
    syscall
    li   $v0, 5              # Syscall for reading integer
    syscall
    sub  $a0, $v0, 1         # Adjust for 0-indexing

    div  $a0, $t0            # Divide cell2 by SIZE
    mfhi $t3                 # Row2 = quotient (row index)
    mflo $t4                 # Col2 = remainder (column index)

    # Check if the selected cells are valid
    jal isValidChoice

    # Reveal the selected cells temporarily
    jal revealSelectedCells
    jal printBoard           # Print updated board

    # Get the end time
    li   $v0, 30             # Syscall for current time
    syscall
    move $s1, $v0            # Store end time in $s1 (endTime)

    # Display completion message
    li   $v0, 4
    la   $a0, completionMsg
    syscall

    # Calculate elapsed time (endTime - startTime) / 1000
    sub  $t9, $s1, $s0       # Elapsed time = endTime - startTime
    div  $t9, $t9, 1000      # Convert to seconds
    mflo $a0                 # Move result into $a0
    li   $v0, 1              # Syscall for printing integer
    syscall

    # Exit the program
    li   $v0, 10             # Syscall for exit
    syscall

# Initialize board with values
initializeBoard:
    lw $t0, SIZE($zero)         # $t0 = SIZE (e.g., 4)
    mul $t1, $t0, $t0           # $t1 = SIZE * SIZE (total number of cells)
    la $t2, board_values        # $t2 = address of board_values array
    li $t3, 1                   # $t3 = value to assign (start from 1)
    li $t4, 0                   # $t4 = index for iteration (starting from 0)

initializeLoop:
    bge $t4, $t1, initializeDone # If index >= SIZE * SIZE, done
    sw $t3, 0($t2)              # Store value in the board array
    addi $t2, $t2, 4            # Move to the next element in the array
    addi $t3, $t3, 1            # Increment value to store
    addi $t4, $t4, 1            # Increment index
    b initializeLoop            # Continue loop

initializeDone:
    jr $ra                      # Return from function

# Print the current board
printBoard:
    # Load SIZE from memory
    lw   $t7, SIZE($zero)     # Load SIZE into $t7 for use in loops

    # Print board header
    li   $v0, 4               # Syscall for print string
    la   $a0, boardHeader     # Load address of board header string
    syscall                   # Print board header string

    # Loop through rows (i)
    li   $t0, 0               # Initialize i = 0 (row index)

printRow:
    bge  $t0, $t7, printDone  # If row index >= SIZE, done
    li   $t1, 0               # Initialize j = 0 (column index)

printCell:
    bge  $t1, $t7, printNextRow  # If column index >= SIZE, next row
    # Calculate the memory offset for the current cell
    mul  $t2, $t0, $t7          # $t2 = row index * SIZE (row offset)
    mul  $t3, $t1, 4            # $t3 = column index * 4 (column offset)
    add  $t4, $t2, $t3          # $t4 = total offset

    # Load the base address of board_values into $t5
    la   $t5, board_values      # Load the base address of board_values
    add  $t6, $t5, $t4          # $t6 = base address + offset

    # Load the value from the board array at the computed address
    lw   $a0, 0($t6)            # Load value from board_values at the computed address

    # Print the cell value
    li   $v0, 1               # Syscall for printing integer
    syscall

    addi $t1, $t1, 1           # Increment column index
    b printCell                # Continue printing cells

printNextRow:
    addi $t0, $t0, 1           # Increment row index
    b printRow                 # Print next row

printDone:
    jr $ra                     # Return from function

# Check if selected cells are valid
isValidChoice:
    # Here you would implement the logic to check if the selected cells are valid
    # e.g., if both cells are within bounds and not previously revealed
    li $v0, 4                  # Syscall for printing a message
    la $a0, isValidChoice
    syscall
    jr $ra

# Reveal selected cells (temporarily, for the game logic)
revealSelectedCells:
    # You would mark the selected cells as "revealed" in the 'revealed' array here
    # For now, this is a placeholder
    jr $ra

