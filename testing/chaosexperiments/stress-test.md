# https://chaos-mesh.org/blog/how-to-efficiently-stress-test-pod-memory/
Start a busybox pod
run 
    - free -m 
    - top

To get the cgrouped memory usage, enter:

cat /sys/fs/cgroup/memory.current

The output is in bytes, so divide it by 1024 * 1024

To see if the pod gets oomkilled, describe the pod. If the pod gets killed, the mem stress is gone.

stress-ng will only allocate the total memory given, as it will split it evenly across the workers. So having more workers does not yield to more memory stress

