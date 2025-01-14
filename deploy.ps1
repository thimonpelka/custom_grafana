# Variables
$imageName = "custom-grafana"
$containerName = "custom-grafana-container"
$newVersionTag = "latest"

# Stop and remove the old container if it exists
$oldContainer = docker ps -a -q -f "name=$containerName"
if ($oldContainer) {
    Write-Output "Stopping and removing old container..."
    docker stop $containerName
    docker rm $containerName
}

# Build the new image
Write-Output "Building new Docker image..."
docker build -t "${imageName}:${newVersionTag}" .

# Run the new container
Write-Output "Running the new container..."
docker run -d --name $containerName -p 3000:3000 "${imageName}:${newVersionTag}"

# Get the old image ID (if it exists)
$oldImageId = docker images -q $imageName -f "before=${imageName}:${newVersionTag}"

# Remove the old image (optional)
if ($oldImageId) {
    Write-Output "Removing old Docker image..."
    docker rmi --force $oldImageId
}

Write-Output "Deployment complete."
