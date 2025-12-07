# Quick Fix for Python Command

## Issue
```
/usr/bin/env: 'python': No such file or directory
```

ArduPilot's `sim_vehicle.py` uses `#!/usr/bin/env python` but container only has `python3`.

## Fix Applied

Added `python-is-python3` package to Dockerfile to create `python` symlink.

## Rebuild

```bash
cd ~/ap_nongps
docker-compose down
docker-compose build
docker-compose up -d
```

## Test After Rebuild

```bash
docker exec -it ap_nongps_container python --version
docker exec -it ap_nongps_container bash -c 'cd /root/ardupilot && sim_vehicle.py --help'
```

Should work without errors.

## Gazebo Status

Terminal 1 output looks **GOOD**! Gazebo is running correctly:
- ✅ Camera sensor initialized
- ✅ World loaded
- ⚠️ libEGL warnings are normal (software rendering)

## Camera Streaming

Terminal 2 - the command ran but showed no output. This is **normal** if streaming started successfully. Check Terminal 1 for:
```
[Msg] GstCameraPlugin:: streaming: started
```

If you don't see it, the camera might already be streaming or needs Gazebo to fully load first.

## Python Command Fix

Terminal 4 - You typed `docker` inside the container. You're already inside! Just use:
```bash
python3 video_to_feature.py
```

Or after rebuild with the fix:
```bash
python video_to_feature.py
```
