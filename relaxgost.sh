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
ExecStart=/etc/gost/gost -C /etc/gost/config.json

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
systemctl daemon-reload
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
  rm -rf gost-linux-amd64-2.11.1.gz
  mkdir /etc/gost
  wget --no-check-certificate https://gotunnel.oss-cn-shenzhen.aliyuncs.com/gost-linux-amd64-2.11.1.gz && gzip -d gost-linux-amd64-2.11.1.gz && mv gost-linux-amd64-2.11.1 /etc/gost/gost && chmod +x /etc/gost/gost
  Service_Config_Gost
  chmod +x /etc/gost/config.json
  Success_Gost
  systemctl enable --now gost
  else
  rm -rf gost-linux-amd64-2.11.1.gz
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
  echo $model"/""$inport""#""$ip""#""$outport" >> $raw_conf_path
}

#tcpudp转发
tcpudp(){
  a=0
  b=65535
  clear
  echo -e "#############################################################"
  echo -e "#    1.输入远程进行流量转发的端口(说白了就是你的梯子端口)   #"
  echo -e "#############################################################"
  read -p "请输入端口: " outport
  if  [ $outport -gt $a ] && [ $outport -le $b ]; then
  clear
  echo -e "#############################################################"
  echo -e "#    2.输入需要转发的域名或IP地址                             #"
  echo -e "#############################################################"
  read -p "请输入域名或IP地址: " ip
  clear
  echo -e "#############################################################"
  echo -e "#    3.输入转发端口 （本地监听端口）                          #"
  echo -e "#############################################################"
  read -p "请输入端口: " inport
  if [ $inport -gt $a ] && [ $inport -le $b ]; then
  Write_rawconf
  rm -rf /etc/gost/config.json
  Conf_start
  Set_Config
  conflast
  systemctl restart gost
  echo -e "${Green_font_prefix} 添加成功！ ${Font_color_suffix}"
  sleep 2s
  Check_Gost
  read -p "输入任意键按回车返回主菜单"
  start_menu
  fi
  else
  echo -e "${Red_font_prefix} 输入错误请重新输入！ ${Font_color_suffix}"
  sleep 2s
  tcpudp
  fi
}

gostoutconf(){
  a=0
  b=65535
  clear
  echo -e "#############################################################"
  echo -e "#    请设置落地机隧道端口                                   #"
  echo -e "#############################################################"
  read -p "请输入端口: " outport
  if  [ $outport -gt $a ] && [ $outport -le $b ]; then
  echo -e "#############################################################"
  echo -e "#    请输入落地机的域名或IP地址                             #"
  echo -e "#############################################################"
  read -p "请输入域名或IP地址: " ip   
  clear
  echo -e "#############################################################"
  echo -e "#    请设置本地转发端口                                     #"
  echo -e "#############################################################"
  read -p "请输入端口: " inport
  if [ $inport -gt $a ] && [ $inport -le $b ]; then
  Write_rawconf
  rm -rf /etc/gost/config.json
  Conf_start
  Set_Config
  conflast
  systemctl restart gost
  echo -e "${Green_font_prefix} 添加成功！ ${Font_color_suffix}"
  sleep 2s
  Check_Gost
  read -p "输入任意键按回车返回主菜单"
  start_menu
  fi
  else
  echo -e "${Red_font_prefix} 输入错误请重新输入！ ${Font_color_suffix}"
  sleep 2s
  gostoutconf
  fi
}

