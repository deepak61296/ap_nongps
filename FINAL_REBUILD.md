# Final Docker Rebuild - All Issues Fixed

## Issues Found

### 1. Python Command Missing
**Error**: `/usr/bin/env: 'python': No such file or directory`  
**Fix**: Added `python-is-python3` package

### 2. NumPy/OpenCV Typing Error
**Error**: `TypeError: 'numpy._DTypeMeta' object is not subscriptable`  
**Cause**: NumPy 1.26.4 has typing incompatibility with OpenCV 4.8.1  
**Fix**: Use NumPy 1.21-1.24 range

### 3. WAF Build Tool Needs Python
**Error**: WAF (ArduPilot build tool) also needs `python` command  
**Fix**: Same as #1

## Complete Rebuild Required

**You MUST rebuild the container. The workaround won't work.**

```bash
cd ~/ap_nongps

# Stop container
docker-compose down

# Rebuild (10-15 minutes)
docker-compose build

# Start
xhost +local:docker
docker-compose up -d

# Test
./test_container.sh
```

## After Rebuild - Test Commands

### Terminal 1 - Gazebo (already working)
```bash
docker exec -it ap_nongps_container bash
cd /root/ap_nongps
gz sim -v4 -r iris_runway_ngps.sdf
```

### Terminal 2 - Camera
```bash
docker exec -it ap_nongps_container bash
gz topic -t /world/iris_runway/model/iris_with_gimbal/model/gimbal/link/pitch_link/sensor/camera/image/enable_streaming -m gz.msgs.Boolean -p 'data: 1'
```

### Terminal 3 - ArduPilot
```bash
docker exec -it ap_nongps_container bash
cd /root/ardupilot
sim_vehicle.py -D -v ArduCopter -f JSON --add-param-file=/root/ardupilot_gazebo_ap/config/gazebo-iris-gimbal-ngps.parm --console --map
```

### Terminal 4 - State Estimator
```bash
docker exec -it ap_nongps_container bash
cd /root/ap_nongps/src
python video_to_feature.py
```

## What Was Fixed in Dockerfile

1. ✅ Added `python-is-python3` package
2. ✅ Changed NumPy version to `>=1.21.0,<1.25.0` (compatible with OpenCV)
3. ✅ Using ArduPilot Copter-4.3 (stable)
4. ✅ Added all required Python packages (MAVProxy, pexpect, etc.)

## Important Notes

- **Don't type `docker` commands inside the container** - you're already inside!
- **Rebuild is mandatory** - workarounds won't work for this issue
- **Build time**: 10-15 minutes
- **Gazebo warnings are normal** (libEGL - software rendering)

## Expected Test Results

After rebuild, `./test_container.sh` should show:
- ✅ All dependencies loaded
- ✅ NumPy: 1.24.x, OpenCV: 4.8.1
- ✅ Gazebo version
- ✅ ArduPilot sim_vehicle.py found
- ✅ Environment variables set
