# perf_degrade_resource_stress_test_suite
It is a collection of simple shell scripts to simulate performance degrade and resource overload scenarios in Linux/Unix based systems

Where to find the codes?

https://github.com/rajibrajkhowa/perf_degrade_resource_stress_test_suite.git 

Tools needed for lab setup:

1.	VirtualBox or VMWare Player

2.	Any Linux ISO. I use Ubuntu 22.04 image for my labs. The installation methods provided below are for Ubuntu. A Google search would yield similar steps for other Linux distros using the respective package managers for those distros.

3.	The VM created should have minimum 2 vCPUs and 2 GB RAM (if you can assign 4 GB RAM then it would be really good).

4.	Run the tests as “root” (highest privilege).

5.	Run “sudo apt update && sudo apt upgrade ” as a best practice. Sometimes things don’t work (not always)

6.	Check if “iproute2” and “nmcli” is installed. If not, then please install them for testing network degrades. Normally, these packages are part of the standard Linux distributions. But may be missing sometimes.

7.	If “iproute2” is not installed, then run “sudo apt -y install iproute2” to install the same.

8.	If “nmcli” is not installed, then run “sudo apt install network-manager”. After installation, enable “nmcli” using the commands – “sudo systemctl start NetworkManager.service” followed by “sudo systemctl enable NetworkManager.service”.

9.	Install “stress” by invoking “sudo apt -y install stress”. This tool is needed for system stress testing of CPU, RAM and IO. By default, “stress” is not installed with standard Linux distributions.

How to run the lab?

1.	Once the setup is done. Clone the repo in the VM by running “git clone https://github.com/rajibrajkhowa/perf_degrade_resource_stress_test_suite.git “

2.	If Git is not installed, then install it by running “apt install git”.

3.	Change the permissions of the three scripts by running:

i.	chmod a+x main.sh
ii.	chmod a+x net_perf_degrade.sh, run this after performing “cd scripts/”.
iii.	chmod a+x sys_perf_degrade.sh, run this after performing “cd scripts/”.

4.	Run the “main.sh” script ./main.sh <number of runs>. Please use run value of no more than 5 as RAM degrades make the VM non-responsive. E.g. ./main 3 will run the degrades 3 times.

How to test the impact?

1.	CPU & IO load can be checked using “top | head -10” and checking the CPU usage under “us” and “sys” for both CPUs. It would be great if you use “htop” utility instead of vanilla “top”. We can install “htop” by running “apt install htop”.

2.	RAM overload can be felt by VM becoming non-responsive and getting back control of terminal only after the RAM degrade is over. Sometimes even the terminal of VM crashes and normalcy is returned only after RAM degrade is over.

3.	Network issues can be checked by a simple “ping -c 100 8.8.8.8” and see how the delay increases or the packet drops increases. 

Possible bugs:

1.	You might face hurdle when running the scripts due to illegal carriage return symbol as I used Windows machine to code the scripts and upload to GitHub.

2.	You might get an error of not being able to interpret or run the script due to presence of a funky symbol “^M”.

3.	We can circumvent the problem by two possible ways:

    I. Installing a utility “dos2unix” by running “apt install dos2unix” and run the following:

        i.    dos2unix main.sh
        ii.   dos2unix net_perf_degrade.sh, run this after performing “cd scripts/”.
        iii.  dos2unix net_perf_degrade.sh, run this after performing “cd scripts/”.

Or

    II. Using a “sed” one-liner as follows. But for that to retain the original names, we have to first rename the file to “temp.sh” and run the sed one-liner to write the contents to the new file having the original file name.

        i.      mv main.sh > temp.sh
        ii.     sed -e “s/\r//g” temp.sh > main.sh
        iii.    rm temp.sh
        iv.     cd scripts/
        v.      mv  net_perf_degrade.sh > temp.sh
        vi.     sed -e “s/\r//g” temp.sh > net_perf_degrade.sh
        vii.    rm temp.sh
        viii.   mv  sys_perf_degrade.sh > temp.sh
        ix.     sed -e “s/\r//g” temp.sh > sys_perf_degrade.sh
        x.      rm temp.sh
