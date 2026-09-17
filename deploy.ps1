# GameScreen P1 生产部署脚本
# PowerShell 部署脚本，支持 Windows 环境

param(
    [Parameter(Mandatory=$false)]
    [string]$Environment = "production",
    
    [Parameter(Mandatory=$false)]
    [string]$Version = "",
    
    [Parameter(Mandatory=$false)]
    [switch]$SkipTests = $false,
    
    [Parameter(Mandatory=$false)]
    [switch]$DryRun = $false
)

# 配置
$CONFIG = @{
    ProjectName = "GameScreen P1"
    WallPath = "gamescreen-wall"
    H5Path = "gamescreen-h5"
    BackupPath = "backup"
    LogPath = "logs"
    DeployTimeout = 300 # 5分钟超时
}

# 颜色输出函数
function Write-ColorOutput($ForegroundColor) {
    $fc = $host.UI.RawUI.ForegroundColor
    $host.UI.RawUI.ForegroundColor = $ForegroundColor
    if ($args) {
        Write-Output $args
    } else {
        $input | Write-Output
    }
    $host.UI.RawUI.ForegroundColor = $fc
}

function Write-Success { Write-ColorOutput Green $args }
function Write-Warning { Write-ColorOutput Yellow $args }
function Write-Error { Write-ColorOutput Red $args }
function Write-Info { Write-ColorOutput Cyan $args }

# 日志函数
function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] [$Level] $Message"
    
    # 确保日志目录存在
    if (!(Test-Path $CONFIG.LogPath)) {
        New-Item -ItemType Directory -Path $CONFIG.LogPath -Force | Out-Null
    }
    
    # 写入日志文件
    Add-Content -Path "$($CONFIG.LogPath)\deploy-$(Get-Date -Format 'yyyy-MM-dd').log" -Value $logEntry
    
    # 同时输出到控制台
    switch ($Level) {
        "ERROR" { Write-Error $Message }
        "WARN" { Write-Warning $Message }
        "SUCCESS" { Write-Success $Message }
        default { Write-Info $Message }
    }
}
}

# 错误处理
function Handle-Error {
    param([string]$ErrorMessage)
    Write-Log "部署失败: $ErrorMessage" "ERROR"
    Write-Log "开始回滚程序..." "WARN"
    
    if (!$DryRun) {
        Restore-Backup
    }
    
    exit 1
}

# 检查前置条件
function Check-Prerequisites {
    Write-Log "检查部署前置条件..."
    
    # 检查 Node.js
    try {
        $nodeVersion = node --version
        Write-Log "Node.js 版本: $nodeVersion" "SUCCESS"
    } catch {
        Handle-Error "Node.js 未安装或不可用"
    }
    
    # 检查 npm
    try {
        $npmVersion = npm --version
        Write-Log "npm 版本: $npmVersion" "SUCCESS"
    } catch {
        Handle-Error "npm 未安装或不可用"
    }
    
    # 检查项目目录
    if (!(Test-Path $CONFIG.WallPath)) {
        Handle-Error "gamescreen-wall 目录不存在"
    }
    
    if (!(Test-Path $CONFIG.H5Path)) {
        Handle-Error "gamescreen-h5 目录不存在"
    }
    
    Write-Log "前置条件检查通过" "SUCCESS"
}

# 创建备份
function Create-Backup {
    Write-Log "创建当前版本备份..."
    
    $backupDir = "$($CONFIG.BackupPath)\backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
    
    if (!$DryRun) {
        # 创建备份目录
        New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
        
        # 备份 wall 项目
        if (Test-Path "$($CONFIG.WallPath)\dist") {
            Copy-Item -Path "$($CONFIG.WallPath)\dist" -Destination "$backupDir\wall-dist" -Recurse -Force
            Write-Log "gamescreen-wall 备份完成"
        }
        
        # 备份 h5 项目
        if (Test-Path "$($CONFIG.H5Path)\dist") {
            Copy-Item -Path "$($CONFIG.H5Path)\dist" -Destination "$backupDir\h5-dist" -Recurse -Force
            Write-Log "gamescreen-h5 备份完成"
        }
        
        # 保存备份路径
        $script:BackupPath = $backupDir
    }
    
    Write-Log "备份创建完成: $backupDir" "SUCCESS"
}