gostinconf(){
  a=0
  b=65535
  ip=127.0.0.1
  clear
  echo -e "#############################################################"
  echo -e "#    请输入在落地机要监听转发的端口                         #"
  echo -e "#############################################################"
  read -p "请输入端口: " outport
  if  [ $outport -gt $a ] && [ $outport -le $b ]; then
  clear
  echo -e "#############################################################"
  echo -e "#    请输入所设置落地机隧道端口                             #"
  echo -e "#############################################################"
  read -p "请输入端口: " inport
  if [ $inport -gt $a ] && [ $inport -le $b ]; then
  Write_rawconf
  rm -rf /etc/gost/config.json
  Conf_start
  Set_Config
  conflast
  systemctl restart gost
  echo -e "${Green_font_prefix} 添加成功！ ${Font_color_suffix}"
  sleep 2s
  Check_Gost
  read -p "输入任意键按回车返回主菜单"
  start_menu
  fi
  else
  echo -e "${Red_font_prefix} 输入错误请重新输入！ ${Font_color_suffix}"
  sleep 2s
  gostinconf
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
  gostoutconf
}

ingost(){
  clear
  echo -e "#############################################################"
  echo -e "#\t\t   ${Green_font_prefix}请 选 择 隧 道 解 密 协 议${Font_color_suffix}\t\t    #"
  echo -e "#  标 准 隧道协议：  1.TLS 2.WS 3.WSS 4.MWS 5.MWSS          #"
  echo -e "#  Relay+隧道协议：  6.TLS 7.WS 8.WSS 9.MWS 10.MWSS         #"    
  echo -e "#############################################################"
  read -p "请输入数字: " numingost
  if [ "$numingost" == "1" ]; then
    model="detls"
  elif [ "$numingost" == "2" ]; then
    model="dews"
  elif [ "$numingost" == "3" ]; then
    model="dewss"
  elif [ "$numingost" == "4" ]; then
    model="demws"
  elif [ "$numingost" == "5" ]; then
    model="demwss"
  elif [ "$numingost" == "6" ]; then
    model="derelaytls"
  elif [ "$numingost" == "7" ]; then
    model="derelayws"
  elif [ "$numingost" == "8" ]; then
    model="derelaywss"
  elif [ "$numingost" == "9" ]; then
    model="derelaywss"    
  elif [ "$numingost" == "10" ]; then
    model="derelaymwss"      
  else
    echo -e "${Red_font_prefix}输入错误，请重新输入！${Font_color_suffix}"
    sleep 2s
    ingost
  fi
  gostinconf
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
        \"forward+tls://$ip:${outport}?mbind\"" >>$gost_conf_path
    elif [ "$model" == "ws" ]; then
      echo "        \"tcp://:$inport\",
    	\"udp://:$inport\"
	],
	\"ChainNodes\": [
    	\"forward+ws://$ip:${outport}?mbind\"" >>$gost_conf_path
    elif [ "$model" == "wss" ]; then
      echo "        \"tcp://:$inport\",
		\"udp://:$inport\"
	],
	\"ChainNodes\": [
		\"forward+wss://$ip:${outport}?mbind\"" >>$gost_conf_path
    elif [ "$model" == "mws" ]; then
      echo "        \"tcp://:$inport\",
		\"udp://:$inport\"
	],
	\"ChainNodes\": [
		\"forward+mws://$ip:${outport}?mbind\"" >>$gost_conf_path
    elif [ "$model" == "mwss" ]; then
      echo "        \"tcp://:$inport\",
		\"udp://:$inport\"
	],
	\"ChainNodes\": [
		\"forward+mwss://$ip:${outport}?mbind\"" >>$gost_conf_path

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
                \"forward+tls://$ip:${outport}?mbind\"" >>$gost_conf_path
    elif [ "$model" == "ws" ]; then
      echo "                \"tcp://:$inport\",
	            \"udp://:$inport\"
	        ],
	        \"ChainNodes\": [
	            \"forward+ws://$ip:${outport}?mbind\"" >>$gost_conf_path
    elif [ "$model" == "wss" ]; then
      echo "                \"tcp://:$inport\",
		        \"udp://:$inport\"
		    ],
		    \"ChainNodes\": [
		        \"forward+wss://$ip:${outport}?mbind\"" >>$gost_conf_path
    elif [ "$model" == "mws" ]; then
      echo "                \"tcp://:$inport\",
		        \"udp://:$inport\"
		    ],
		    \"ChainNodes\": [
		        \"forward+mws://$ip:${outport}?mbind\"" >>$gost_conf_path	
    elif [ "$model" == "mwss" ]; then
      echo "                \"tcp://:$inport\",
		        \"udp://:$inport\"
		    ],
		    \"ChainNodes\": [
		        \"forward+mwss://$ip:${outport}?mbind\"" >>$gost_conf_path	
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
#负载均衡配置
    elif [ "$model" == "peertls" ]; then
      echo "                \"tcp://:$inport\",
                \"udp://:$inport\"
            ],
            \"ChainNodes\": [
                \"forward+tls://:?ip=/root/$ip.txt&strategy=${outport}?mbind\"" >>$gost_conf_path
    elif [ "$model" == "peerws" ]; then
      echo "                \"tcp://:$inport\",
                \"udp://:$inport\"
            ],
            \"ChainNodes\": [
                \"forward+ws://:?ip=/root/$ip.txt&strategy=${outport}?mbind\"" >>$gost_conf_path
    elif [ "$model" == "peerwss" ]; then
      echo "                \"tcp://:$inport\",
                \"udp://:$inport\"
            ],
            \"ChainNodes\": [
                \"forward+wss://:?ip=/root/$ip.txt&strategy=${outport}?mbind\"" >>$gost_conf_path
    elif [ "$model" == "peermws" ]; then
      echo "                \"tcp://:$inport\",
                \"udp://:$inport\"
            ],
            \"ChainNodes\": [
                \"forward+mws://:?ip=/root/$ip.txt&strategy=${outport}?mbind\"" >>$gost_conf_path
    elif [ "$model" == "peermwws" ]; then
      echo "                \"tcp://:$inport\",
                \"udp://:$inport\"
            ],
            \"ChainNodes\": [
                \"forward+mwss://:?ip=/root/$ip.txt&strategy=${outport}?mbind\"" >>$gost_conf_path
		        	        	        	        
    elif [ "$model" == "peerrelaytls" ]; then
      echo "                \"tcp://:$inport\",
                \"udp://:$inport\"
            ],
            \"ChainNodes\": [
                \"relay+tls://:?ip=/root/$ip.txt&strategy=$outport\"" >>$gost_conf_path
    elif [ "$model" == "peerrelayws" ]; then
      echo "                \"tcp://:$inport\",
                \"udp://:$inport\"
            ],
            \"ChainNodes\": [
                \"relay+ws://:?ip=/root/$ip.txt&strategy=$outport\"" >>$gost_conf_path
    elif [ "$model" == "peerrelaywss" ]; then
      echo "                \"tcp://:$inport\",
                \"udp://:$inport\"
            ],
            \"ChainNodes\": [
                \"relay+wss://:?ip=/root/$ip.txt&strategy=$outport\"" >>$gost_conf_path
    elif [ "$model" == "peerrelaymws" ]; then
      echo "                \"tcp://:$inport\",
                \"udp://:$inport\"
            ],
            \"ChainNodes\": [
                \"relay+mws://:?ip=/root/$ip.txt&strategy=$outport\"" >>$gost_conf_path
    elif [ "$model" == "peerrelaymwss" ]; then
      echo "                \"tcp://:$inport\",
                \"udp://:$inport\"
            ],
            \"ChainNodes\": [
                \"relay+mwss://:?ip=/root/$ip.txt&strategy=$outport\"" >>$gost_conf_path
                                
    elif [ "$model" == "detls" ]; then
      echo "                \"tls://:$inport/$ip:${outport}?mbind\"" >>$gost_conf_path
    elif [ "$model" == "dews" ]; then
      echo "        		  \"ws://:$inport/$ip:${outport}?mbind\"" >>$gost_conf_path
    elif [ "$model" == "dewss" ]; then
      echo "        		  \"wss://:$inport/$ip:${outport}?mbind\"" >>$gost_conf_path
    elif [ "$model" == "demws" ]; then
      echo "        		  \"mws://:$inport/$ip:${outport}?mbind\"" >>$gost_conf_path
    elif [ "$model" == "demwss" ]; then
      echo "        		  \"mwss://:$inport/$ip:${outport}?mbind\"" >>$gost_conf_path
    elif [ "$model" == "derelaytls" ]; then
      echo "                \"relay+tls://:$inport/$ip:$outport\"" >>$gost_conf_path
    elif [ "$model" == "derelayws" ]; then
      echo "        		  \"relay+ws://:$inport/$ip:$outport\"" >>$gost_conf_path
    elif [ "$model" == "derelaywss" ]; then
      echo "        		  \"relay+wss://:$inport/$ip:$outport\"" >>$gost_conf_path
    elif [ "$model" == "derelaymws" ]; then
      echo "        		  \"relay+mws://:$inport/$ip:$outport\"" >>$gost_conf_path
    elif [ "$model" == "derelaymwss" ]; then
      echo "        		  \"relay+mwss://:$inport/$ip:$outport\"" >>$gost_conf_path      
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
  echo -e "\033[33m‖   序号 ‖\t转发方式\t‖    本地端口\t‖\t\t转发地址:远程端口\033[0m"
  echo -e "\033[30m≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡\033[0m"

  count_line=$(awk 'END{print NR}' $raw_conf_path)
  for ((i = 1; i <= $count_line; i++)); do
    trans_conf=$(sed -n "${i}p" $raw_conf_path)
    eachconf_retrieve

    if [ "$model" == "tcpudp" ]; then
      str="不加密中转"
    elif [ "$model" == "tls" ]; then
      str="tls隧道加密"
    elif [ "$model" == "ws" ]; then
      str="ws隧道加密"
    elif [ "$model" == "wss" ]; then
      str="wss隧道加密"
    elif [ "$model" == "mws" ]; then
      str="mws隧道加密"
    elif [ "$model" == "mwss" ]; then
      str="mwss隧道加密"
    elif [ "$model" == "relaytls" ]; then
      str="relay+tls加密"
    elif [ "$model" == "relayws" ]; then
      str="relay+ws加密"
    elif [ "$model" == "relaywss" ]; then
      str="relay+wss加密"
    elif [ "$model" == "relaymws" ]; then
      str="relay+mws加密"
    elif [ "$model" == "relaymwss" ]; then
      str="relay+mwss加密"           
    elif [ "$model" == "peerno" ]; then
      str="不加密均衡负载 "
    elif [ "$model" == "peertls" ]; then
      str="tls隧道均衡负载 "
    elif [ "$model" == "peerws" ]; then
      str="ws隧道均衡负载 "
    elif [ "$modelt" == "peerwss" ]; then
      str="wss隧道均衡负载 "
    elif [ "$model" == "detls" ]; then
      str="tls解密 "      
    elif [ "$model" == "dews" ]; then
      str="ws解密 "
    elif [ "$model" == "dewss" ]; then
      str="wss解密 "
    elif [ "$model" == "demws" ]; then
      str="mws解密 "
    elif [ "$model" == "demwss" ]; then
      str="mwss解密 "   
    elif [ "$model" == "derelaytls" ]; then
      str="relaytls解密 "      
    elif [ "$model" == "derelayws" ]; then
      str="relayws解密 "
    elif [ "$model" == "derelaywss" ]; then
      str="relaywss解密 "
    elif [ "$model" == "derelaymws" ]; then
      str="relaymws解密 "
    elif [ "$model" == "derelaymwss" ]; then
      str="relaymwss解密 "        
    elif [ "$model" == "ss" ]; then
      str=" ss "
    elif [ "$model" == "socks" ]; then
      str="socks5 "
    fi

    echo -e "\033[30m‖    $i   ‖\t$str\t‖\t$inport\t‖\t\t$ip:$outport\\033[30m"
    echo -e "\033[30m≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡\033[0m"
  done
}

