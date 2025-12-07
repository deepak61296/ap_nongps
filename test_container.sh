#!/bin/bash

echo "=== Testing Docker Container ==="
echo ""

# Test 1: Dependencies
echo "Test 1: Python Dependencies"
docker exec ap_nongps_container python3 -c 'import cv2, numpy, pymavlink, matplotlib, gi; print("✅ All dependencies loaded")'
echo ""

# Test 2: Versions
echo "Test 2: Dependency Versions"
docker exec ap_nongps_container python3 -c 'import numpy, cv2; print(f"NumPy: {numpy.__version__}, OpenCV: {cv2.__version__}")'
echo ""

# Test 3: Gazebo
echo "Test 3: Gazebo Version"
docker exec ap_nongps_container gz sim --version
echo ""

# Test 4: ArduPilot
echo "Test 4: ArduPilot Installation"
docker exec ap_nongps_container bash -c "ls -la /root/ardupilot/Tools/autotest/sim_vehicle.py"
echo ""

# Test 5: Environment
echo "Test 5: Environment Variables"
docker exec ap_nongps_container bash -c 'echo "GZ_VERSION: $GZ_VERSION"'
docker exec ap_nongps_container bash -c 'echo "DISPLAY: $DISPLAY"'
echo ""

echo "=== Tests Complete ==="
echo ""
echo "To access container: docker exec -it ap_nongps_container bash"
