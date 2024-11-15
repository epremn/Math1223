.data
    # Array to hold values that will be shuffled

.text
shuffleArray:
    # Input: $a0 = address of array
    #        $a1 = length of the array
    # Output: The array is shuffled in place

    sub $t0, $a1, 1            # $t0 = i = array.length - 1 (initialize loop variable)
shuffle_loop:
    blez $t0, done_shuffling   # If i <= 0, we're done shuffling

    # Generate random index j (random.nextInt(i + 1))
    addi $t1, $t0, 1           # $t1 = i + 1
    li $t2, 0x7FFFFFFF         # Load maximum random value (simulate random number)
    divu $t2, $t2, $t1         # $t2 = random_value / (i + 1)
    mfhi $t3                   # $t3 = remainder = random_value % (i + 1)

    # Set j = random_value % (i + 1)
    move $t4, $t3              # $t4 = j = random_value % (i + 1)

    # Swap array[i] and array[j]
    mul $t5, $t0, 4            # $t5 = i * 4 (byte offset for array[i])
    add $t6, $a0, $t5          # $t6 = address of array[i]
    lw $t7, 0($t6)             # Load array[i] into $t7

    mul $t8, $t4, 4            # $t8 = j * 4 (byte offset for array[j])
    add $t9, $a0, $t8          # $t9 = address of array[j]
    lw $t2, 0($t9)             # Load array[j] into $t2

    # Swap the elements
    sw $t2, 0($t6)             # Store array[j] at array[i]
    sw $t7, 0($t9)             # Store array[i] at array[j]

    # Decrement i (i--)
    sub $t0, $t0, 1            # i = i - 1
    j shuffle_loop             # Repeat the loop

done_shuffling:
    jr $ra                     # Return from function
