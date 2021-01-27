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
        echo "≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡"
        echo -e "≡≡≡≡≡≡ ${Green_font_prefix} Gost已安装~ ${Font_color_suffix}≡≡≡≡≡≡"
        echo "≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡"
    else
        echo "≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡"
        echo -e "≡≡≡≡≡≡ ${Red_font_prefix} Gost未安装！${Font_color_suffix}≡≡≡≡≡≡"
        echo "≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡"
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
    "Debug": true,
    "Retries": 0,
    "ServeNodes": [
        "udp://127.0.0.1:8848"
    ]
}' > /etc/gost/config.json
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
        `rm -rf /etc/gost`
        `rm -rf /etc/systemd/system/gost.service`
        `rm -rf /etc/gostconfig.json`
    fi
sleep 3s
start_menu
}

#安装Gost
Install_Gost(){
  if test -a /etc/gost;then
  rm -rf /etc/gost
  mkdir /etc/gost
  wget --no-check-certificate https://gotunnel.oss-cn-shenzhen.aliyuncs.com/gost-linux-amd64-2.11.1.gz && gzip -d gost-linux-amd64-2.11.1.gz && mv gost-linux-amd64-2.11.1 /etc/gost/gost && chmod +x /etc/gost/gost
  Service_Config_Gost
  chmod +x /etc/gost/config.json
  Success_Gost
  systemctl enable --now gost
  else
  mkdir /etc/gost 
  wget --no-check-certificate https://gotunnel.oss-cn-shenzhen.aliyuncs.com/gost-linux-amd64-2.11.1.gz && gzip -d gost-linux-amd64-2.11.1.gz && mv gost-linux-amd64-2.11.1 /etc/gost/gost && chmod +x /etc/gost/gost
  Service_Config_Gost
  chmod +x /etc/gost/config.json
  Success_Gost
  systemctl enable --now gost
  fi
}

#卸载Gost
Uninstall_Gost(){
    'systemctl stop gost'
    `rm -rf /etc/gost`
    `rm -rf /etc/systemd/system/gost.service`
        echo "≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡"
        echo -e "≡≡≡≡≡≡ ${Green_font_prefix} Gost已卸载~ ${Font_color_suffix}≡≡≡≡≡≡"
        echo "≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡"
    sleep 2s
    start_menu
}

#启动Gost
Start_Gost(){
    if test -a /etc/gost/gost -a /etc/systemd/system/gost.service -a /etc/gost/config.json;then
    `systemctl start gost`
        echo "≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡"
        echo -e "≡≡≡≡≡≡ ${Green_font_prefix} Gost已启动~ ${Font_color_suffix}≡≡≡≡≡≡"
        echo "≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡"
    sleep 3s
    else
    echo -e "${Red_font_prefix} 你装都没装你启动你奶奶个腿~！ ${Font_color_suffix}"
    sleep 3s
    fi
    start_menu
}

#停止Gost
Stop_Gost(){
    if test -a /etc/gost/gost -a /etc/systemd/system/gost.service -a /etc/gost/config.json;then
    `systemctl stop gost`
        echo "≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡"
        echo -e "≡≡≡≡≡≡ ${Green_font_prefix} Gost已停止~ ${Font_color_suffix}≡≡≡≡≡≡"
        echo "≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡"
    sleep 3s
    else
    echo -e "${Red_font_prefix} 你装都没装你停止你奶奶个腿~！ ${Font_color_suffix}"
    sleep 3s
    fi
    start_menu
}

#重启Gost
Restart_Gost(){
    if test -a /etc/gost/gost -a /etc/systemd/system/gost.service -a /etc/gost/config.json;then
    `systemctl restart gost`
        echo "≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡"
        echo -e "≡≡≡≡≡≡ ${Green_font_prefix} Gost已重启~ ${Font_color_suffix}≡≡≡≡≡≡"
        echo "≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡"
    sleep 3s
    else
    echo -e "${Red_font_prefix} 你装都没装你重启你奶奶个腿~！ ${Font_color_suffix}"
    sleep 3s
    fi
    start_menu
}

#写入查询配置
Write_rawconf() {
  echo $model"/""$tcpudp_outport""#""$tcpudp_ip""#""$tcpudp_inport" >> $raw_conf_path
}

