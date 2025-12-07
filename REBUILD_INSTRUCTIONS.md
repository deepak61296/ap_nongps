# Quick Rebuild and Test Instructions

## Issue Found
ArduPilot installation script doesn't work when run as root in Docker. Fixed by manually installing dependencies.

## Commands to Run

### 1. Rebuild Container (10-15 minutes)
```bash
cd ~/ap_nongps
docker-compose build
```

### 2. Start Container
```bash
xhost +local:docker
docker-compose up -d
```

### 3. Test Container
```bash
./test_container.sh
```

Expected: All tests should pass, including ArduPilot installation check.

### 4. Test Simulation

**Terminal 1 - Gazebo:**
```bash
docker exec -it ap_nongps_container bash
cd /root/ap_nongps
gz sim -v4 -r iris_runway_ngps.sdf
```

**Terminal 2 - Camera (after Gazebo loads):**
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

## What Was Fixed

- Removed `install-prereqs-ubuntu.sh` call (fails as root)
- Manually installed ArduPilot dependencies
- Simplified installation process

## Next Steps

Run the rebuild command above and test!