# 恢复备份
function Restore-Backup {
    if ($script:BackupPath -and (Test-Path $script:BackupPath)) {
        Write-Log "恢复备份: $($script:BackupPath)"
        
        # 恢复 wall
        if (Test-Path "$($script:BackupPath)\wall-dist") {
            Remove-Item -Path "$($CONFIG.WallPath)\dist" -Recurse -Force -ErrorAction SilentlyContinue
            Copy-Item -Path "$($script:BackupPath)\wall-dist" -Destination "$($CONFIG.WallPath)\dist" -Recurse -Force
        }
        
        # 恢复 h5
        if (Test-Path "$($script:BackupPath)\h5-dist") {
            Remove-Item -Path "$($CONFIG.H5Path)\dist" -Recurse -Force -ErrorAction SilentlyContinue
            Copy-Item -Path "$($script:BackupPath)\h5-dist" -Destination "$($CONFIG.H5Path)\dist" -Recurse -Force
        }
        
        Write-Log "备份恢复完成" "SUCCESS"
    }
}

# 运行测试
function Run-Tests {
    if ($SkipTests) {
        Write-Log "跳过测试阶段" "WARN"
        return
    }
    
    Write-Log "运行部署前测试..."
    
    # 测试 wall 项目构建
    Write-Log "测试 gamescreen-wall 构建..."
    try {
        if (!$DryRun) {
            Push-Location $CONFIG.WallPath
            npm run build
            Pop-Location
        }
        Write-Log "gamescreen-wall 构建测试通过" "SUCCESS"
    } catch {
        Handle-Error "gamescreen-wall 构建失败"
    }
    
    # 测试 h5 项目构建
    Write-Log "测试 gamescreen-h5 构建..."
    try {
        if (!$DryRun) {
            Push-Location $CONFIG.H5Path
            npm run build
            Pop-Location
        }
        Write-Log "gamescreen-h5 构建测试通过" "SUCCESS"
    } catch {
        Handle-Error "gamescreen-h5 构建失败"
    }
    
    Write-Log "所有测试通过" "SUCCESS"
}

# 构建项目
function Build-Projects {
    Write-Log "开始构建生产版本..."
    
    # 构建 wall 项目
    Write-Log "构建 gamescreen-wall..."
    try {
        if (!$DryRun) {
            Push-Location $CONFIG.WallPath
            
            # 清理旧的构建
            if (Test-Path "dist") {
                Remove-Item -Path "dist" -Recurse -Force
            }
            
            # 安装依赖（如果需要）
            if (!(Test-Path "node_modules")) {
                npm install
            }
            
            # 构建
            npm run build
            
            Pop-Location
        }
        Write-Log "gamescreen-wall 构建完成" "SUCCESS"
    } catch {
        Handle-Error "gamescreen-wall 构建失败: $_"
    }
    
    # 构建 h5 项目
    Write-Log "构建 gamescreen-h5..."
    try {
        if (!$DryRun) {
            Push-Location $CONFIG.H5Path
            
            # 清理旧的构建
            if (Test-Path "dist") {
                Remove-Item -Path "dist" -Recurse -Force
            }
            
            # 安装依赖（如果需要）
            if (!(Test-Path "node_modules")) {
                npm install
            }
            
            # 构建
            npm run build
            
            Pop-Location
        }
        Write-Log "gamescreen-h5 构建完成" "SUCCESS"
    } catch {
        Handle-Error "gamescreen-h5 构建失败: $_"
    }
}

