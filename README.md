# picomite-stuff

I used a Windows 11 PC; here is what you should have already ínstalled:
- the Python Anaconda distribution
- ``git'' -- I added the `git` package through the Anaconda.Navigator (yes, I know, it is so slow ...)
- Microsoft Visual Studio Code (VSCode, as editor and convinient build environment)

__Note that you use these instructions at your own risk. They worked for me but your software environment may be different and I take no responsibilities.__

1. The following commands I execute in an Anaconda Powershell.
2. Create a new folder that hosts all parts (e.g., ``picomite'') and change to thah folder, e.g.:
    ```
    mkdir picomite
    cd .\picomite\
    ```
3. Clone the pico sdk (currently, version 1.5.1):
    ```
    git clone https://github.com/raspberrypi/pico-sdk.git
    ```
4. Clone the PicoMite source code from Peter Mather's repository into the same folder:
    ```
    git clone https://github.com/UKTailwind/PicoMite.git
    ```
5. Replace ``gpio.c`` in the sdk folder by the one from PicoMite as decribed in Peter's readme:
    ```
    xcopy .\PicoMite\gpio.c .\pico-sdk\src\rp2_common\hardware_gpio
    xcopy .\PicoMite\gpio.c .\pico-sdk\src\host\hardware_gpio
    ```
6. For the USB versions of the firmware, you need to replace TinyUSB in the sdk by version 0.16.0:
    ```
    cd .\pico-sdk\lib\
    rm -r .\tinyusb\
    git clone https://github.com/hathach/tinyusb.git
    cd ..\..
    ```
7. Download ``pico-setup-windows-x64-standalone.exe`` from [here](https://github.com/raspberrypi/pico-setup-windows/releases/tag/v1.5.1) and run it to install the pico build chain for Windows. Note that this installs the pico sdk again but we will use mainly the integration of the build chain into VSCode.

8. Download and install the tool chain (`arm-gnu-toolchain-13.2.rel1-mingw-w64-i686-arm-none-eabia.exe`) required for the Picomite (as explained in Peter's readme) from [here](
https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads).

