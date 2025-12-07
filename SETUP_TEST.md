# Complete Setup Test - Fresh System Simulation

This guide simulates setting up ap_nongps on a completely fresh system.

## Prerequisites

- Ubuntu 22.04 (or compatible Linux)
- Docker and Docker Compose installed
- X11 display server

## Complete Setup from Scratch

### 1. Clone Repository
```bash
git clone https://github.com/snktshrma/ap_nongps.git
cd ap_nongps
```

### 2. Run Full Setup Test
```bash
./full_setup_test.sh
```

This script will:
- Stop any existing containers
- Rebuild Docker image from scratch (10-15 minutes)
- Start the container
- Run all verification tests

### 3. Verify Setup
After the script completes, you should see:
```
✅ All tests passed!
```

## Running the Simulation

Follow the 4-terminal workflow in README.md:

**Terminal 1:**
```bash
docker exec -it ap_nongps_container bash
cd /root/ap_nongps
gz sim -v4 -r iris_runway_ngps.sdf
```

**Terminal 2:**
```bash
docker exec -it ap_nongps_container bash
gz topic -t /world/iris_runway/model/iris_with_gimbal/model/gimbal/link/pitch_link/sensor/camera/image/enable_streaming -m gz.msgs.Boolean -p 'data: 1'
```

**Terminal 3:**
```bash
docker exec -it ap_nongps_container bash
cd /root/ardupilot
sim_vehicle.py -D -v ArduCopter -f JSON --add-param-file=/root/ardupilot_gazebo_ap/config/gazebo-iris-gimbal-ngps.parm --console --map
```

**Terminal 4:**
```bash
docker exec -it ap_nongps_container bash
cd /root/ap_nongps/src
python video_to_feature.py
```

## Expected Results

- **Terminal 1**: Gazebo GUI opens, shows drone and runway
- **Terminal 2**: No output (normal)
- **Terminal 3**: ArduPilot console starts, may show X11 warnings (normal)
- **Terminal 4**: Shows "Heartbeat from system" and offset values

## Cleanup

```bash
docker-compose down
```

## Quick Test (Without Rebuild)

If container is already running:
```bash
./test_container.sh
```
