# Enable SPAS QB AI with DeepSeek for the current PowerShell session.
# Usage:
#   . .\scripts\enable-qb-ai-deepseek.ps1
#   $env:SPAS_QB_AI_API_KEY = "sk-..."   # set your key; do not commit
#   # then start backend as usual (e.g. mvn -pl ruoyi-admin spring-boot:run)

$ErrorActionPreference = "Stop"

$env:SPAS_QB_AI_ENABLED = "true"
if (-not $env:SPAS_QB_AI_ENDPOINT) {
    $env:SPAS_QB_AI_ENDPOINT = "https://api.deepseek.com/v1/chat/completions"
}
if (-not $env:SPAS_QB_AI_MODEL) {
    $env:SPAS_QB_AI_MODEL = "deepseek-chat"
}

Write-Host "Prefer UI: System -> LLM config (sys_config). Env below is optional override path."
Write-Host "SPAS QB AI -> DeepSeek"
Write-Host ("  ENABLED  = {0}" -f $env:SPAS_QB_AI_ENABLED)
Write-Host ("  ENDPOINT = {0}" -f $env:SPAS_QB_AI_ENDPOINT)
Write-Host ("  MODEL    = {0}" -f $env:SPAS_QB_AI_MODEL)
if ([string]::IsNullOrWhiteSpace($env:SPAS_QB_AI_API_KEY)) {
    Write-Host "  API_KEY  = (empty)  set: `$env:SPAS_QB_AI_API_KEY = 'sk-...'" -ForegroundColor Yellow
} else {
    Write-Host "  API_KEY  = (set)" -ForegroundColor Green
}
Write-Host "Note: non-empty sys_config values override env. Restart backend after code deploy; UI save needs no restart."
