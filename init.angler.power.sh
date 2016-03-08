#!/system/bin/sh

################################################################################
# helper functions to allow Android init like script

function write() {
    echo -n $2 > $1
}

function copy() {
    cat $1 > $2
}

function get-set-forall() {
    for f in $1 ; do
        cat $f
        write $f $2
    done
}

################################################################################

# disable core control
chmod 0664 /sys/module/msm_thermal/core_control/enabled
write /sys/module/msm_thermal/core_control/enabled 0
# some files in /sys/devices/system/cpu are created after the restorecon of
# /sys/. These files receive the default label "sysfs".
# Restorecon again to give new files the correct label.
restorecon -R /sys/devices/system/cpu

# Thermal control
restorecon -R /sys/module/msm_thermal
chmod 0664 /sys/module/msm_thermal/parameters/enabled
write /sys/module/msm_thermal/parameters/enabled Y
write /sys/module/msm_thermal/parameters/limit_temp_degC 80

#LITTLE
write /sys/devices/system/cpu/cpu0/online 1
write /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor elementalx
restorecon -R /sys/devices/system/cpu
write /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq 302400
write /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq 1708800

write /sys/devices/system/cpu/cpu1/online 1
write /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor elementalx
restorecon -R /sys/devices/system/cpu
write /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq 302400
write /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq 1708800

write /sys/devices/system/cpu/cpu2/online 1
write /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor elementalx
restorecon -R /sys/devices/system/cpu
write /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq 302400
write /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq 1708800

write /sys/devices/system/cpu/cpu3/online 1
write /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor elementalx
restorecon -R /sys/devices/system/cpu
write /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq 302400
write /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq 1708800

#big.
write /sys/devices/system/cpu/cpu4/online 1
write /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor elementalx
restorecon -R /sys/devices/system/cpu
write /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq 302400
write /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq 1958400

write /sys/devices/system/cpu/cpu5/online 1
write /sys/devices/system/cpu/cpu5/cpufreq/scaling_governor elementalx
restorecon -R /sys/devices/system/cpu
write /sys/devices/system/cpu/cpu5/cpufreq/scaling_min_freq 302400
write /sys/devices/system/cpu/cpu5/cpufreq/scaling_max_freq 1958400

write /sys/devices/system/cpu/cpu6/online 1
write /sys/devices/system/cpu/cpu6/cpufreq/scaling_governor elementalx
restorecon -R /sys/devices/system/cpu
write /sys/devices/system/cpu/cpu6/cpufreq/scaling_min_freq 302400
write /sys/devices/system/cpu/cpu6/cpufreq/scaling_max_freq 1958400

write /sys/devices/system/cpu/cpu7/online 1
write /sys/devices/system/cpu/cpu7/cpufreq/scaling_governor elementalx
restorecon -R /sys/devices/system/cpu
write /sys/devices/system/cpu/cpu7/cpufreq/scaling_min_freq 302400
write /sys/devices/system/cpu/cpu7/cpufreq/scaling_max_freq 1958400

# input boost configuration
write /sys/module/cpu_boost/parameters/input_boost_freq
write /sys/module/cpu_boost/parameters/input_boost_ms 40

# Setting B.L scheduler parameters
write /proc/sys/kernel/sched_migration_fixup 1
write /proc/sys/kernel/sched_upmigrate 95
write /proc/sys/kernel/sched_downmigrate 85
write /proc/sys/kernel/sched_freq_inc_notify 400000
write /proc/sys/kernel/sched_freq_dec_notify 400000

# android background processes are set to nice 10. Never schedule these on the a57s.
write /proc/sys/kernel/sched_upmigrate_min_nice 9

get-set-forall  /sys/class/devfreq/qcom,cpubw*/governor bw_hwmon

# Disable sched_boost
write /proc/sys/kernel/sched_boost 0

# make sure thermal is set
write /sys/module/msm_thermal/core_control/enabled 0
restorecon -R /sys/module/msm_thermal
chmod 0664 /sys/module/msm_thermal/parameters/enabled
write /sys/module/msm_thermal/parameters/enabled Y
write /sys/module/msm_thermal/parameters/limit_temp_degC 80

# change GPU initial power level from 305MHz(level 4) to 180MHz(level 5) for power savings
write /sys/class/kgsl/kgsl-3d0/default_pwrlevel 5
