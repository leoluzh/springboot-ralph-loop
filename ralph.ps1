# Ralph Loop - Google Gemini CLI Version (Windows PowerShell)
# This script runs iterative AI-assisted development tasks using Gemini

param(
    [Parameter(Mandatory=$true)]
    [int]$Iterations
)

$ErrorActionPreference = "Stop"

# Function to display usage
function Show-Usage {
    Write-Host "Usage: .\ralph-gemini.ps1 -Iterations <number>"
    Write-Host "Example: .\ralph-gemini.ps1 -Iterations 5"
    exit 1
}

# Validate iterations parameter
if ($Iterations -le 0) {
    Show-Usage
}

# Check if gemini CLI is installed
$geminiCmd = Get-Command gemini -ErrorAction SilentlyContinue
if (-not $geminiCmd) {
    Write-Host "❌ Error: gemini CLI is not installed or not in PATH" -ForegroundColor Red
    Write-Host "Please install it first using: .\scripts\install-gemini-windows.ps1" -ForegroundColor Yellow
    exit 1
}

# Main loop
for ($i = 1; $i -le $Iterations; $i++) {
    Write-Host ""
    Write-Host "****************************************" -ForegroundColor Cyan
    Write-Host "Iteration $i of $Iterations" -ForegroundColor Cyan
    Write-Host "****************************************" -ForegroundColor Cyan

    # Read context files
    $claudeContext = ""
    $prdContext = ""
    $progressContext = ""

    if (Test-Path "CLAUDE.md") {
        $claudeContext = Get-Content "CLAUDE.md" -Raw
    }
    if (Test-Path "PRD.md") {
        $prdContext = Get-Content "PRD.md" -Raw
    }
    if (Test-Path "progress.txt") {
        $progressContext = Get-Content "progress.txt" -Raw
    }

    # Build the prompt for Gemini
    $prompt = @"
You are an expert software engineer helping with iterative development.

## Context Files

### CLAUDE.md
$claudeContext

### PRD.md
$prdContext

### progress.txt
$progressContext

## Task Instructions
1. Read progress.txt to see what has been completed.
2. Find the highest-priority incomplete task from PRD.md.
3. Implement that single task.
4. Write unit tests for any code with logic.
5. Verify: .\mvnw.cmd compile -q && .\mvnw.cmd test -q
6. If tests pass, git add and commit with a conventional commit message (feat:, fix:, test:, refactor:).
7. Mark the task complete in PRD.md (change [ ] to [x]).
8. Append your progress to progress.txt with what you completed.
9. If ALL tasks in PRD.md are complete, output <promise>COMPLETE</promise>.

IMPORTANT: ONLY WORK ON ONE TASK PER ITERATION.
"@

    # Execute Gemini command with the prompt
    try {
        $result = gemini -p $prompt
    }
    catch {
        Write-Host "❌ Error executing Gemini CLI:" -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Red
        exit 1
    }

    # Display result
    Write-Host $result

    # Check if all tasks are complete
    if ($result -like "*<promise>COMPLETE</promise>*") {
        Write-Host ""
        Write-Host "✅ PRD complete after $i iterations!" -ForegroundColor Green
        exit 0
    }
}

# If we reach here, we've hit the iteration limit
Write-Host ""
Write-Host "⚠️  Reached maximum iterations ($Iterations) without completing all tasks." -ForegroundColor Yellow
Write-Host "Run the script again with more iterations if needed." -ForegroundColor Yellow
exit 1

