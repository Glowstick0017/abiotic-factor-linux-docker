# Build script for ARM64 version of Abiotic Factor Docker container (PowerShell)

Write-Host "Building Abiotic Factor Linux Docker container for ARM64..." -ForegroundColor Green

# Build the Docker image for ARM64 platform
docker buildx build --platform linux/arm64 -t abiotic-factor-linux-docker:arm64-latest .

if ($LASTEXITCODE -eq 0) {
    Write-Host "Build complete!" -ForegroundColor Green
    Write-Host "To run the container, use: docker-compose up -d" -ForegroundColor Yellow
    Write-Host "Make sure your docker-compose.yml uses the arm64-latest tag" -ForegroundColor Yellow
} else {
    Write-Host "Build failed!" -ForegroundColor Red
    exit 1
}
