; load 'dh' sectors from drive 'dl' into ES:BX
disk_load:


disk_error:

sectors_error:

disk_loop:

DISK_ERROR: db "Disk read error", 0
SECTORS_ERROR: db "Incorrect number of sectors read", 0
