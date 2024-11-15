#timer.asm

.data
    # Data Section for messages
    congrats_message:   .asciiz "Congratulations! You completed the game in "
    seconds_message:    .asciiz " seconds."

.text
timer:
    # Get current time in milliseconds (endTime = current time)
    li   $v0, 30                 # System call for 'time' (returns time in seconds)
    syscall                      # Invoke the system call to get the current time in seconds
    mul  $t0, $v0, 1000          # Convert seconds to milliseconds (time * 1000)

    # Calculate the elapsed time (elapsed_time = endTime - startTime)
    sub  $t1, $t0, $a0           # $t1 = endTime - startTime (in milliseconds)

    # Convert milliseconds to seconds (elapsed_time / 1000)
    div  $t1, $t1, 1000          # Divide the elapsed time by 1000 to convert to seconds
    mflo $t1                     # Move the quotient (seconds) into $t1

    # Print the congratulatory message: "Congratulations! You completed the game in "
    la   $a0, congrats_message    # Load address of congratulatory message
    li   $v0, 4                  # System call to print string
    syscall

    # Print the elapsed time (in seconds)
    move $a0, $t1                # Move elapsed time (seconds) into $a0
    li   $v0, 1                  # System call to print integer
    syscall

    # Print the message " seconds."
    la   $a0, seconds_message    # Load address of " seconds."
    li   $v0, 4                  # System call to print string
    syscall

    # Exit the program
    li   $v0, 10                 # Exit system call
    syscall

