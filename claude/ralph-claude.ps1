# Ralph Loop - Windows PowerShell Version
# This script runs iterative AI-assisted development tasks

param(
    [Parameter(Mandatory=$true)]
    [int]$Iterations
)

$ErrorActionPreference = "Stop"

# Function to display usage
function Show-Usage {
    Write-Host "Usage: .\ralph.ps1 -Iterations <number>"
    Write-Host "Example: .\ralph.ps1 -Iterations 5"
    exit 1
}

# Validate iterations parameter
if ($Iterations -le 0) {
    Show-Usage
}

# Main loop
for ($i = 1; $i -le $Iterations; $i++) {
    Write-Host ""
    Write-Host "****************************************"
    Write-Host "Iteration $i of $Iterations"
    Write-Host "****************************************"

    # Build the prompt for Claude
    $prompt = @"
@CLAUDE.md @PRD.md @progress.txt
1. Read progress.txt to see what has been completed.
2. Find the highest-priority incomplete task from PRD.md.
3. Implement that single task.
4. Write unit tests for any code with logic.
5. Verify: .\mvnw.cmd compile -q && .\mvnw.cmd test -q
6. If tests pass, git add and commit with a conventional commit message (feat:, fix:, test:, refactor:).
7. Mark the task complete in PRD.md (change [ ] to [x]).
8. Append your progress to progress.txt with what you completed.
9. If ALL tasks in PRD.md are complete, output <promise>COMPLETE</promise>.
ONLY WORK ON ONE TASK PER ITERATION.
"@

    # Execute Claude command with the prompt
    $result = & claude --dangerously-skip-permissions -p $prompt

    # Display result
    Write-Host $result

    # Check if all tasks are complete
    if ($result -like "*<promise>COMPLETE</promise>*") {
        Write-Host ""
        Write-Host "✅ PRD complete after $i iterations!"
        exit 0
    }
}

# If we reach here, we've hit the iteration limit
Write-Host ""
Write-Host "⚠️  Reached maximum iterations ($Iterations) without completing all tasks."
Write-Host "Run the script again with more iterations if needed."
exit 1

