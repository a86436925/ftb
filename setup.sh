#!/bin/sh

echo_prefix="[\e[0;36msetup.sh\e[0m]"
echo_error="$echo_prefix [\e[1;31mERROR\e[0m]"
echo_info="$echo_prefix [\e[0;32mINFO\e[0m]"

[[ -z "${MODPACKID}" ]] && echo -e "$echo_error env \e[1;4;33mMODPACKID\e[0m not set" && echo -e "$echo_error paused" && sleep infinity
[[ -z "${VERSION}" ]] && echo -e "$echo_error env \e[1;4;33mVERSION\e[0m not set" && echo -e "$echo_error paused" && sleep infinity

cdir=/minecraftftb/ftb_${MODPACKID}_${VERSION}
echo -e "$echo_info target directory is $cdir"

if [ ! -f $cdir"/start.sh" ]; then
    echo -e "$echo_info initing..."
    if [ -d $cdir ]; then
        echo -e "$echo_info remove exist file..."
        find $cdir ! -name "world" -depth -delete
    else
        echo -e "$echo_info create target directory..."
        mkdir -p $cdir
    fi
    if [ ! -f serverinstall_${MODPACKID}_${VERSION} ]; then
        echo -e "$echo_info download serverinstall..."
        wget https://api.modpacks.ch/public/modpack/$MODPACKID/$VERSION/server/linux -O serverinstall_${MODPACKID}_${VERSION}
    fi
    echo -e "$echo_info installing..."
    chmod u+x serverinstall_${MODPACKID}_${VERSION}
    ./serverinstall_${MODPACKID}_${VERSION} --auto --path $cdir
    sed -i "s/-Xmx[0-9,a-z,A-Z]* /-Xmx\$\{MAXMEMORY\} /; s/-Xms[0-9,a-z,A-Z]* /-Xms\$\{MINMEMORY\} /" "$cdir/start.sh"
    echo eula=true > $cdir/eula.txt
    echo -e "$echo_info init done"
else
    echo -e "$echo_info found exist file, ignore init"
fi
cd $cdir
echo -e "$echo_info pwd..."
pwd
echo -e "$echo_info starting server..."
./start.sh
echo -e "$echo_info exit"