#tcpudp转发
tcpudp(){
  a=0
  b=65535
  clear
  echo -e "#############################################################"
  echo -e "#    1.需要进行流量转的发本机端口(说白了就是你的梯子端口):  #"
  echo -e "#############################################################"
  read -p "请输入端口: " tcpudp_outport
  if  [ $tcpudp_outport -gt $a ] && [ $tcpudp_outport -le $b ]; then
  clear
  echo -e "#############################################################"
  echo -e "#    2.输入IP地址,可以是本机内网外地址，默认127.0.0.1       #"
  echo -e "#############################################################"
  read -p "请输入本机地址(默认:127.0.0.1) : " tcpudp_ip
  [ -z "${tcpudp_ip}" ]  && tcpudp_ip=127.0.0.1
  clear
  echo -e "#############################################################"
  echo -e "#    3.对选项1进行流量转发的端口:                           #"
  echo -e "#############################################################"
  read -p "请输入端口: " tcpudp_inport
  if [ $tcpudp_inport -gt $a ] && [ $tcpudp_inport -le $b ]; then
  Write_rawconf
  rm -rf /etc/gost/config.json
  Conf_start
  Set_Config
  conflast
  systemctl restart gost
  echo -e "${Green_font_prefix} 添加成功！ ${Font_color_suffix}"
  sleep 2s
  start_menu
  fi
  else
  echo -e "${Red_font_prefix} 输入错误请重新输入！ ${Font_color_suffix}"
  sleep 2s
  tcpudp
  fi
}

outgost(){
  clear
  echo -e "#############################################################"
  echo -e "#\t\t    ${Green_font_prefix}请 选 择 隧 道 协 议${Font_color_suffix}\t\t    #"
  echo -e "#  标 准 隧道协议：  1.TLS 2.WS 3.WSS 4.MWS 5.MWSS          #"
  echo -e "#  Relay+隧道协议：  6.TLS 7.WS 8.WSS 9.MWS 10.MWSS         #"    
  echo -e "#############################################################"
  read -p "请输入数字: " numoutgost
  if [ "$numoutgost" == "1" ]; then
    model="tls"
  elif [ "$numoutgost" == "2" ]; then
    model="ws"
  elif [ "$numoutgost" == "3" ]; then
    model="wss"
  elif [ "$numoutgost" == "4" ]; then
    model="mws"
  elif [ "$numoutgost" == "5" ]; then
    model="mwss"
  elif [ "$numoutgost" == "6" ]; then
    model="relaytls"
  elif [ "$numoutgost" == "7" ]; then
    model="relayws"
  elif [ "$numoutgost" == "8" ]; then
    model="relaywss"
  elif [ "$numoutgost" == "9" ]; then
    model="relaywss"    
  elif [ "$numoutgost" == "10" ]; then
    model="relaymwss"      
  else
    echo -e "${Red_font_prefix}输入错误，请重新输入！${Font_color_suffix}"
    sleep 2s
    outgost
  fi
  tcpudp
}

