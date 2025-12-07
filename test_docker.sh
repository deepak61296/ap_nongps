#!/bin/bash

echo "=== Docker Setup Test Script ==="
echo ""

# Test 1: Check Docker
echo "1. Checking Docker installation..."
if command -v docker &> /dev/null; then
    docker --version
    echo "✓ Docker is installed"
else
    echo "✗ Docker is not installed"
    exit 1
fi
echo ""

# Test 2: Check Docker Compose
echo "2. Checking Docker Compose installation..."
if command -v docker-compose &> /dev/null; then
    docker-compose --version
    echo "✓ Docker Compose is installed"
else
    echo "✗ Docker Compose is not installed"
    echo "Install with: sudo apt-get install docker-compose"
    exit 1
fi
echo ""

# Test 3: Enable X11 forwarding
echo "3. Enabling X11 forwarding..."
xhost +local:docker
echo "✓ X11 forwarding enabled"
echo ""

# Test 4: Build Docker image
echo "4. Building Docker image (this may take 10-15 minutes)..."
docker-compose build
if [ $? -eq 0 ]; then
    echo "✓ Docker image built successfully"
else
    echo "✗ Docker build failed"
    exit 1
fi
echo ""

# Test 5: Start container
echo "5. Starting container..."
docker-compose up -d
sleep 5
echo ""

# Test 6: Check if container is running
echo "6. Checking container status..."
if docker ps | grep -q ap_nongps_container; then
    echo "✓ Container is running"
else
    echo "✗ Container is not running"
    docker-compose logs
    exit 1
fi
echo ""

# Test 7: Test Python dependencies
echo "7. Testing Python dependencies..."
docker exec -it ap_nongps_container python3 -c "import cv2, numpy, pymavlink, matplotlib, gi; print('✓ All Python dependencies loaded')"
echo ""

# Test 8: Check versions
echo "8. Checking dependency versions..."
docker exec -it ap_nongps_container python3 -c "import numpy, cv2; print(f'NumPy: {numpy.__version__}, OpenCV: {cv2.__version__}')"
echo ""

# Test 9: Check Gazebo
echo "9. Checking Gazebo installation..."
docker exec -it ap_nongps_container gz sim --version
echo ""

# Test 10: Check environment variables
echo "10. Checking environment variables..."
docker exec -it ap_nongps_container bash -c "echo 'GZ_VERSION:' \$GZ_VERSION"
echo ""

echo "=== All tests passed! ==="
echo ""
echo "To access the container, run:"
echo "  docker exec -it ap_nongps_container bash"
echo ""
echo "To stop the container, run:"
echo "  docker-compose down"