#删除Gost规则
Delete_Gost(){
  Check_Gost
  read -p "删除请输入编号回车，输入x返回主菜单。" numd
  if [ "$numd" == "x" ]; then
  start_menu
  elif [ "$numd" == "X" ]; then
  start_menu
  elif [ "$numd" == "" ]; then
  start_menu
  else
  sed -i "${numd}d" $raw_conf_path
  rm -rf /etc/gost/config.json
  Conf_start
  Set_Config
  conflast
  systemctl restart gost
  echo "≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡"
  echo -e "≡≡ ${Green_font_prefix} 配置已删除，服务已重启~ ${Font_color_suffix}≡≡"
  echo "≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡"
  sleep 2s
  clear
  Delete_Gost
  fi
}

#配置SS_SOCK5
ss(){
    read -p "请设置ss密码:" inport
    read -p "请设置ss端口:" outport
    echo -e "\033[0m"    
    Write_rawconf
    rm -rf /etc/gost/config.json
    Conf_start
    Set_Config
    conflast
    systemctl restart gost
    echo -e "${Green_font_prefix} 添加成功！Gost服务已重启~${Font_color_suffix}"
    sleep 2s
    start_menu
}

ss_menu(){
    echo -e "\\033[0;35m请选择加密方式："
    echo -e "[1] aes-128-cfb"
    echo -e "[2] aes-256-cfb"
    echo -e "[3] aes-128-gcm"
    echo -e "[4] aes-256-gcm"
    echo -e "[5] chacha20"
    echo -e "[6] chacha20-ietf"
    echo -e "[7] chacha20-ietf-poly1305"
    echo -e "[8] rc4-md5(不推荐)"
    echo -e "[9] AEAD_CHACHA20_POLY1305(Shadowsocks2才支持，不明白别选)"          
    read -p "请设置ss加密方式:" ip
  if [ "$ip" == "1" ]; then
    ip="aes-128-cfb"
    ss
  elif [ "$ip" == "2" ]; then
    ip="aes-256-cfb"
    ss
  elif [ "$ip" == "3" ]; then
    ip="aes-128-gcm"
    ss
  elif [ "$ip" == "4" ]; then
    ip="aes-256-gcm"
    ss
  elif [ "$ip" == "5" ]; then
    ip="chacha20"   
    ss  
  elif [ "$ip" == "6" ]; then
    ip="chacha20-ietf" 
    ss  
  elif [ "$ip" == "7" ]; then
    ip="chacha20-ietf-poly1305" 
    ss  
  elif [ "$ip" == "8" ]; then
    ip="rc4-md5"  
    ss
  elif [ "$ip" == "9" ]; then
    ip="AEAD_CHACHA20_POLY1305"
    ss                
  else
    echo -e "输入错误，请重新输入~\033[0m"  
    sleep 2s
    ss_menu
  fi
}

