# Docker Fix - ArduPilot Build Error

## Issues Found

### 1. ArduPilot Compilation Error
```
error: no matching function for call to 'CanardInterface::accept_message(uint16_t&, uint64_t&)'
```

**Cause**: Copter-4.5 has a DroneCAN compilation issue.

**Fix**: Switched to stable Copter-4.3 version.

### 2. Missing Python Modules
**Fix**: Added MAVProxy, pexpect, future, and empy to Dockerfile.

### 3. Gazebo Warnings
The libEGL warnings are **normal** when running without GPU acceleration:
```
libEGL warning: egl: failed to create dri2 screen
```

This is expected with software rendering. Gazebo will still work, just slower.

## Updated Dockerfile

Changes made:
- ✅ Use Copter-4.3 (stable) instead of Copter-4.5
- ✅ Added MAVProxy and dependencies
- ✅ Added pexpect, future, empy

## Rebuild Instructions

```bash
cd ~/ap_nongps

# Stop current container
docker-compose down

# Rebuild with fixes (10-15 minutes)
docker-compose build

# Start container
xhost +local:docker
docker-compose up -d

# Test
./test_container.sh
```

## Test Commands

Once rebuilt, test ArduPilot:

```bash
# Access container
docker exec -it ap_nongps_container bash

# Test sim_vehicle.py
cd /root/ardupilot
sim_vehicle.py --help
```

Should show help output without errors.

## Full Simulation Test

**Terminal 1 - Gazebo:**
```bash
docker exec -it ap_nongps_container bash
cd /root/ap_nongps
gz sim -v4 -r iris_runway_ngps.sdf
```

**Terminal 2 - Camera:**
```bash
docker exec -it ap_nongps_container bash
gz topic -t /world/iris_runway/model/iris_with_gimbal/model/gimbal/link/pitch_link/sensor/camera/image/enable_streaming -m gz.msgs.Boolean -p 'data: 1'
```

**Terminal 3 - ArduPilot:**
```bash
docker exec -it ap_nongps_container bash
cd /root/ardupilot
sim_vehicle.py -D -v ArduCopter -f JSON --add-param-file=/root/ardupilot_gazebo_ap/config/gazebo-iris-gimbal-ngps.parm --console --map
```

**Terminal 4 - State Estimator:**
```bash
docker exec -it ap_nongps_container bash
cd /root/ap_nongps/src
python video_to_feature.py
```

## Expected Results

- ✅ Gazebo opens (warnings are OK)
- ✅ Camera streaming starts
- ✅ ArduPilot builds and connects
- ✅ State estimator runs
