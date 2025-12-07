# Quick Commands - Use These Now!

## Current Status

✅ Gazebo is running correctly  
❌ `python` command missing (only `python3` available)

## Workaround (Use Now - No Rebuild Needed!)

### Terminal 3 - ArduPilot
```bash
docker exec -it ap_nongps_container bash
cd /root/ardupilot
python3 Tools/autotest/sim_vehicle.py -D -v ArduCopter -f JSON --add-param-file=/root/ardupilot_gazebo_ap/config/gazebo-iris-gimbal-ngps.parm --console --map
```

### Terminal 4 - State Estimator
```bash
docker exec -it ap_nongps_container bash
cd /root/ap_nongps/src
python3 video_to_feature.py
```

## Camera Streaming Note

The camera command you ran in Terminal 2 worked! No output is normal. Check Terminal 1 (Gazebo) for confirmation message.

## Permanent Fix (Optional - Rebuild Later)

```bash
docker-compose down
docker-compose build
docker-compose up -d
```

After rebuild, you can use `python` instead of `python3`.

## Your Gazebo Output Analysis

✅ **Everything looks good!**
- Camera sensor initialized
- World loaded correctly
- libEGL warnings are **normal** (software rendering without GPU)

## Next Steps

1. **Keep Gazebo running** (Terminal 1)
2. **Run ArduPilot** with `python3` command above (Terminal 3)
3. **Run state estimator** with `python3` command above (Terminal 4)

You should see the simulation working!