socks(){
    echo -e "\\033[0;35m"
    read -p "请输入socks用户名:" ip
    read -p "请输入socks密码:" inport
    read -p "请输入socks端口:" outport
    echo -e "\033[0m"    
    Write_rawconf
    rm -rf /etc/gost/config.json
    Conf_start
    Set_Config
    conflast
    systemctl restart gost
    echo -e "${Green_font_prefix} 添加成功！Gost服务已重启~${Font_color_suffix}"
    sleep 2s
    start_menu
}

ss_socks5(){
  clear
  echo -e "\\033[0;33m请选择代理类型: \033[0m"
  echo -e "\\033[0;35m###########################################################################"
  echo -e "#    1.shadowsocks                                                        #"                                                         
  echo -e "#    2.socks5(强烈建议加隧道用于Telegram代理)                             #"
  echo -e "###########################################################################\033[0m"
  read -p "请选择代理类型: " numproxy
  if [ "$numproxy" == "1" ]; then
    model="ss"
    ss_menu
  elif [ "$numproxy" == "2" ]; then
    model="socks"
    socks
  else
    echo "输入错误, 请重新输入！"
    sleep 2s
    ss_socks5
  fi
}
#简单负载均衡
Load_Balancing(){
echo -e "请设置的均衡负载传输类型: "
  echo -e "-----------------------------------"
  echo -e "[1]  不加密转发"
  echo -e "[2]  普通tls隧道"
  echo -e "[3]  普通ws隧道"
  echo -e "[4]  普通wss隧道"
  echo -e "[5]  普通mws隧道"
  echo -e "[6]  普通mwss隧道" 
  echo -e "[7]  Relay+tls隧道"
  echo -e "[8]  Relay+ws隧道"
  echo -e "[9]  Relay+wss隧道"
  echo -e "[10] Relay+mws隧道"
  echo -e "[11] Relay+mwss隧道"    
  echo -e "注意: 同一则转发，中转与落地传输类型必须对应！本脚本默认同一配置的传输类型相同"
  echo -e "此脚本仅支持简单型均衡负载，具体可参考官方文档"
  echo -e "gost均衡负载官方文档：https://docs.ginuerzh.xyz/gost/load-balancing"
  echo -e "-----------------------------------"
  read -p "请选择转发传输类型: " numpeer

  if [ "$numpeer" == "1" ]; then
    model="peerno"
  elif [ "$numpeer" == "2" ]; then
    model="peertls"
  elif [ "$numpeer" == "3" ]; then
    model="peerws"
  elif [ "$numpeer" == "4" ]; then
    model="peerwss"
  elif [ "$numpeer" == "5" ]; then
    model="peermws"
  elif [ "$numpeer" == "6" ]; then
    model="peermwss"
  elif [ "$numpeer" == "7" ]; then
    model="peerrelaytls"
  elif [ "$numpeer" == "8" ]; then
    model="peerrelayws"
  elif [ "$numpeer" == "9" ]; then
    model="peerrelaywss"
  elif [ "$numpeer" == "10" ]; then
    model="peerrelaymws"
  elif [ "$numpeer" == "11" ]; then
    model="peerrelaymwss"  
  else
    echo -e "${Red_font_prefix} 输入错误，请重新输入！${Font_color_suffix}"
    Load_Balancing
  fi
}
ipport(){
    echo -e "请设置远程服务器端口："
    read -p "请输入端口: " outport
    echo -e "请设置远程服务器域名/IP："
    read -p "请输入域名/IP: " add   
    read -e -p "是否继续添加落地?[y/n]:" addyn
    [[ -z ${addyn} ]] && addyn="y"
    if [[ ${addyn} == [Nn] ]]; then
    echo -e "$add:$outport" >>$ip.txt 
    echo -e "${Green_font_prefix} 配置已添加！${Font_color_suffix}"
    sleep 2s
    else
    echo -e "继续添加均衡负载落地配置"
    ipport
    fi
}

