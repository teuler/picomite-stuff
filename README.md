# picomite-stuff

These are instructions to build the PicoMite MMBasic firmware on a Windows PC.  
PicoMite MMBasic was created by Geoff Graham and Peter Mather - for more infos and copyrights see [Geoff's pages](https://geoffg.net/picomite.html) and [Peter's repository](https://github.com/UKTailwind/PicoMite).

__Notes:__  
_(1): You use these instructions at your own risk. They worked for me but your software environment may be different and I take no responsibilities if you damage your configuration._  
_(2): There may be an easier, more straight-forward way to set up the build chain - this is just what I figured out to work._

## Prerequisites

I used a Windows 11 PC; here is what you should have already ínstalled:
- Microsoft Visual Studio Code (VSCode, as editor and convinient build environment)
- `git` - as I have the Python Anaconda distribution installed anyways, I just needed to add `git` package through the Anaconda.Navigator. You can also install `git` from the usual sources.

## Building the standard PicoMite firmware

1. The following commands I execute in an Anaconda Powershell. You can use any other windows shell as long it can access your `git` installation.
2. Create a new folder that hosts all parts (e.g., ``picomite'') and change to that folder, e.g.:
    ```
    mkdir picomite
    cd .\picomite\
    ```
4. Clone the PicoMite source code from Peter Mather's repository into the same folder:
    ```
    git clone https://github.com/UKTailwind/PicoMite.git
    ```
7. Download ``pico-setup-windows-x64-standalone.exe`` from [here](https://github.com/raspberrypi/pico-setup-windows/releases/tag/v1.5.1) and run it to install the pico build chain for Windows. This adds the entry "Pico - Visual Studio Code" to the Windows menue.

8. Find out where the pico sdk was installed. It's likely somewhere under `"C:\Program Files\Raspberry Pi\Pico SDK v1.5.1\pico-sdk`. We need to replace a few files there. For this, you need to __run the Powershell in administrator mode__. Alternatively, you can replace the files also via the File explorer.

    Replace ``gpio.c`` in the sdk folder (you identified above) by the one from PicoMite as decribed in Peter's readme:
    ```
    xcopy .\PicoMite\gpio.c "C:\Program Files\Raspberry Pi\Pico SDK v1.5.1\pico-sdk\src\rp2_common\hardware_gpio"
    xcopy .\PicoMite\gpio.c "C:\Program Files\Raspberry Pi\Pico SDK v1.5.1\pico-sdk\src\host\hardware_gpio"
    ```
    
    For the USB versions of the firmware, you need to replace TinyUSB in the sdk by version 0.16.0:
    ```
    cd "C:\Program Files\Raspberry Pi\Pico SDK v1.5.1\pico-sdk\lib"
    rm -r .\tinyusb\
    git clone https://github.com/hathach/tinyusb.git
    ```
9. Download and install the tool chain (`arm-gnu-toolchain-13.2.rel1-mingw-w64-i686-arm-none-eabia.exe`) required for the Picomite (as explained in Peter's readme) from [here](https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads).

10. Run VSCode (__not yet the "Pico - Visual Studio Code" version__) and open in VSCode the PicoMite folder; the one with Peter's code (e.g., `D:\picomite\PicoMite`).  

    Now we need to add the new GCC 13.2.1 toolchain to VSCode: Select the CMake symbol at the left of the VSCode window, go to the entry directly under "Configure" and select "[Scan for kits]". It should now find "GCC 13.2.1 arm-non-eabi" and add it to the available compiler versions. Select it such that comes up under "Configure". Exit VSCode.

12. Now run "Pico - Visual Studio Code"; it should reopen the PicoMite folder and immediately start configuring the tool chain. Make sure that "GCC 13.2.1 arm-non-eabi" is selected under "Configure".

13. Build the PicoMite firmware by clicking the "Build all projects" button next top the "PROJECT OUTLINE" entry. If you want a clean build, there is also "Clean rebuild all projects" under the "More Actions" button to the right of the build button.
    
14. If all goes well, the "Output" window should show only warnings and the line `[build] Build finished with exit code 0` at the end. The new firmware file `PicoMite.uf2` should be found under `.\picomite\PicoMite\build`.

## Building the USB PicoMite firmware

1. Clone PicoMiteUSB into your `picomite` folder (the one that contains `PicoMite` and `pico-sdk`) and copy `CMakeLists.txt` from the new folder to `PicoMite`:
   ```
   git clone https://github.com/UKTailwind/PicoMiteUSB.git
   copy .\PicoMite\CMakeLists.txt .\PicoMite\CMakeLists_standard.txt
   copy .\PicoMiteUSB\CMakeLists.txt .\PicoMite\
   '''
2. Rebuild the firmware as described above (from point 11.)

## Troubleshooting

- Some commits don't work for me -- I assume there is work in progress that is uploaded to the repository before the code is complete. In this case, one can try to set the code back to a certain commit, e.g.:
  ```
  cd .\PicoMite\
  git reset --hard 0331d03
  ```
  The commit ID you need to find in the commit history of the repository (e.g., the commits on Mar 24, 2024, has the ID `0331d03`)
  __Warning: Use only if you know what you are doing.__
  
   
   
