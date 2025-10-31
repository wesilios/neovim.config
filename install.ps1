# ============================================
# Neovim Configuration Installer for Windows
# ============================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Neovim Configuration Installer" -ForegroundColor Cyan
Write-Host "  Platform: Windows" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "Warning: Not running as Administrator. Some plugins may fail to install." -ForegroundColor Yellow
    Write-Host "Consider running PowerShell as Administrator for first-time setup." -ForegroundColor Yellow
    Write-Host ""
}

# Function to check if a command exists
function Test-Command {
    param($Command)
    $null -ne (Get-Command $Command -ErrorAction SilentlyContinue)
}

# Check prerequisites
Write-Host "Checking prerequisites..." -ForegroundColor Yellow

$missingPrereqs = @()

if (-not (Test-Command nvim)) {
    $missingPrereqs += "Neovim"
    Write-Host "[X] Neovim not found" -ForegroundColor Red
} else {
    $nvimVersion = (nvim --version | Select-Object -First 1)
    Write-Host "[OK] Neovim found: $nvimVersion" -ForegroundColor Green
}

if (-not (Test-Command git)) {
    $missingPrereqs += "Git"
    Write-Host "[X] Git not found" -ForegroundColor Red
} else {
    Write-Host "[OK] Git found" -ForegroundColor Green
}

if (-not (Test-Command node)) {
    $missingPrereqs += "Node.js"
    Write-Host "[X] Node.js not found" -ForegroundColor Red
} else {
    $nodeVersion = (node --version)
    Write-Host "[OK] Node.js found: $nodeVersion" -ForegroundColor Green
}

if (-not (Test-Command python)) {
    Write-Host "[!] Python not found (optional but recommended)" -ForegroundColor Yellow
} else {
    $pythonVersion = (python --version)
    Write-Host "[OK] Python found: $pythonVersion" -ForegroundColor Green
}

if ($missingPrereqs.Count -gt 0) {
    Write-Host ""
    Write-Host "Missing required prerequisites: $($missingPrereqs -join ', ')" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please install missing prerequisites:" -ForegroundColor Yellow
    Write-Host "  - Neovim: choco install neovim" -ForegroundColor White
    Write-Host "  - Git: choco install git" -ForegroundColor White
    Write-Host "  - Node.js: choco install nodejs" -ForegroundColor White
    Write-Host ""
    Write-Host "Or download manually from their official websites." -ForegroundColor White
    exit 1
}

Write-Host ""
Write-Host "Setting up Neovim configuration..." -ForegroundColor Yellow

$nvimConfigPath = "$env:LOCALAPPDATA\nvim"
$nvimDataPath = "$env:LOCALAPPDATA\nvim-data"

# Backup existing configuration
if (Test-Path $nvimConfigPath) {
    $backupPath = "$nvimConfigPath.backup.$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    Write-Host "Backing up existing configuration to: $backupPath" -ForegroundColor Yellow
    Move-Item -Path $nvimConfigPath -Destination $backupPath -Force
}

# Clone or copy configuration
$currentPath = $PSScriptRoot
if (Test-Path "$currentPath\.git") {
    Write-Host "Copying configuration from current directory..." -ForegroundColor Yellow
    Copy-Item -Path $currentPath -Destination $nvimConfigPath -Recurse -Force
} else {
    Write-Host "Cloning configuration from GitHub..." -ForegroundColor Yellow
    git clone https://github.com/wesilios/neovim.config $nvimConfigPath
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to clone repository" -ForegroundColor Red
        exit 1
    }
}

Write-Host "[OK] Configuration copied successfully" -ForegroundColor Green
Write-Host ""

# Install vim-plug
Write-Host "Installing vim-plug..." -ForegroundColor Yellow
$plugPath = "$nvimDataPath\site\autoload\plug.vim"
$plugDir = Split-Path -Parent $plugPath

if (-not (Test-Path $plugDir)) {
    New-Item -ItemType Directory -Path $plugDir -Force | Out-Null
}

try {
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" `
        -OutFile $plugPath -UseBasicParsing
    Write-Host "[OK] vim-plug installed successfully" -ForegroundColor Green
} catch {
    Write-Host "Failed to install vim-plug: $_" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Installing plugins..." -ForegroundColor Yellow
Write-Host "This may take a few minutes..." -ForegroundColor White

# Install plugins
nvim --headless +PlugInstall +qall

if ($LASTEXITCODE -eq 0) {
    Write-Host "[OK] Plugins installed successfully" -ForegroundColor Green
} else {
    Write-Host "[!] Plugin installation completed with warnings" -ForegroundColor Yellow
    Write-Host "You may need to run :PlugInstall manually in Neovim" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Installation Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. Open Neovim: nvim" -ForegroundColor White
Write-Host "  2. Check plugin status: :PlugStatus" -ForegroundColor White
Write-Host "  3. Check health: :checkhealth" -ForegroundColor White
Write-Host "  4. Install CoC extensions: :CocInstall coc-snippets coc-pairs" -ForegroundColor White
Write-Host ""
Write-Host "Optional language servers:" -ForegroundColor Yellow
Write-Host "  - JavaScript/TypeScript: npm install -g typescript typescript-language-server" -ForegroundColor White
Write-Host "  - Python: pip install python-language-server" -ForegroundColor White
Write-Host ""