peer_menu(){
    clear
    echo -e "请设置保存文件的名称(譬如：aa 或者 b1,不带文件名后缀！)"
    read -p "请输入文件名: " ip
    touch $ip.txt
    echo -e "请设置本地转发端口"
    read -p "请输入端口: " inport
    while true; do
    echo -e "请设置远程服务器端口"
    read -p "请输入端口: " outport
    echo -e "请设置远程服务器域名/IP："
    read -p "请输入域名/IP: " add
    echo -e "$add:$outport" >>$ip.txt 
    read -e -p "是否继续添加落地？[Y/n]:" addyn
    [[ -z ${addyn} ]] && addyn="y"
    if [[ ${addyn} == [Nn] ]]; then
    echo -e "------------------------------------------------------------------"    
    echo -e "已在root目录创建$ip.txt，手动编辑该文件修改落地信息，重启gost即可生效!"
    break
    else
    echo -e "------------------------------------------------------------------"
    echo -e "继续添加均衡负载落地配置"
    fi
    done
    clear
    echo -e "------------------------------------------------------------------"
    echo -e "选择要设置的均衡负载策略:"
    echo -e "-----------------------------------"
    echo -e "[1] round - 轮询"
    echo -e "[2] random - 随机"
    echo -e "[3] fifo - 自上而下"
    echo -e "-----------------------------------"
    read -p "请选择均衡负载类型: " numstra

    if [ "$numstra" == "1" ]; then
      outport="round"
    elif [ "$numstra" == "2" ]; then
      outport="random"
    elif [ "$numstra" == "3" ]; then
      outport="fifo"
    else
    echo -e "${Red_font_prefix} 输入错误，请重新输入！${Font_color_suffix}"
    peer_menu
    fi
}

