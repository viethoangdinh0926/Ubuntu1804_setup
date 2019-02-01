SETUP
------------
Requirements
------------
1. BIOS is running in Legacy Boot mode
2. System is wiredly connected to the internet for downloading packages 

------------
Instruction
------------
## 2 options
**Fully automated:**        The configuration will perform the installation and setting the machine up
                        automatically.  
**Partially automated:**    The configuration wlil perform the installation automatically then user has
                        to set up the computer by running the script separately.

### Fully automated installation  
1. Download an image of Ubuntu (18.04 preferably)
2. Create a bootable drive from the ISO file (Ubuntu only)
3. Replace txt.config in isolinux folder in the bootable drive with the one in /usb/full_auto
4. Copy ks.preseed from /full_auto to root of the bootable drive
5. Copy setup folder from /full_auto to root of the bootable drive
6. Restart the machine and boot from the bootable drive.
   Note: The harddrive will be wiped completely
7. After Ubuntu installation, login to the machine with the password IloveEMC, then 
   allow the machine to run the script in the background for approximately 
   20 minutes (depending on CPU and network speed, this could take longer)
8. The machine will automatically reboot and is available for use


----------------------------------------------------------------------------------------------------


### Partially automated installation  
1. Download an image of Ubuntu (18.04 preferably)
2. Create a bootable drive from the ISO file 
3. Replace txt.config in isolinux folder in the bootable drive with the one in /partially_auto
4. Copy ks.preseed from /partially_auto to root of the bootable drive
5. Copy setup folder from /partially_auto to root of the bootable drive
6. Restart the machine and boot from the bootable drive.
   Note: The harddrive will be wiped completely
7. After Ubuntu installation, login to the machine with the password IloveEMC
8. Open the terminal
9. Run setup.sh script in Desktop folder with sudo privilege
10. The machine will automatically reboot and is available for use