#赋值
eachconf_retrieve()
{
  a=${trans_conf%#*}
  b=${trans_conf#*/}
  model=${trans_conf%%/*}
  inport=${b%%#*}
  ip=${a#*#}
  outport=${trans_conf##*#}
}

#配置Gost转发规则
Conf_start(){
echo "{
    \"Debug\": true,
    \"Retries\": 0,
    \"ServeNodes\": [" >> $gost_conf_path
}
multiconfstart() {
  echo "        {
            \"Retries\": 0,
            \"ServeNodes\": [" >>$gost_conf_path
}
conflast() {
  echo "    ]
}" >>$gost_conf_path
}
multiconflast() {
  if [ $i -eq $count_line ]; then
    echo "            ]
        }" >>$gost_conf_path
  else
    echo "            ]
        }," >>$gost_conf_path
  fi
}

#功能
method() {
  if [ $i -eq 1 ]; then
    if [ "$model" == "tcpudp" ]; then
      echo "        \"tcp://:$inport/$ip:$outport\",
        \"udp://:$inport/$ip:$outport\"" >>$gost_conf_path
    elif [ "$model" == "peerno" ]; then
      echo "        \"tcp://:$inport?ip=/root/$ip.txt&strategy=$outport\",
        \"udp://:$inport?ip=/root/$ip.txt&strategy=$outport\"" >>$gost_conf_path
    elif [ "$model" == "tls" ]; then
      echo "        \"tcp://:$inport\",
        \"udp://:$inport\"
    ],
    \"ChainNodes\": [
        \"tls://$ip:$outport\"" >>$gost_conf_path
    elif [ "$model" == "ws" ]; then
      echo "        \"tcp://:$inport\",
    	\"udp://:$inport\"
	],
	\"ChainNodes\": [
    	\"ws://$ip:$outport\"" >>$gost_conf_path
    elif [ "$model" == "wss" ]; then
      echo "        \"tcp://:$inport\",
		\"udp://:$inport\"
	],
	\"ChainNodes\": [
		\"wss://$ip:$outport\"" >>$gost_conf_path
    elif [ "$model" == "mws" ]; then
      echo "        \"tcp://:$inport\",
		\"udp://:$inport\"
	],
	\"ChainNodes\": [
		\"mws://$ip:$outport\"" >>$gost_conf_path
    elif [ "$model" == "mwss" ]; then
      echo "        \"tcp://:$inport\",
		\"udp://:$inport\"
	],
	\"ChainNodes\": [
		\"mwss://$ip:$outport\"" >>$gost_conf_path

    elif [ "$model" == "relaytls" ]; then
      echo "        \"tcp://:$inport\",
        \"udp://:$inport\"
    ],
    \"ChainNodes\": [
        \"relay+tls://$ip:$outport\"" >>$gost_conf_path
    elif [ "$model" == "relayws" ]; then
      echo "        \"tcp://:$inport\",
    	\"udp://:$inport\"
	],
	\"ChainNodes\": [
    	\"relay+ws://$ip:$outport\"" >>$gost_conf_path
    elif [ "$model" == "relaywss" ]; then
      echo "        \"tcp://:$inport\",
		\"udp://:$inport\"
	],
	\"ChainNodes\": [
		\"relay+wss://$ip:$outport\"" >>$gost_conf_path
    elif [ "$model" == "relaymws" ]; then
      echo "        \"tcp://:$inport\",
		\"udp://:$inport\"
	],
	\"ChainNodes\": [
		\"relay+mws://$ip:$outport\"" >>$gost_conf_path
    elif [ "$model" == "relaymwss" ]; then
      echo "        \"tcp://:$inport\",
		\"udp://:$inport\"
	],
	\"ChainNodes\": [
		\"relay+mwss://$ip:$outport\"" >>$gost_conf_path
    elif [ "$model" == "peertls" ]; then
      echo "        \"tcp://:$inport\",
    	\"udp://:$inport\"
	],
	\"ChainNodes\": [
    	\"relay+tls://:?ip=/root/$ip.txt&strategy=$outport\"" >>$gost_conf_path
    elif [ "$model" == "peerws" ]; then
      echo "        \"tcp://:$inport\",
    	\"udp://:$inport\"
	],
	\"ChainNodes\": [
    	\"relay+ws://:?ip=/root/$ip.txt&strategy=$outport\"" >>$gost_conf_path
    elif [ "$model" == "peerwss" ]; then
      echo "        \"tcp://:$inport\",
    	\"udp://:$inport\"
	],
	\"ChainNodes\": [
    	\"relay+wss://:?ip=/root/$ip.txt&strategy=$outport\"" >>$gost_conf_path
    elif [ "$model" == "tls" ]; then
      echo "        \"tls://:$inport/$ip:$outport\"" >>$gost_conf_path
    elif [ "$model" == "ws" ]; then
      echo "        \"ws://:$inport/$ip:$outport\"" >>$gost_conf_path
    elif [ "$model" == "wss" ]; then
      echo "        \"wss://:$inport/$ip:$outport\"" >>$gost_conf_path
    elif [ "$model" == "mws" ]; then
      echo "        \"mws://:$inport/$ip:$outport\"" >>$gost_conf_path
    elif [ "$model" == "mwss" ]; then
      echo "        \"mwss://:$inport/$ip:$outport\"" >>$gost_conf_path
    elif [ "$model" == "relaytls" ]; then
      echo "        \"relay+tls://:$inport/$ip:$outport\"" >>$gost_conf_path
    elif [ "$model" == "relayws" ]; then
      echo "        \"relay+ws://:$inport/$ip:$outport\"" >>$gost_conf_path
    elif [ "$model" == "relaywss" ]; then
      echo "        \"relay+wss://:$inport/$ip:$outport\"" >>$gost_conf_path
    elif [ "$model" == "relaymws" ]; then
      echo "        \"relay+mws://:$inport/$ip:$outport\"" >>$gost_conf_path
    elif [ "$model" == "relaymwss" ]; then
      echo "        \"relay+mwss://:$inport/$ip:$outport\"" >>$gost_conf_path
    elif [ "$model" == "ss" ]; then
      echo "        \"ss://$ip:$inport@:$outport\"" >>$gost_conf_path
    elif [ "$model" == "socks" ]; then
      echo "        \"socks5://$ip:$inport@:$outport\"" >>$gost_conf_path
    else
      echo -e"${Red_font_prefix}配置发生错误！${Font_color_suffix}"
    fi
  elif [ $i -gt 1 ]; then
    if [ "$model" == "tcpudp" ]; then
      echo "                \"tcp://:$inport/$ip:$outport\",
                \"udp://:$inport/$ip:$outport\"" >>$gost_conf_path
    elif [ "$model" == "peerno" ]; then
      echo "                \"tcp://:$inport?ip=/root/$ip.txt&strategy=$outport\",
                \"udp://:$inport?ip=/root/$ip.txt&strategy=$outport\"" >>$gost_conf_path
    elif [ "$model" == "tls" ]; then
      echo "                \"tcp://:$inport\",
                \"udp://:$inport\"
            ],
            \"ChainNodes\": [
                \"tls://$ip:$outport\"" >>$gost_conf_path
    elif [ "$model" == "ws" ]; then
      echo "                \"tcp://:$inport\",
	            \"udp://:$inport\"
	        ],
	        \"ChainNodes\": [
	            \"ws://$ip:$outport\"" >>$gost_conf_path
    elif [ "$model" == "wss" ]; then
      echo "                \"tcp://:$inport\",
		        \"udp://:$inport\"
		    ],
		    \"ChainNodes\": [
		        \"wss://$ip:$outport\"" >>$gost_conf_path
    elif [ "$model" == "mws" ]; then
      echo "                \"tcp://:$inport\",
		        \"udp://:$inport\"
		    ],
		    \"ChainNodes\": [
		        \"mws://$ip:$outport\"" >>$gost_conf_path	
    elif [ "$model" == "mwss" ]; then
      echo "                \"tcp://:$inport\",
		        \"udp://:$inport\"
		    ],
		    \"ChainNodes\": [
		        \"mwss://$ip:$outport\"" >>$gost_conf_path	
    elif [ "$model" == "relaytls" ]; then
      echo "                \"tcp://:$inport\",
                \"udp://:$inport\"
            ],
            \"ChainNodes\": [
                \"relay+tls://$ip:$outport\"" >>$gost_conf_path
    elif [ "$model" == "relayws" ]; then
      echo "                \"tcp://:$inport\",
	            \"udp://:$inport\"
	        ],
	        \"ChainNodes\": [
	            \"relay+ws://$ip:$outport\"" >>$gost_conf_path
    elif [ "$model" == "relaywss" ]; then
      echo "                \"tcp://:$inport\",
		        \"udp://:$inport\"
		    ],
		    \"ChainNodes\": [
		        \"relay+wss://$ip:$outport\"" >>$gost_conf_path
    elif [ "$model" == "relaymws" ]; then
      echo "                \"tcp://:$inport\",
		        \"udp://:$inport\"
		    ],
		    \"ChainNodes\": [
		        \"relay+mws://$ip:$outport\"" >>$gost_conf_path	
    elif [ "$model" == "relaymwss" ]; then
      echo "                \"tcp://:$inport\",
		        \"udp://:$inport\"
		    ],
		    \"ChainNodes\": [
		        \"relay+mwss://$ip:$outport\"" >>$gost_conf_path		        	        	        
    elif [ "$model" == "peertls" ]; then
      echo "                \"tcp://:$inport\",
                \"udp://:$inport\"
            ],
            \"ChainNodes\": [
                \"relay+tls://:?ip=/root/$ip.txt&strategy=$outport\"" >>$gost_conf_path
    elif [ "$model" == "peerws" ]; then
      echo "                \"tcp://:$inport\",
                \"udp://:$inport\"
            ],
            \"ChainNodes\": [
                \"relay+ws://:?ip=/root/$ip.txt&strategy=$outport\"" >>$gost_conf_path
    elif [ "$model" == "peerwss" ]; then
      echo "                \"tcp://:$inport\",
                \"udp://:$inport\"
            ],
            \"ChainNodes\": [
                \"relay+wss://:?ip=/root/$ip.txt&strategy=$outport\"" >>$gost_conf_path
    elif [ "$model" == "decrypttls" ]; then
      echo "                \"relay+tls://:$inport/$ip:$outport\"" >>$gost_conf_path
    elif [ "$model" == "decryptws" ]; then
      echo "        		  \"relay+ws://:$inport/$ip:$outport\"" >>$gost_conf_path
    elif [ "$model" == "decryptwss" ]; then
      echo "        		  \"relay+wss://:$inport/$ip:$outport\"" >>$gost_conf_path
    elif [ "$model" == "ss" ]; then
      echo "        \"ss://$ip:$inport@:$outport\"" >>$gost_conf_path
    elif [ "$model" == "socks" ]; then
      echo "        \"socks5://$ip:$inport@:$outport\"" >>$gost_conf_path
    else
      echo -e"${Red_font_prefix}配置发生错误！${Font_color_suffix}"
    fi
  else
    echo -e"${Red_font_prefix}配置发生错误！${Font_color_suffix}"
    exit
  fi
}

#写入配置
Set_Config() {
  count_line=$(awk 'END{print NR}' $raw_conf_path)
  for ((i = 1; i <= $count_line; i++)); do
    if [ $i -eq 1 ]; then
      trans_conf=$(sed -n "${i}p" $raw_conf_path)
      eachconf_retrieve
      method
    elif [ $i -gt 1 ]; then
      if [ $i -eq 2 ]; then
        echo "    ],
    \"Routes\": [" >>$gost_conf_path
        trans_conf=$(sed -n "${i}p" $raw_conf_path)
        eachconf_retrieve
        multiconfstart
        method
        multiconflast
      else
        trans_conf=$(sed -n "${i}p" $raw_conf_path)
        eachconf_retrieve
        multiconfstart
        method
        multiconflast
      fi
    fi
  done
}

#查看规则
Check_Gost(){

  echo -e "\t\t\t\t\t\033[36m  \033[1mGost配置信息  \033[0m\t\t\t\t\t\t"
  echo -e "\033[30m≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡\033[0m"
  echo -e "\033[33m‖   序号 ‖ \t转发方式\t‖  流量进端口\t‖\t转发地址\t:\t流量出端口\t‖\033[0m"
  echo -e "\033[30m≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡\033[0m"

  count_line=$(awk 'END{print NR}' $raw_conf_path)
  for ((i = 1; i <= $count_line; i++)); do
    trans_conf=$(sed -n "${i}p" $raw_conf_path)
    eachconf_retrieve

    if [ "$model" == "tcpudp" ]; then
      str="不加密中转"
    elif [ "$model" == "tls" ]; then
      str=" tls隧道 "
    elif [ "$model" == "ws" ]; then
      str="  ws隧道 "
    elif [ "$model" == "wss" ]; then
      str=" wss隧道 "
    elif [ "$model" == "mws" ]; then
      str="  mws隧道 "
    elif [ "$model" == "mwss" ]; then
      str=" mwss隧道 "
    elif [ "$model" == "relaytls" ]; then
      str=" relay+tls隧道 "
    elif [ "$model" == "relayws" ]; then
      str=" relay+ws隧道 "
    elif [ "$model" == "relaywss" ]; then
      str=" relay+wss隧道 "
    elif [ "$model" == "relaymws" ]; then
      str=" relay+mws隧道 "
    elif [ "$model" == "relaymwss" ]; then
      str=" relay+mwss隧道 "           
    elif [ "$model" == "peerno" ]; then
      str=" 不加密均衡负载 "
    elif [ "$model" == "peertls" ]; then
      str=" tls隧道均衡负载 "
    elif [ "$model" == "peerws" ]; then
      str="  ws隧道均衡负载 "
    elif [ "$modelt" == "peerwss" ]; then
      str=" wss隧道均衡负载 "
    elif [ "$model" == "decrypttls" ]; then
      str=" tls解密 "
    elif [ "$model" == "decryptws" ]; then
      str="  ws解密 "
    elif [ "$model" == "decryptwss" ]; then
      str=" wss解密 "
    elif [ "$model" == "ss" ]; then
      str="   ss   "
    elif [ "$model" == "socks" ]; then
      str=" socks5 "
    fi

    echo -e "\033[30m‖    $i   ‖\t$str\t‖\t$inport\t‖\t$ip\t:\t$outport\t\t\\033[30m‖"
    echo -e "\033[30m≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡\033[0m"
  done
  read -p "输入任意键按回车返回主菜单"
  start_menu
}

#选择转发方式
Choice_Rules(){
  clear
  echo -e "#############################${Green_font_prefix}  请选择转发方式: ${Font_color_suffix}############################"
  echo -e "#####################################"  "#####################################"
  echo -e "#  1. tcp+udp流量转发, 不带加密     #"  "#  2. 隧道流量加密转发                #" 
  echo -e "#  说明:类似iptables,在中转机执行   #"  "#  说明:该选项在落地机执行          #"
  echo -e "#####################################"  "#####################################"
  echo -e "#####################################"  "#####################################"
  echo -e "#  3. 隧道流量解密转发              #"  "#  4. 一键安装ss/socks5代理         #" 
  echo -e "#  说明:该选项在中转机执行          #"  "#  说明:使用gost内置的代理协议      #"
  echo -e "#####################################"  "#####################################"
  echo -e "###########################################################################" 
  echo -e "#                      5. 进阶：多落地均衡负载                            #"                   
  echo -e "#                    说明: 支持各种加密方式的简单均衡负载                 #"
  echo -e "###########################################################################" 
  read -p "请输入数字[1-5]选择模式: " nummodel
  if [ "$nummodel" == "1" ]; then
    model="tcpudp"
    tcpudp
  elif [ "$nummodel" == "2" ]; then
    model="outgost"
    outgost
  elif [ "$nummodel" == "3" ]; then
    model="ingost"
    ingost
  elif [ "$nummodel" == "4" ]; then
    model="ss_socks5"
    ss_socks5
  elif [ "$nummodel" == "5" ]; then
    model="Load_Balancing"
    Load_Balancing
  else
    echo -e "${Red_font_prefix} 输入错误，请重新输入！${Font_color_suffix}"
    sleep 2s
    Choice_Rules
  fi
}

#添加Gost规则
Add_Gost(){
Choice_Rules
}
#更新脚本
Update_Shell(){
	echo -e "当前版本为 [ ${sh_ver} ]，开始检测最新版本..."
	cp /etc/resolv.conf /etc/resolv.conf.bak
	echo 'nameserver 8.8.8.8' > /etc/resolv.conf
	sh_new_ver=$(wget --no-check-certificate -qO- "https://raw.githubusercontent.com/seal0207/RelaxGost/main/relaxgost.sh"|grep 'sh_ver="'|awk -F "=" '{print $NF}'|sed 's/\"//g'|head -1)
	rm -f /etc/resolv.conf
	cp /etc/resolv.conf.bak /etc/resolv.conf
	rm -f /etc/resolv.conf.bak
	[[ -z ${sh_new_ver} ]] && echo -e "${Error} 检测最新版本失败 !" && start_menu
	if [[ ${sh_new_ver} != ${sh_ver} ]]; then
		echo -e "发现新版本[ ${sh_new_ver} ]，是否更新？[Y/n]"
		read -p "(默认: y):" yn
		[[ -z "${yn}" ]] && yn="y"
		if [[ ${yn} == [Yy] ]]; then
			wget -N --no-check-certificate https://raw.githubusercontent.com/seal0207/RelaxGost/main/relaxgost.sh && chmod +x relaxgost.sh.sh
			echo -e "脚本已更新为最新版本[ ${sh_new_ver} ] !"
		else
			echo && echo "	已取消..." && echo
		fi
	else
		echo -e "当前已是最新版本[ ${sh_new_ver} ] !"
		sleep 3s
		start_menu
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
≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡
‖ 当前版本 ${Red_font_prefix}[v${sh_ver}]${Font_color_suffix}      ‖
‖ ${Green_font_prefix}0.${Font_color_suffix}  更新 Gost 脚本     ‖
‖ ${Green_font_prefix}1.${Font_color_suffix}  安装 Gost          ‖   
‖ ${Green_font_prefix}2.${Font_color_suffix}  卸载 Gost          ‖
≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡
‖ ${Green_font_prefix}3.${Font_color_suffix}  启动 Gost          ‖
‖ ${Green_font_prefix}4.${Font_color_suffix}  停止 Gost          ‖
‖ ${Green_font_prefix}5.${Font_color_suffix}  重启 Gost          ‖
≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡     
‖ ${Green_font_prefix}6.${Font_color_suffix}  添加 Gost 转发规则 ‖
‖ ${Green_font_prefix}7.${Font_color_suffix}  查看 Gost 转发规则 ‖
‖ ${Green_font_prefix}8.${Font_color_suffix}  删除 Gost 转发规则 ‖
‖ ${Green_font_prefix}9.${Font_color_suffix}  添加 Gost 重启任务 ‖
‖ ${Green_font_prefix}10.${Font_color_suffix} 退出 Gost 脚本     ‖"
 check_status

read -p "请输入数字后[0-10]按回车键:
" num
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
	echo -e "${Error}:请输入正确数字[0-10]按回车键"
	sleep 2s
	start_menu
	;;
esac
echo
}
start_menu