#选择转发方式
Choice_Rules(){
  clear
  echo -e "\\033[0;35m#############################\\033[0;33m  请选择转发方式: \033[0m\\033[0;35m############################"
  echo -e "###########################################################################" 
  echo -e "#  1. tcp+udp流量转发, 不带加密     #"  "#  2. 隧道流量解密转发              #" 
  echo -e "#  说明:类似iptables,在中转机执行   #"  "#  说明:该选项在中转机执行          #"
  echo -e "###########################################################################" 
  echo -e "#  3. 隧道流量转发                 #"  "#  4. 一键安装ss/socks5代理          #" 
  echo -e "#  说明:该选项在落地机执行         #"  "#  说明:使用gost内置的代理协议       #"
  echo -e "###########################################################################" 
  echo -e "#                      5. 进阶：多落地均衡负载                            #"                   
  echo -e "#                    说明: 支持各种加密方式的简单均衡负载                 #"
  echo -e "###########################################################################\033[0m" 
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
    peer_menu
    
    Write_rawconf
    rm -rf /etc/gost/config.json
    Conf_start
    Set_Config
    conflast
    systemctl restart gost
    echo -e "${Green_font_prefix} 添加成功！Gost服务已重启~${Font_color_suffix}"
    sleep 2s
    start_menu
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

#定时任务
Restart_Task(){
echo -e "------------------------------------------------------------------"
    echo -e "gost定时重启任务: "
    echo -e "-----------------------------------"
    echo -e "[1] 配置gost定时重启任务"
    echo -e "[2] 删除gost定时重启任务"
    echo -e "-----------------------------------"
    read -p "请选择: " numcron
    if [ "$numcron" == "1" ]; then
        echo -e "------------------------------------------------------------------"
        echo -e "gost定时重启任务类型: "
        echo -e "-----------------------------------"
        echo -e "[1] 每*小时重启"
        echo -e "[2] 每日*点重启"
        echo -e "-----------------------------------"
        read -p "请选择: " numcrontype
        if [ "$numcrontype" == "1" ]; then
            echo -e "-----------------------------------"
            read -p "每*小时重启: " cronhr
            echo "0 0 */$cronhr * * ? * systemctl restart gost" >>/var/spool/cron/crontabs/root
            echo -e "定时重启设置成功！"
        elif [ "$numcrontype" == "2" ]; then
            echo -e "-----------------------------------"
            read -p "每日*点重启: " cronhr
            echo "0 0 $cronhr * * ? systemctl restart gost" >>/var/spool/cron/crontabs/root
            echo -e "定时重启设置成功！"
        else
            echo "输入错误，请重新输入！"
            exit
        fi
    elif [ "$numcron" == "2" ]; then
      sed -i "/gost/d" /var/spool/cron/crontabs/root
      echo -e "定时重启任务删除完成！"
    else
      echo "输入错误，请重新输入！"
      exit
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
	read -p "输入任意键按回车返回主菜单"
     start_menu
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
