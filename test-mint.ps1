# Test Mintlify dev server startup
Write-Host "Starting Mintlify dev server..." -ForegroundColor Green

# Start mint dev in the background
$job = Start-Job -ScriptBlock {
    Set-Location "D:\Alexey\threeJS journey\DEV-CRYPTO\card project\docs"
    mint dev 2>&1
}

# Wait a bit for startup
Start-Sleep -Seconds 10

# Check if the job is running
$jobState = Get-Job -Id $job.Id | Select-Object -ExpandProperty State
Write-Host "Mint dev job state: $jobState" -ForegroundColor Yellow

if ($jobState -eq "Running") {
    Write-Host "✅ Mintlify dev server started successfully!" -ForegroundColor Green
    Write-Host "🌐 Documentation should be available at: http://localhost:3000" -ForegroundColor Cyan
    Write-Host "📚 Your API Reference should now be visible as a tab" -ForegroundColor Cyan
    
    # Get some output from the job
    $output = Receive-Job -Id $job.Id -Keep
    if ($output) {
        Write-Host "`nServer output:" -ForegroundColor Yellow
        Write-Host $output
    }
} else {
    Write-Host "❌ Failed to start Mintlify dev server" -ForegroundColor Red
    $error = Receive-Job -Id $job.Id
    if ($error) {
        Write-Host "Error output:" -ForegroundColor Red
        Write-Host $error
    }
}

# Clean up
Write-Host "`nTo stop the server later, run: Stop-Job -Id $($job.Id); Remove-Job -Id $($job.Id)" -ForegroundColor Gray