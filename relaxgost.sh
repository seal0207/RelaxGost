#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
clear

sh_ver="1.0.0"
Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[信息]${Font_color_suffix}"
Error="${Red_font_prefix}[错误]${Font_color_suffix}"
Tip="${Green_font_prefix}[注意]${Font_color_suffix}"

gost_conf_path="/etc/gost/config.json"
raw_conf_path="/etc/gost/rawconf"

#检测是否安装Gost
check_status(){
    if test -a /etc/gost/gost -a /etc/systemd/system/gost.service -a /etc/gost/config.json;then
        echo "------------------------------"
        echo -e "--------${Green_font_prefix} Gost已安装~ ${Font_color_suffix}--------"
        echo "------------------------------"
    else
        echo "------------------------------"
        echo -e "--------${Red_font_prefix} Gost未安装！${Font_color_suffix}---------"
        echo "------------------------------"
    fi
}

#添加Gost系统任务及默认配置
Service_Config_Gost(){
echo '
[Unit]
Description=gost
After=network-online.target
Wants=network-online.target systemd-networkd-wait-online.service

[Service]
Type=simple
User=root
Restart=always
RestartSec=5
DynamicUser=true
ExecStart=/etc/gost -c /etc/gost/config.json

[Install]
WantedBy=multi-user.target' > /etc/systemd/system/gost.service

echo '
{
    \"Debug\": true,
    \"Retries\": 0,
    \"ServeNodes\": [
        \"udp://127.0.0.1:8848\"
    ]
} ' > /etc/gost/config.json
}

#检测安装是否成功
Success_Gost(){
 echo "------------------------------"
    if test -a /etc/gost/gost -a /etc/systemd/system/gost.service -a /etc/gost/config.json;then
        echo -e "-------${Green_font_prefix} Gost安装成功! ${Font_color_suffix}-------"
        echo "------------------------------"
    else
        echo -e "-------${Red_font_prefix}Gost没有安装成功，请检查你的网络环境！${Font_color_suffix}-------"
        echo "------------------------------"
        `rm -rf "$(pwd)"/gost`
        `rm -rf "$(pwd)"/gost.service`
        `rm -rf "$(pwd)"/config.json`
    fi
sleep 3s
start_menu
}
#安装Gost
Install_Gost(){
  apt-get update -y && apt-get install wget -y && apt-get install gzip -y
  if test -a /etc/gost;then
  'rmdir -f /etc/gost'
  'mkdir /etc/gost'   
  wget -N --no-check-certificate https://github.com/seal0207/RelaxGost/raw/main/gost-linux-amd64-2.11.1.gz && gzip -d gost-linux-amd64-2.11.1.gz && mv gost-linux-amd64-2.11.1 /etc/gost/gost && chmod +x /etc/gost/gost &&chmod +x /etc/gost/config.json
  Service_Config_Gost
  Success_Gost
  'systemctl enable --now gost'
  else
  'mkdir /etc/gost'   
  wget -N --no-check-certificate https://github.com/ginuerzh/gost/releases/download/v2.11.1/gost-linux-amd64-2.11.1.gz && gzip -d gost-linux-amd64-2.11.1.gz && mv gost-linux-amd64-2.11.1 /etc/gost && chmod +x gost
  Service_Config_Gost
  Success_Gost
  'systemctl enable --now gost'
  fi
}

#更新脚本
Update_Shell(){
	echo -e "当前版本为 [ ${sh_ver} ]，开始检测最新版本..."
	sh_new_ver=$(wget --no-check-certificate -qO- "https://raw.githubusercontent.com/seal0207/RelaxGost/main/realxgost.sh"|grep 'sh_ver="'|awk -F "=" '{print $NF}'|sed 's/\"//g'|head -1)
	[[ -z ${sh_new_ver} ]] && echo -e "${Error} 检测最新版本失败 !" && start_menu
	if [[ ${sh_new_ver} != ${sh_ver} ]]; then
		echo -e "发现新版本[ ${sh_new_ver} ]，是否更新？[Y/n]"
		read -p "(默认: y):" yn
		[[ -z "${yn}" ]] && yn="y"
		if [[ ${yn} == [Yy] ]]; then
			wget -N --no-check-certificate https://raw.githubusercontent.com/seal0207/RelaxGost/main/realxgost.sh && chmod +x realxgost.sh
			echo -e "脚本已更新为最新版本[ ${sh_new_ver} ] !"
		else
			echo && echo "	已取消..." && echo
		fi
	else
		echo -e "当前已是最新版本[ ${sh_new_ver} ] !"
		sleep 3s
	fi
}

#主菜单
start_menu(){
clear
echo "#############################################################"
echo "#            Relax Gost 一键脚本  By：Seal0207              #"
echo "#             此脚本默认使用Gost版本为v2.11.1               #"
echo "#            专为懒人小白打造,使用便捷,操作明了~            #"
echo "#############################################################"
echo -e "
 当前版本 ${Red_font_prefix}[v${sh_ver}]${Font_color_suffix}
 ${Green_font_prefix}0.${Font_color_suffix}  更新 Gost 脚本
 ${Green_font_prefix}1.${Font_color_suffix}  安装 Gost
 ${Green_font_prefix}2.${Font_color_suffix}  卸载 Gost
——————————————
 ${Green_font_prefix}3.${Font_color_suffix}  启动 Gost
 ${Green_font_prefix}4.${Font_color_suffix}  停止 Gost
 ${Green_font_prefix}5.${Font_color_suffix}  重启 Gost
——————————————
 ${Green_font_prefix}6.${Font_color_suffix}  添加 Gost 转发规则
 ${Green_font_prefix}7.${Font_color_suffix}  查看 Gost 转发规则
 ${Green_font_prefix}8.${Font_color_suffix}  删除 Gost 转发规则
 ${Green_font_prefix}9.${Font_color_suffix}  添加 Gost 重启任务
 ${Green_font_prefix}10.${Font_color_suffix} 退出 Gost 脚本"
 check_status

read -p " 请输入数字后[0-10] 按回车键:" num
case "$num" in
	0)
	Update_Shell
	;;
	1)
	Install_Gost
	;;
	2)
	Uninstall_Gost
	;;
	3)
	Start_Gost
	;;
	4)
	Stop_Gost
	;;
	5)
	Restart_Gost
	;;
	6)
	Add_Gost
	;;
	7)
	Check_Gost
	;;
	8)
	Delete_Gost
	;;
	9)
	Restart_Task
	;;
	10)
	exit 1
	;;
	*)	
	clear
	echo -e "${Error}:请输入正确数字 [1-6] 按回车键"
	sleep 2s
	start_menu
	;;
esac
}
start_menu
