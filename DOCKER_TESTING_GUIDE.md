# Docker Container Testing Guide

## Current Status

The container is running but **ArduPilot is not installed yet**. You need to rebuild the Docker image with the updated Dockerfile.

## Step 1: Rebuild the Docker Image

```bash
# Stop the current container
docker-compose down

# Rebuild with ArduPilot (this will take 15-20 minutes)
docker-compose build

# Start the new container
xhost +local:docker
docker-compose up -d
```

## Step 2: Test the Container

```bash
./test_container.sh
```

Expected output:
- ✅ All dependencies loaded
- NumPy: 1.26.4, OpenCV: 4.8.1
- Gazebo version info
- ArduPilot sim_vehicle.py found
- Environment variables set

## Step 3: Run the Simulation

Use the helper script:
```bash
./run_simulation.sh
```

This will show you all the commands you need to run in separate terminals.

### Manual Steps:

**Terminal 1 - Gazebo:**
```bash
docker exec -it ap_nongps_container bash
cd /root/ap_nongps
gz sim -v4 -r iris_runway_ngps.sdf
```

**Terminal 2 - Camera Streaming (after Gazebo loads):**
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

## Troubleshooting

### Bash history expansion error with `!`
Use single quotes instead of double quotes:
```bash
python3 -c 'import cv2, numpy; print("OK")'
```

### xeyes doesn't show
```bash
# On host
xhost +local:docker
echo $DISPLAY

# In container
docker exec ap_nongps_container bash -c 'echo $DISPLAY'
```

### ArduPilot not found
You need to rebuild the Docker image (see Step 1 above).
