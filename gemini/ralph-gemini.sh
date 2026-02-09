#!/bin/bash
set -e

# Valores padrão
APPROVAL_MODE="yolo"

# Parse dos argumentos
while [[ $# -gt 0 ]]; do
  case $1 in
    --approval-mode)
      APPROVAL_MODE="$2"
      shift 2
      ;;
    *)
      ITERATIONS="$1"
      shift
      ;;
  esac
done

if [ -z "$ITERATIONS" ]; then
  echo "Usage: $0 <iterations> [--approval-mode default|auto_edit|yolo|plan]"
  echo ""
  echo "Approval modes:"
  echo "  default    - Prompt for approval on each action"
  echo "  auto_edit  - Auto-approve edit tools only"
  echo "  yolo       - Auto-approve all tools (default)"
  echo "  plan       - Read-only mode, no tool execution"
  exit 1
fi

# Validar approval-mode
if [[ ! "$APPROVAL_MODE" =~ ^(default|auto_edit|yolo|plan)$ ]]; then
  echo "Error: Invalid approval-mode. Must be one of: default, auto_edit, yolo, plan"
  exit 1
fi

for ((i=1; i<=$ITERATIONS; i++)); do
  echo ""
  echo "****************************************"
  echo "Iteration $i of $ITERATIONS (mode: $APPROVAL_MODE)"
  echo "****************************************"

  # Criar prompt com referências explícitas aos arquivos
  prompt="Review the following files:
- CLAUDE.md (guidelines and context)
- PRD.md (product requirements document with tasks)
- progress.txt (completed work history)

Then execute these steps:
1. Read progress.txt to see what has been completed.
2. Find the highest-priority incomplete task from PRD.md.
3. Implement that single task.
4. Write unit tests for any code with logic.
5. Verify: ./mvnw compile -q && ./mvnw test -q
6. If tests pass, git add and commit with a conventional commit message (feat:, fix:, test:, refactor:).
7. Mark the task complete in PRD.md (change [ ] to [x]).
8. Append your progress to progress.txt with what you completed.
9. If ALL tasks in PRD.md are complete, output <promise>COMPLETE</promise>.

ONLY WORK ON ONE TASK PER ITERATION."

  # Executar Gemini CLI com approval-mode configurável
  result=$(gemini -p "$prompt" --approval-mode "$APPROVAL_MODE")

  echo "$result"

  if [[ "$result" == *"<promise>COMPLETE</promise>"* ]]; then
    echo ""
    echo "✅ PRD complete after $i iterations!"
    exit 0
  fi

  # Pequena pausa entre iterações para evitar rate limiting
  if [ $i -lt $ITERATIONS ]; then
    sleep 2
  fi
done

echo ""
echo "⚠️  Reached maximum iterations ($ITERATIONS) without completing all tasks."
echo "Run the script again with more iterations if needed."
exit 1