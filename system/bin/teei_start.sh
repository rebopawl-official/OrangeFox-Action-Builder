#!/system/bin/sh
# Чекаємо, поки recovery створить симлінк на логічний розділ vendor, і монтуємо його read-only.
i=0
while [ ! -e /dev/block/by-name/vendor ] && [ $i -lt 120 ]; do sleep 1; i=$((i+1)); done
if ! grep -q " /vendor " /proc/mounts; then
  mkdir -p /vendor
  mount -t ext4 -o ro /dev/block/by-name/vendor /vendor
fi
# persist потрібен teei_daemon для RPMB (rpmb.txt), монтуємо read-only
if ! grep -q " /mnt/vendor/persist " /proc/mounts; then
  mkdir -p /mnt/vendor/persist
  mount -t ext4 -o ro /dev/block/platform/bootdevice/by-name/persist /mnt/vendor/persist
fi
exec /system/bin/teei_daemon "$@"
