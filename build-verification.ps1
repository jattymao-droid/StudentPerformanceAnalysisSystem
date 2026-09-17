# GameScreen 构建验证脚本
Write-Host "======================================" -ForegroundColor Green
Write-Host "GameScreen P1 构建验证" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Green

$success = $true
$results = @()

# 验证 gamescreen-wall
Write-Host "`n检查 gamescreen-wall..." -ForegroundColor Yellow

if (Test-Path "gamescreen-wall") {
    Push-Location "gamescreen-wall"
    
    try {
        Write-Host "执行构建..." -ForegroundColor Cyan
        npm run build 2>&1 | Out-Null
        
        if (Test-Path "dist\index.html") {
            $jsFiles = Get-ChildItem -Path "dist\assets\*.js" -ErrorAction SilentlyContinue
            if ($jsFiles) {
                $jsSize = [Math]::Round($jsFiles[0].Length / 1KB, 2)
                Write-Host "Success: gamescreen-wall build completed" -ForegroundColor Green
                Write-Host "   JS 文件大小: $jsSize KB" -ForegroundColor Gray
                $results += "gamescreen-wall: Success ($jsSize" + " KB)"
            } else {
                Write-Host "❌ gamescreen-wall JS 文件缺失" -ForegroundColor Red
                $success = $false
                $results += "gamescreen-wall: ❌ (JS缺失)"
            }
        } else {
            Write-Host "❌ gamescreen-wall index.html 缺失" -ForegroundColor Red
            $success = $false
            $results += "gamescreen-wall: ❌ (HTML缺失)"
        }
    } catch {
        Write-Host "❌ gamescreen-wall 构建失败: $_" -ForegroundColor Red
        $success = $false
        $results += "gamescreen-wall: ❌ (构建失败)"
    }
    
    Pop-Location
} else {
    Write-Host "❌ gamescreen-wall 目录不存在" -ForegroundColor Red
    $success = $false
    $results += "gamescreen-wall: ❌ (目录不存在)"
}

# 验证 gamescreen-h5
Write-Host "`n检查 gamescreen-h5..." -ForegroundColor Yellow

if (Test-Path "gamescreen-h5") {
    Push-Location "gamescreen-h5"
    
    try {
        Write-Host "执行构建..." -ForegroundColor Cyan
        npm run build 2>&1 | Out-Null
        
        if (Test-Path "dist\index.html") {
            $jsFiles = Get-ChildItem -Path "dist\assets\*.js" -ErrorAction SilentlyContinue
            if ($jsFiles) {
                $jsSize = [Math]::Round($jsFiles[0].Length / 1KB, 2)
                Write-Host "Success: gamescreen-h5 build completed" -ForegroundColor Green
                Write-Host "   JS 文件大小: $jsSize KB" -ForegroundColor Gray
                $results += "gamescreen-h5: Success ($jsSize" + " KB)"
            } else {
                Write-Host "❌ gamescreen-h5 JS 文件缺失" -ForegroundColor Red
                $success = $false
                $results += "gamescreen-h5: ❌ (JS缺失)"
            }
        } else {
            Write-Host "❌ gamescreen-h5 index.html 缺失" -ForegroundColor Red
            $success = $false
            $results += "gamescreen-h5: ❌ (HTML缺失)"
        }
    } catch {
        Write-Host "❌ gamescreen-h5 构建失败: $_" -ForegroundColor Red
        $success = $false
        $results += "gamescreen-h5: ❌ (构建失败)"
    }
    
    Pop-Location
} else {
    Write-Host "❌ gamescreen-h5 目录不存在" -ForegroundColor Red
    $success = $false
    $results += "gamescreen-h5: ❌ (目录不存在)"
}

# 输出总结
Write-Host "`n======================================" -ForegroundColor Blue
Write-Host "构建验证结果" -ForegroundColor Blue
Write-Host "======================================" -ForegroundColor Blue

foreach ($result in $results) {
    Write-Host $result
}

if ($success) {
    Write-Host "`n🎉 所有构建验证通过！" -ForegroundColor Green
    Write-Host "项目已准备好进行生产部署。" -ForegroundColor Green
    exit 0
} else {
    Write-Host "`n❌ 构建验证失败！" -ForegroundColor Red
    Write-Host "请修复上述问题后重新验证。" -ForegroundColor Red
    exit 1
}