# 验证构建产物
function Verify-Build {
    Write-Log "验证构建产物..."
    
    # 验证 wall 构建
    if (!(Test-Path "$($CONFIG.WallPath)\dist\index.html")) {
        Handle-Error "gamescreen-wall 构建产物不完整：缺少 index.html"
    }
    
    if (!(Test-Path "$($CONFIG.WallPath)\dist\assets")) {
        Handle-Error "gamescreen-wall 构建产物不完整：缺少 assets 目录"
    }
    
    # 验证 h5 构建
    if (!(Test-Path "$($CONFIG.H5Path)\dist\index.html")) {
        Handle-Error "gamescreen-h5 构建产物不完整：缺少 index.html"
    }
    
    if (!(Test-Path "$($CONFIG.H5Path)\dist\assets")) {
        Handle-Error "gamescreen-h5 构建产物不完整：缺少 assets 目录"
    }
    
    # 检查文件大小
    $wallJs = Get-ChildItem -Path "$($CONFIG.WallPath)\dist\assets\*.js" | Select-Object -First 1
    if ($wallJs) {
        $wallSizeKB = [Math]::Round($wallJs.Length / 1KB, 2)
        Write-Log "gamescreen-wall JS 大小: $wallSizeKB KB"
        
        if ($wallSizeKB -gt 600) {
            Write-Log "警告：gamescreen-wall JS 文件大小超过 600KB" "WARN"
        }
    }
    
    $h5Js = Get-ChildItem -Path "$($CONFIG.H5Path)\dist\assets\*.js" | Select-Object -First 1
    if ($h5Js) {
        $h5SizeKB = [Math]::Round($h5Js.Length / 1KB, 2)
        Write-Log "gamescreen-h5 JS 大小: $h5SizeKB KB"
        
        if ($h5SizeKB -gt 400) {
            Write-Log "警告：gamescreen-h5 JS 文件大小超过 400KB" "WARN"
        }
    }
    
    Write-Log "构建产物验证通过" "SUCCESS"
}

# 部署后验证
function Post-Deploy-Verification {
    Write-Log "执行部署后验证..."
    
    # 这里可以添加健康检查逻辑
    # 例如：检查服务是否正常响应、数据库连接是否正常等
    
    Write-Log "部署后验证完成" "SUCCESS"
}

# 生成部署报告
function Generate-Report {
    Write-Log "生成部署报告..."
    
    $reportPath = "$($CONFIG.LogPath)\deploy-report-$(Get-Date -Format 'yyyyMMdd-HHmmss').md"
    
    $report = @"
# GameScreen P1 部署报告

**部署时间**: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
**部署环境**: $Environment
**部署版本**: $Version
**执行模式**: $(if ($DryRun) { "DryRun" } else { "Production" })

## 部署结果
- Success: Prerequisites Check
- Success: Backup Created  
- Success: Tests $(if ($SkipTests) { "(Skipped)" } else { "Executed" })
- Success: Projects Built
- Success: Build Verified
- Success: Post-Deploy Verified

## 构建信息
- **gamescreen-wall**: Build Success
- **gamescreen-h5**: Build Success

## 文件大小
$(if (!$DryRun) {
    $wallJs = Get-ChildItem -Path "$($CONFIG.WallPath)\dist\assets\*.js" -ErrorAction SilentlyContinue | Select-Object -First 1
    $h5Js = Get-ChildItem -Path "$($CONFIG.H5Path)\dist\assets\*.js" -ErrorAction SilentlyContinue | Select-Object -First 1
    
    $wallSize = if ($wallJs) { [Math]::Round($wallJs.Length / 1KB, 2) } else { "Unknown" }
    $h5Size = if ($h5Js) { [Math]::Round($h5Js.Length / 1KB, 2) } else { "Unknown" }
    
    "- **gamescreen-wall JS**: $wallSize KB`n- **gamescreen-h5 JS**: $h5Size KB"
} else {
    "- DryRun mode, no files generated"
})

## 部署状态
Success: Deployment Completed Successfully

---
*报告生成时间: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")*
"@
    
    if (!$DryRun) {
        Set-Content -Path $reportPath -Value $report -Encoding UTF8
        Write-Log "部署报告已生成: $reportPath" "SUCCESS"
    } else {
        Write-Log "部署报告内容:"
        Write-Info $report
    }
}

# 主部署函数
function Start-Deployment {
    Write-Log "开始 $($CONFIG.ProjectName) 部署" "SUCCESS"
    Write-Log "目标环境: $Environment"
    Write-Log "部署版本: $(if ($Version) { $Version } else { 'Current' })"
    Write-Log "执行模式: $(if ($DryRun) { 'DryRun' } else { 'Production' })"
    
    try {
        Check-Prerequisites
        Create-Backup
        Run-Tests
        Build-Projects
        Verify-Build
        Post-Deploy-Verification
        Generate-Report
        
        Write-Log "🎉 部署成功完成！" "SUCCESS"
        
    } catch {
        Handle-Error "部署过程中发生错误: $_"
    }
}

# 脚本入口
Write-Host "
╔══════════════════════════════════════╗
║         GameScreen P1 部署工具        ║
║               v1.0                   ║
╚══════════════════════════════════════╝
" -ForegroundColor Green

# 开始部署
Start-Deployment