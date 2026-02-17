#!/bin/bash

version="Ver2.9.9"
clewd_version="$(grep '"version"' "clewd/package.json" | awk -F '"' '{print $4}')($(grep "Main = 'clewd修改版 v'" "clewd/lib/clewd-utils.js" | awk -F'[()]' '{print $3}'))"
st_version=$(grep '"version"' "SillyTavern/package.json" | awk -F '"' '{print $4}')
echo "hoping：卡在这里了？...说明有小猫没开魔法喵~"
latest_version=$(curl -s https://raw.githubusercontent.com/hopingmiao/termux_using_Claue/main/VERSION)
clewd_latestversion=$(curl -s https://raw.githubusercontent.com/teralomaniac/clewd/test/package.json | grep '"version"' | awk -F '"' '{print $4}')
clewd_subversion=$(curl -s https://raw.githubusercontent.com/teralomaniac/clewd/test/lib/clewd-utils.js | grep "Main = 'clewd修改版 v'" | awk -F'[()]' '{print $3}')
clewd_latest="$clewd_latestversion($clewd_subversion)"
st_latest=$(curl -s https://raw.githubusercontent.com/SillyTavern/SillyTavern/release/package.json | grep '"version"' | awk -F '"' '{print $4}')
 saclinkemoji=$(curl -s https://raw.githubusercontent.com/hopingmiao/termux_using_Claue/main/secret_saclink | awk -F '|' '{print $3 }')
# hopingmiao==hotmiao 

# ANSI Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# 检查是否存在git指令
if command -v git &> /dev/null; then
    echo "git指令存在"
    git --version
else
    echo "git指令不存在，建议回termux下载git喵~"
fi

# 检查是否存在node指令
if command -v node &> /dev/null; then
    echo "node指令存在"
    node --version
else
    echo "node指令不存在，正在尝试重新下载喵~"
    curl -O https://nodejs.org/dist/v22.16.0/node-v22.16.0-linux-arm64.tar.xz
    tar xf node-v22.16.0-linux-arm64.tar.xz
    echo "export PATH=\$PATH:/root/node-v22.16.0-linux-arm64/bin" >>/etc/profile
    source /etc/profile
    if command -v node &> /dev/null; then
        echo "node成功下载"
        node --version                                                
    else
        echo "node下载失败，╮(︶﹏︶)╭，自己尝试手动下载吧"
        exit 1

  fi
fi

#添加termux上的debian/root软链接
if [ ! -d "/data/data/com.termux/files/home/root" ]; then
    if [ -d "/data/data/com.termux/files/usr/var/lib/proot-distro/installed-rootfs/debian/root" ]; then
        ln -s /data/data/com.termux/files/usr/var/lib/proot-distro/installed-rootfs/debian/root /data/data/com.termux/files/home
    elif [ -d "/data/data/com.termux/files/usr/var/lib/proot-distro/installed-rootfs/ubuntu/root" ]; then
        ln -s /data/data/com.termux/files/usr/var/lib/proot-distro/installed-rootfs/ubuntu/root /data/data/com.termux/files/home
    fi
fi

echo "root软链接已添加，可直接在mt管理器打开root文件夹修改文件"

if [ ! -d "SillyTavern" ]; then
    echo "SillyTavern不存在，正在通过git下载..."
    git clone https://github.com/SillyTavern/SillyTavern SillyTavern
    echo -e "\033[0;33m本操作仅为破限下载提供方便，所有破限皆为收录，喵喵不具有破限所有权\033[0m"
    read -p "回车进行导入破限喵~"
    rm -rf /root/st_promot
    git clone https://github.com/hopingmiao/promot.git /root/st_promot
    if  [ ! -d "/root/st_promot" ]; then
        echo -e "(*꒦ິ⌓꒦ີ)\n\033[0;33m hoping：因网络波动预设文件下载失败了，更换网络后再试喵~\n\033[0m"
    else
    cp -r /root/st_promot/. /root/SillyTavern/public/'OpenAI Settings'/
    echo -e "\033[0;33m破限已成功导入，安装完毕后启动酒馆即可看到喵~\033[0m"
    fi
fi

if [ ! -d "clewd" ]; then
	echo "clewd不存在，正在通过git下载..."
	git clone -b test https://github.com/teralomaniac/clewd
	cd clewd
	bash start.sh
        cd /root
elif [ ! -f "clewd/config.js" ]; then
    cd clewd
    bash start.sh
    cd /root
fi

if [ ! -f "clewdr" ]; then
	echo "clewdR不存在，正在下载喵...项目地址：https://github.com/Xerxes-2/clewdr"
	curl -fL "https://github.com/Xerxes-2/clewdr/releases/latest/download/clewdr-android-aarch64.zip" -O
	unzip clewdr-android-aarch64 -d .
	chmod +x clewdr
fi

if [ ! -d "SillyTavern" ]; then
	echo -e "(*꒦ິ⌓꒦ີ)\n\033[0;33m hoping：因网络波动文件下载失败了，更换网络后再试喵~\n\033[0m"
	exit 2
fi

if  [ ! -d "clewd" ] || [ ! -f "clewd/config.js" ]; then
	echo -e "(*꒦ິ⌓꒦ີ)\n\033[0;33m hoping：因网络波动文件下载失败了，更换网络后再试喵~\n\033[0m"
  	rm -rf clewd
	exit 3
fi

function clewdRSettings {
    # ClewdR设置
    echo -e "\033[0;36mhoping：选一个执行，输入其他键可退出喵~\033
[0;33m--------------------------------------\033[0m
\033[0;33m选项1 查看配置文件\033[0m
\033[0;37m选项2 使用 Vim 编辑配置文件\033[0m"
    read -n 1 option
    echo
    case $option in 
        1) 
            # 查看 config.js
            cat clewdr.toml
            ;;
        2)
            # 使用 Vim 编辑 config.js
            vim clewdr.toml
            ;;
        *)
            echo "什么都没有执行喵~"
        ;;
    esac
}

function clewdSettings { 
    # 3. Clewd设置
    if grep -q '"sactag"' "clewd/config.js"; then
        sactag_value=$(grep '"sactag"' "clewd/config.js" | sed -E 's/.*"sactag": *"([^"]+)".*/\1/')
    else
        sactag_value="默认"
    fi
    clewd_dir=clewd
    echo -e "\033[0;36mhoping：选一个执行，输入其他键可退出喵~\033[0m
\033[0;33m当前:\033[0m$clewd_version \033[0;33m最新:\033[0m\033[5;36m$clewd_latest\033[0m \033[0;33mconfig.js:\033[5;37m$sactag_value
\033[0;33m--------------------------------------\033[0m
\033[0;33m选项1 查看 config.js 配置文件\033[0m
\033[0;37m选项2 使用 Vim 编辑 config.js\033[0m
\033[0;33m选项3 添加 Cookies\033[0m
\033[0;37m选项4 修改 Clewd 密码\033[0m
\033[0;33m选项5 修改 Clewd 端口\033[0m
\033[0;37m选项6 修改 Cookiecounter\033[0m
\033[0;33m选项7 修改 rProxy\033[0m
\033[0;37m选项8 修改 PreventImperson状态\033[0m
\033[0;33m选项9 修改 PassParams状态\033[0m
\033[0;37m选项a 修改 padtxt\033[0m
\033[0;33m选项b 切换 config.js配置\033[0m
\033[0;37m选项c 定义 clewd接入模型\033[0m
\033[0;33m选项d 修改 api_rProxy(第三方接口)\033[0m
\033[0;33m--------------------------------------\033[0m
\033[0;31m选项0 更新 clewd(test分支)\033[0m
\033[0;33m--------------------------------------\033[0m
"
    read -n 1 option
    echo
    case $option in 
        1) 
            # 查看 config.js
            cat $clewd_dir/config.js
            ;;
        2)
            # 使用 Vim 编辑 config.js
            vim $clewd_dir/config.js
            ;;
        3) 
            # 添加 Cookies
            echo "hoping：请输入你的cookie文本喵~(回车进行保存，如果全部输入完后按一次ctrl+D即可退出输入):"
            while IFS= read -r line; do
                cookies=$(echo "$line" | grep -E -o '"?sessionKey=[^"]{100,120}AA"?' | tr -d "\"'")
                echo "$cookies"
                if [ -n "$cookies" ]; then
                    echo -e "喵喵猜你的cookies是:\n"
                    echo "$cookies"
                    # Format cookies, one per line with quotes
                    cookies=$(echo "$cookies" | tr ' ' '\n' | sed -e 's/^/"/; s/$/"/g')
                    # Join into array
                    cookie_array=$(echo "$cookies" | tr '\n' ',' | sed 's/,$//')
                    # Update config.js
                    sed -i "/\"CookieArray\"/s/\[/\[$cookie_array\,/" ./$clewd_dir/config.js
                    echo "Cookies已经成功被添加到config.js文件了喵~"
                else
                    echo "你输入了什么，没有找到cookie喵~o(╥﹏╥)o，要不检查一下cookie是不是输错了吧？(如果已经添加成功，要退出输入请按Ctrl+D)"
                fi
            done
            echo "cookies输入结束喵(*^▽^*)"
            ;;
        4) 
            # 修改 Clewd 密码
            read -p "是否修改密码?(y/n)" choice
            if [ "$choice" == "y" ] || [ "$choice" == "Y" ]; then
                # 读取用户输入的新密码
                read -p "请输入新密码\n（不是你本地部署设密码干哈啊？）:" new_pass

                # 修改密码
                sed -i 's/"ProxyPassword": ".*",/"ProxyPassword": "'$new_pass'",/g' $clewd_dir/config.js

                echo "密码已修改为$new_pass"
            else
                echo "未修改密码"
            fi
            ;; 
        5) 
            # 修改 Clewd 端口
            read -p "是否要修改开放端口?(y/n)" choice
            if [ "$choice" == "y" ] || [ "$choice" == "Y" ]; then
                # 读取用户输入的端口号
                read -p "请输入开放的端口号:" custom_port

                # 更新配置文件的端口号
                sed -i 's/"Port": [0-9]*/"Port": '$custom_port'/g' $clewd_dir/config.js
                echo "端口已修改为$custom_port"
            else
                echo "未修改端口号"
            fi
            ;;
        6)  
            # 修改 Cookiecounter
            echo "切换Cookie的频率, 默认为3(每3次切换), 改为-1进入测试Cookie模式"
            read -p "是否要修改Cookiecounter?(y/n)" choice
            if [ "$choice" == "y" ] || [ "$choice" == "Y" ]; then
                # 读取用户输入Cookiecounter
                read -p "请输入需要设置的数值:" cookiecounter

                # 更新配置文件的Cookiecounter
                sed -i 's/"Cookiecounter": .*,/"Cookiecounter": '$cookiecounter',/g' $clewd_dir/config.js
                echo "Cookiecounter已修改为$cookiecounter"
            else
                echo "未修改Cookiecounter"
            fi
            ;;
        7)  
            # 修改 rProxy
            echo -e "\n1. 官网地址claude.ai\n2. 国内镜像地址finechat.ai\n3. 自定义地址\n0. 不修改"
            read -p "输入选择喵：" choice
            case $choice in 
                1)  
                    sed -i 's/"rProxy": ".*",/"rProxy": "",/g' $clewd_dir/config.js
                    ;; 
                2) 
                    sed -i 's#"rProxy": ".*",#"rProxy": "https://chat.finechat.ai",#g' $clewd_dir/config.js
                    ;; 
                3)
                    # 读取用户输入rProxy
                    read -p "请输入需要设置的数值:" rProxy
                    # 更新配置文件的rProxy
                    sed -i 's#"rProxy": ".*",#"rProxy": "'$rProxy'",#g' $clewd_dir/config.js
                    echo "rProxy已修改为$rProxy"
                    ;; 
                *) 
                    echo "不修改喵~"
                    break ;; 
            esac
            ;;
        8)
            PreventImperson_value=$(grep -oP '"PreventImperson": \K[^,]*' clewd/config.js)
            echo -e "当前PreventImperson值为\033[0;33m $PreventImperson_value \033[0m喵~"
            read -p "是否进行更改[y/n]" PreventImperson_choice
            if [ $PreventImperson_choice == "Y" ] || [ $PreventImperson_choice == "y" ]; then
                if [ $PreventImperson_value == 'false' ];
    then
                    #将false替换为true
                    sed -i 's/"PreventImperson": false,/"PreventImperson": true,/g' $clewd_dir/config.js
                    echo -e "hoping：'PreventImperson'已经被修改成\033[0;33m true \033[0m喵~."
                elif [ $PreventImperson_value == 'true' ];
    then
                    #将true替换为false
                    sed -i 's/"PreventImperson": true,/"PreventImperson": false,/g' $clewd_dir/config.js
                    echo -e "hoping：'PreventImperson'值已经被修改成\033[0;33m false \033[0m喵~."
                else
                    echo -e "呜呜X﹏X\nhoping喵未能找到'PreventImperson'."
                fi
            else
                echo "未进行修改喵~"
            fi
            ;;
        9)
            PassParams_value=$(grep -oP '"PassParams": \K[^,]*' clewd/config.js)
            echo -e "当前PassParams值为\033[0;33m $PassParams_value \033[0m喵~"
            read -p "是否进行更改[y/n]" PassParams_choice
            if [ $PassParams_choice == "Y" ] || [ $PassParams_choice == "y" ]; then
                if [ $PassParams_value == 'false' ];
    then
                    #将false替换为true
                    sed -i 's/"PassParams": false,/"PassParams": true,/g' $clewd_dir/config.js
                    echo -e "hoping：'PassParams'已经被修改成\033[0;33m true \033[0m喵~."
                elif [ $PassParams_value == 'true' ];
    then
                    #将true替换为false
                    sed -i 's/"PassParams": true,/"PassParams": false,/g' $clewd_dir/config.js
                    echo -e "hoping：'PassParams'值已经被修改成\033[0;33m false \033[0m喵~."
                else
                    echo -e "呜呜X﹏X\nhoping喵未能找到'PassParams'."
                fi
            else
                echo "未进行修改喵~"
            fi
            ;;
        a)
            current_values=$(grep '"padtxt":' clewd/config.js | sed -e 's/.*"padtxt": "\(.*\)".*/\1/')
            echo -e "当前的padtxt值为: \033[0;33m$current_values\033[0m"
            echo -e "请输入新的padtxt值喵，格式如：1000,1000,15000"
            read new_values
            sed -i "s/\"padtxt\": \([\"'][^\"']*[\"']\|[0-9]\+\)/\"padtxt\": \"$new_values\"/g" clewd/config.js
            echo -e "更新后的padtxt值: \033[0;36m$(grep '"padtxt":' clewd/config.js | sed -e 's/.*"padtxt": "\(.*\)".*/\1/')\033[0m"
            ;;
        b)
            # Check if 'sactag' is already in the Settings
            cd /root/clewd
            if grep -q '"sactag"' "config.js"; then
                sactag_value=$(grep '"sactag"' "config.js" | sed -E 's/.*"sactag": *"([^"]+)".*/\1/')
            else
                # Add 'sactag' to the Settings
                sed -i'' -e '/"Settings": {/,/}/{ /[^,]$/!b; /}/i\        ,"sactag": "默认"' -e '}' "config.js"
                sactag_value="默认"
            fi
            
            print_selected() {
            echo -e "\033[0;33m--------------------------------\033[0m"
            echo -e "\033[0;33m使用上↑，下↓进行控制\n\033[0m回车选择。"
            echo -e "喵喵当前正在使用: \033[5;36m$sactag_value\033[0m"
            }
            
            configbak=() # 初始化一个空数组
            for file in config_*.js; do
                # 提取每个文件名中的 * 部分，需要去掉 'config_' 和 '.js'
                config_string="${file#config_}"
                config_string="${config_string%.js}"
                # 将提取后的字符串添加到数组中
                configbak+=("$config_string")
            done
            # 输出数组内容以验证结果
            echo "${configbak[@]}"
            modules=("${configbak[@]}")
            modules+=(新建 删除 取消)
            
            declare -A selection_status
            for i in "${!modules[@]}"; do
                selection_status[$i]=0
            done
            
            show_menu() {
                print_selected
            	echo -e "\033[0;33m--------------------------------\033[0m"
            	for i in "${!modules[@]}"; do
            	    if [[ "$i" -eq "$current_selection" ]]; then
            		  # 当前选择中的选项使用绿色显示
            		  echo -e "${GREEN}${modules[$i]}${NC}"
            		else
            		  # 其他选项正常显示
            		  echo -e "${modules[$i]} (未选择)"
            		fi
            	done
            	echo -e "\033[0;33m--------------------------------\033[0m"
            }
            
            clear
            current_selection=1
            while true; do
                show_menu
            	# 读取用户输入
            	IFS= read -rsn1 key
            
            	case "$key" in
                    $'\x1b')
            		# 读取转义序列
            		read -rsn2 -t 0.1 key
            		case "$key" in
            	        '[A') # 上箭头
            			  if [[ $current_selection -eq 0 ]]; then
            				current_selection=$((${#modules[@]} - 1))
            			  else
            				((current_selection--))
            			  fi
            			  ;;
            			'[B') # 下箭头
            			  if [[ $current_selection -eq $((${#modules[@]} - 1)) ]]; then
            				current_selection=0
            			  else
            				((current_selection++))
            			  fi
            			  ;;
            		  esac
            		  ;;
            		"") # Enter键
            		  if [[ $current_selection -eq $((${#modules[@]} - 3)) ]]; then
            			#创建新配置
                        echo "给新的config.js命名喵~"
                        while :
                        do
                            read newsactag
                            [ -n "$newsactag" ] && break
                            echo "命名不能为空，快重新输入🐱喵~"
                        done
                        mv config.js "config_$sactag_value.js"
                        ps -ef | grep clewd.js | awk '{print$2}' | xargs kill -9
                        bash start.sh
                        sed -i'' -e "/\"Settings\": {/,/}/{ /[^,]$/!b; /}/i\\        ,\"sactag\": \"$newsactag\"" -e '}' "config.js"
                        cd /root
                        clewdSettings
                        break
                      elif [[ $current_selection -eq $((${#modules[@]} - 2)) ]]; then
                        #删除config.js
                        echo "输入需要删除的配置名称喵~"
                        echo "当前存在"
                        echo "${configbak[@]}"
                        while :
                        do
                            read delsactag
                            configfile=$(ls config_$delsactag.js 2>/dev/null)
                            [ -n "$configfile" ] && break
                            echo "没找到对应配置，检查一下名称是不是输错了喵~"
                        done
                        rm -rf $configfile
                        cd /root
                        break
            		  elif [[ $current_selection -eq $((${#modules[@]} - 1)) ]]; then
            			# 选择 "退出" 选项
            			echo "当前并未选择"
            			cd /root
            			break
            		  else
            			# 切换config.js
            			mv config.js "config_$sactag_value.js"
            			mv "config_${modules[$current_selection]}.js" config.js
            			echo -e "config文件成功切换为：\033[5;36m$(grep '"sactag"' "config.js" | sed -E 's/.*"sactag": *"([^"]+)".*/\1/')\033[0m"
            			sleep 2
            			cd /root
            			break
            		  fi
            		  ;;
            		'q') # 按 'q' 退出
            		  cd /root
            		  break
            		  ;;
            	esac
            	# 清除屏幕以准备下一轮显示
            	clear
            done
            cd ~
            ;;
        c)
            echo "是否添加自定义模型喵[y/n]？"
            read cuschoice
            if [[ "$cuschoice" == [yY] ]]; then
                echo "输入自定义的模型名称喵~"
                read model_name
                sed -i "/((name => ({ id: name }))), {/a\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ id: '$model_name'},{" clewd/clewd.js
            else
                echo "并未添加自定义模型喵~"
            fi
            ;;
        d)
            # 修改 api_rProxy
            echo -e "是否修改api_rProxy地址喵~?"[y/n]
            read  choice
            case $choice in  
                [yY])
                    # 读取用户输入rProxy
                    read -p "请输入需要设置代理地址喵~:" api_rProxy
                    # 更新配置文件的rProxy
                    sed -i 's#"api_rProxy": ".*",#"api_rProxy": "'$api_rProxy'",#g' $clewd_dir/config.js
                    echo "api_rProxy已修改为$api_rProxy"
                    ;; 
                *) 
                    echo "不修改喵~"
                    ;; 
            esac
            ;;
        0)
			echo -e "hoping：选择更新模式(两种模式都会保留重要数据)喵~\n\033[0;33m--------------------------------------\n\033[0m\033[0;33m选项1 使用git pull进行简单更新\n\033[0m\033[0;37m选项2 几乎重新下载进行全面更新\n\033[0m"
            read -n 1 -p "" clewdup_choice
			echo
			cd /root
			case $clewdup_choice in
				1)
					cd /root/clewd
					git checkout -b test origin/test
					git pull
					;;
				2)
					git clone -b test https://github.com/teralomaniac/clewd.git /root/clewd_new
					if [ ! -d "clewd_new" ]; then
						echo -e "(*꒦ິ⌓꒦ີ)\n\033[0;33m hoping：因为网络波动下载失败了，更换网络再试喵~\n\033[0m"
						exit 5
					fi
					cp -r clewd/config*.js clewd_new/
					if [ -f "clewd_new/config.js" ]; then
						echo "config.js配置文件已转移，正在删除旧版clewd"
						rm -rf /root/clewd
						mv clewd_new clewd
					fi
					;;
			esac
			clewd_version="$(grep '"version"' "clewd/package.json" | awk -F '"' '{print $4}')($(grep "Main = 'clewd修改版 v'" "clewd/lib/clewd-utils.js" | awk -F'[()]' '{print $3}'))"
            ;;
        *)
            echo "什么都没有执行喵~"
            ;;
    esac
}

function sillyTavernSettings {
    # 4. SillyTavern设置
	echo -e "\033[0;36mhoping：选一个执行，输入其他键可退出喵~\033[0m
\033[0;33m当前版本:\033[0m$st_version \033[0;33m最新版本:\033[0m\033[5;36m$st_latest\033[0m
\033[0;33m--------------------------------------\033[0m
\033[0;33m选项1 安装 TavernAI-extras（酒馆拓展）\033[0m
\033[0;37m选项2 启动 TavernAI-extras（酒馆拓展）\033[0m
\033[0;33m选项3 修改 酒馆端口\033[0m
\033[0;37m选项4 导入 最新整合预设\033[0m
\033[0;33m选项5 自定义 模型名称\033[0m
\033[0;37m选项6 自定义 unlock上下文长度\033[0m
\033[0;33m选项7 删除 旧版本酒馆(不包括上一版本)\033[0m
\033[0;37m选项8 回退 上一版本酒馆\033[0m
\033[0;33m选项9 导出 当前版本酒馆\033[0m
\033[0;37m选项a 重新安装依赖\033[0m
\033[0;33m--------------------------------------\033[0m
\033[0;31m选项0 更新酒馆\033[0m
\033[0;33m--------------------------------------\033[0m
"
    read -n 1 option
    echo
    case $option in 
        0)
			echo -e "hoping：选择更新模式(重要数据会进行转移，但喵喵最好自己有备份)喵~\n\033[0;33m--------------------------------------\n\033[0m\033[0;33m选项1 使用git pull进行简单更新\n\033[0m\033[0;37m选项2 几乎重新下载进行全面更新\n\033[0m"
            read -n 1 -p "" stup_choice
			echo
			cd /root
			case $stup_choice in
				1)
					cd /root/SillyTavern
					git pull
					;;
				2)
					if [ -d "SillyTavern_old" ]; then                                   
						NEW_FOLDER_NAME="SillyTavern_$(date +%Y%m%d)"
						mv SillyTavern_old $NEW_FOLDER_NAME
					fi                                                                
					echo -e "
hoping：选择版本或者输入版本号喵？
\033[0;33m选项1 正式版\033[0m
\033[0;37m选项2 测试版\033[0m
\033[0;33m自定义版本格式：x.y.z\033[0m"
					while :
					do
					    read stupdate
					    [ "$stupdate" = 1 ] && { git clone https://github.com/SillyTavern/SillyTavern.git SillyTavern_new; break; }
					    [ "$stupdate" = 2 ] && { git clone -b staging https://github.com/SillyTavern/SillyTavern.git SillyTavern_new; break; }
                        [[ "$stupdate" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] && { git clone -b "$stupdate" https://github.com/SillyTavern/SillyTavern.git SillyTavern_new; break; }
					    echo -e "\n\033[5;33m选择错误，快快重新选择喵~\033[0m"
					done

					if [ ! -d "SillyTavern_new" ]; then
						echo -e "(*꒦ິ⌓꒦ີ)\n\033[0;33m hoping：因为网络波动下载失败了，更换网络再试喵~\n\033[0m"
						exit 5
					fi
					
					if [ -d "SillyTavern/data/default-user" ]; then
					    cp -r SillyTavern/data/. SillyTavern_new/data/
					else
    					cp -r SillyTavern/public/characters/. SillyTavern_new/public/characters/
    					cp -r SillyTavern/public/chats/. SillyTavern_new/public/chats/       
    					cp -r SillyTavern/public/worlds/. SillyTavern_new/public/worlds/
    					cp -r SillyTavern/public/groups/. SillyTavern_new/public/groups/
    					cp -r SillyTavern/public/group\ chats/. SillyTavern_new/public/group\ chats/
    					cp -r SillyTavern/public/OpenAI\ Settings/. SillyTavern_new/public/OpenAI\ Settings/
    					cp -r SillyTavern/public/User\ Avatars/. SillyTavern_new/public/User\ Avatars/
    					cp -r SillyTavern/public/backgrounds/. SillyTavern_new/public/backgrounds/
    					cp -r SillyTavern/public/settings.json SillyTavern_new/public/settings.json
					fi
					
					mv SillyTavern SillyTavern_old                                  
					mv SillyTavern_new SillyTavern
					echo -e "\033[0;33mhoping：酒馆已更新完毕，启动后若丢失聊天请回退上一版本喵~\033[0m"
					;;
			esac
			st_version=$(grep '"version"' "SillyTavern/package.json" | awk -F '"' '{print $4}')
            ;;
        1)
            #安装TavernAI-extras（酒馆拓展）及其环境
			TavernAI-extrasinstall
            ;;
        2)
            #启动TavernAI-extras（酒馆拓展）
			TavernAI-extrasstart
            ;;
		3)
			if [ ! -f "SillyTavern/config.yaml" ]; then
				echo -e "当前酒馆版本过低，请更新酒馆版本后重试"
				exit
			fi
            read -p "是否要修改开放端口?(y/n)" choice

            if [ "$choice" == "y" ] || [ "$choice" == "Y" ]; then
                # 读取用户输入的端口号
                read -p "请输入开放的端口号:" custom_port
                # 更新配置文件的端口号
                sed -i 's/port: [0-9]*/port: '$custom_port'/g' SillyTavern/config.yaml
                echo "端口已修改为$custom_port"
            else
                echo "未修改端口号"
            fi
            ;;
        4)
            #导入破限
            echo -e "$(curl -s https://raw.githubusercontent.com/hopingmiao/promot/main/STpromotINFO)"
            echo "是否导入当前预设喵？[y/n]"
            read choice
            if [[ "$choice" == [yY] ]]; then
                echo -e "\033[0;33m本操作仅为破限下载提供方便，所有破限皆为收录，喵喵不具有破限所有权\033[0m"
                sleep 2
                rm -rf /root/st_promot
                git clone https://github.com/hopingmiao/promot.git /root/st_promot
                if  [ ! -d "/root/st_promot" ]; then
                    echo -e "(*꒦ິ⌓꒦ີ)\n\033[0;33m hoping：因网络波动文件下载失败了，更换网络后再试喵~\n\033[0m"
                exit 6
                fi
                cp -r /root/st_promot/. /root/SillyTavern/public/'OpenAI Settings'/
                echo -e "\033[0;33m破限已成功导入，启动酒馆看看喵~\033[0m"
            else
                echo "当前预设未导入喵~"
            fi
            ;;
        5)
            echo -e "\033[5;33m当前存在自定义模型有：\033[0m"
            echo -e "$(sed -n '/<optgroup label="自定义">/,/<optgroup label="GPT-3.5 Turbo">/{s/.*<option value="\([^"]*\)".*/\1/p}' SillyTavern/public/index.html)"
            echo "是否添加自定义模型喵[y/n]？"
            read cuschoice
            if [[ "$cuschoice" == [yY] ]]; then
                echo "输入自定义的模型名称喵~"
                read CUSTOM_INPUT_VALUE
                grep -q '<optgroup label="自定义">' "SillyTavern/public/index.html" && sed -i "/<optgroup label=\"自定义\">/a\ \ \ \ <option value=\"$CUSTOM_INPUT_VALUE\">$CUSTOM_INPUT_VALUE</option>" "SillyTavern/public/index.html" || { sed -i "/<optgroup label=\"GPT-3.5 Turbo\">/i\<optgroup label=\"自定义\">\n\ \ \ \ <option value=\"$CUSTOM_INPUT_VALUE\">$CUSTOM_INPUT_VALUE</option>\n</optgroup>" "SillyTavern/public/index.html"; sed -i "/<optgroup label=\"Versions\">/i\<optgroup label=\"自定义\">\n\ \ \ \ <option value=\"$CUSTOM_INPUT_VALUE\">$CUSTOM_INPUT_VALUE</option>\n</optgroup>" "SillyTavern/public/index.html"; }
                echo -e "\033[0;33m已添加$CUSTOM_INPUT_VALUE模型喵~\033[0m"
            else
                echo "并未添加喵~"
            fi
            sleep 2
            ;;
        6)
            unlocked_max=$(sed -n 's/^const unlocked_max = \(.*\);$/\1/p' SillyTavern/public/scripts/openai.js)
            echo "当前unlocked_max(最大上下文)为$unlocked_max喵~"
            echo "是否修改最大上下文喵？[y/n]"
            read unlockedchoice
            if [[ "$unlockedchoice" == [yY] ]]; then
                echo "输入unlocked_max值，例如200000"
                read unlocked_max
                sed -i "s/^const unlocked_max = .*;/const unlocked_max = ${unlocked_max};/" "SillyTavern/public/scripts/openai.js"
            else
                echo "并未修改喵~"
            fi
            ;;
        7)
            echo -e "当前存在"
            ls | grep "^SillyTavern_\([^o].*\|..+\.?.*\)$"
            echo -e "是否删除所有旧版本酒馆喵？"
            read delSTChoice
            [[ "$delSTChoice" == [yY] ]] && { echo -e "开始删除喵~"; ls | grep "^SillyTavern_\([^o].*\|..+\.?.*\)$" | xargs -d"\n" rm -r; echo -e "旧版本酒馆删除完成了喵~"; } || echo "什么都没有执行喵~" >&2
            ;;
        8)
            while :
            do
                [ ! -d SillyTavern_old ] && { echo -e "hoping：当前未检查到上一版本喵~"; break; }
                echo -e "版本正在回退中，请稍等喵~"
                mv SillyTavern SillyTavern_temp
                mv SillyTavern_old SillyTavern
                mv SillyTavern_temp SillyTavern_old
                echo -e "hoping：版本回退成功了喵~"
                st_version=$(grep '"version"' "SillyTavern/package.json" | awk -F '"' '{print $4}')
                break   
            done
            ;;
        9)
            [ ! command -v zip &> /dev/null ] && { DEBIAN_FRONTEND=noninteractive apt install zip -y; }
            echo -e "\033[0;33m压缩文件中，请稍等喵~\033[0m"
            rm -rf SillyTavern.zip
            zip -rq SillyTavern.zip SillyTavern/
            echo -e "文件压缩完成"
            python -m http.server 8976 &
            echo -e "hoping：\033[0;33m十秒后将关闭网页并回到主页面喵~\033[0m"
            termux-open-url http://127.0.0.1:8976/SillyTavern.zip
            sleep 10
            rm -rf SillyTavern.zip
            pkill -f 'python -m http.server'
            ;;
        a)
            echo -e "重新下载依赖中，请确保网络环境正常，如失败请更换节点"
            cd SillyTavern/
            rm -rf node_modules
            npm install
            cd ~/
            ;;
        *)
            echo "什么都没有执行喵~"
            ;;
    esac
}

function TavernAI-extrasinstall {

	echo -e "安装TavernAI-extras（酒馆拓展）分为三步骤\n分别大致所需\n三分钟\n\033[0;33m七分钟\n\033[0m\033[0;31m十五分钟\n\033[0m具体时间视情况而定\n\033[0;31m全部安装大致所需\033[0;33m 3 \033[0m\033[0;31mG存储(不包括额外模型)\033[0m"
	echo -e "当出现\n\033[0;32m恭喜TavernAI-extras（酒馆拓展）所需环境已完全安装，可进行启动喵~\033[0m\n则说明安装完毕喵~"
	read -p "是否现在进行安装TavernAI-extras（酒馆拓展）[y/n]？" extrasinstallchoice
	[ "$extrasinstallchoice" = "y" ] || [ "$extrasinstallchoice" = "Y" ] && echo "已开始安装喵~" || exit 7
	#检测环境
	if [ ! -d "/root/TavernAI-extras" ]; then
		echo "hoping:未检测到TavernAI-extras（酒馆拓展），正在通过git下载"
		git clone https://github.com/Cohee1207/TavernAI-extras /root/TavernAI-extras
		[ -d /root/TavernAI-extras ] || { echo "TavernAI-extras（酒馆拓展）安装失败，请更换网络后重试喵~"; exit 8; }
	fi
	
	if [ ! -d "/root/myenv" ] || [ ! -f "/root/myenv/bin/activate" ]; then
		rm -rf /root/myenv
		# 更新软件包列表并安装所需软件包，重定向输出。
		echo "正在更新软件包列表..."
		apt update -y > /dev/null 2>&1

		echo -e "\033[0;33m正在安装python3虚拟环境，请稍候\n\033[0;33m(hoping：首次安装大概需要7到15分钟喵~)..."
		read -p "是否现在进行安装喵？[y/n]" python3venvchoicce
		[ "$python3venvchoicce" = "y" ] || [ "$python3venvchoicce" = "Y" ] && DEBIAN_FRONTEND=noninteractive apt install python3 python3-pip python3-venv -y || exit 9
		echo "python3虚拟环境安装完成。正在创建虚拟环境"
		python3 -m venv /root/myenv
		echo "虚拟环境完成，路径为/root/myenv"
	fi
	echo -e "\033[0;31m正在安装requirements.txt所需依赖\n\033[0m(hoping：首次安装大概需要15至30分钟，最后构建时会出现长时间页面无变化，请耐心等待喵~)..."
	read -p "是否现在进行安装喵？[y/n]" requirementschoice
	[ "$requirementschoice" = "y" ] || [ "$requirementschoice" = "Y" ] && { source /root/myenv/bin/activate; cd /root/TavernAI-extras; pip3 install -r requirements.txt; } || exit 10
	echo -e "喵喵？\n\033[0;32m恭喜TavernAI-extras（酒馆拓展）所需环境已完全安装，可进行启动喵~\033[0m"
	
}

function TavernAI-extrasstart {

	if [ ! -d "/root/TavernAI-extras" ] || [ ! -d "/root/myenv" ] || [ ! -f "/root/myenv/bin/activate" ]; then
	echo "检测到当前环境不完整，先进行TavernAI-extras（酒馆拓展）安装喵~"
	exit 11
	fi
	echo -e "\033[0;33m喵喵小提示：\n\033[0m启动对应拓展时可能需要额外下载，具体情况可以查看官方文档喵~"
	sleep 3
	
	#进入虚拟环境
	source /root/myenv/bin/activate
	cd /root/TavernAI-extras
	#确认依赖已安装
	echo -e "正在检测依赖安装情况喵~"
	pip3 install -r requirements.txt
	clear
	
	# 选项数组
	modules=("caption" "chromadb" "classify" "coqui-tts" "edge-tts" "embeddings" "rvc" "sd" "silero-tts" "summarize" "talkinghead" "websearch" "确认" "退出")

	# 数组中选项的状态，0 - 未选择，1 - 已选定
	declare -A selection_status

	# 初始化选项状态
	for i in "${!modules[@]}"; do
	  selection_status[$i]=0
	  selection_status[4]=1
	done

	# 函数：打印已选中的选项
	print_selected() {
	  selected_modules=()
	  for i in "${!selection_status[@]}"; do
		if [[ "${selection_status[$i]}" -eq 1 ]]; then
		  selected_modules+=("${modules[$i]}")
		fi
	  done
	  echo -e "\033[0;33m--------------------------------\033[0m"
	  echo -e "\033[0;33m使用上↑，下↓进行控制\n\033[0m回车选中，再次选中可取消选定\n\033[0;33m选择完毕后选择确认即可喵~\033[0m"
	  echo "喵喵当前选择了: $(IFS=,; echo -e "\033[0;36m${selected_modules[*]}\033[0m")"
	}

	# 函数：显示菜单
	show_menu() {
	  print_selected
	  echo -e "\033[0;33m--------------------------------\033[0m"
	  for i in "${!modules[@]}"; do
		if [[ "$i" -eq "$current_selection" ]]; then
		  # 当前选择中的选项使用绿色显示
		  echo -e "${GREEN}${modules[$i]} (选择中)${NC}"
		elif [[ "${selection_status[$i]}" -eq 1 ]]; then
		  # 被选定的选项使用红色显示
		  echo -e "${RED}${modules[$i]} (已选定)${NC}"
		else
		  # 其他选项正常显示
		  echo -e "${modules[$i]} (未选择)"
		fi
	  done
	  echo -e "\033[0;33m--------------------------------\033[0m"
	}

	current_selection=0
	while true; do
	  show_menu
	  # 读取用户输入
	  IFS= read -rsn1 key

	  case "$key" in
		$'\x1b')
		  # 读取转义序列
		  read -rsn2 -t 0.1 key
		  case "$key" in
			'[A') # 上箭头
			  if [[ $current_selection -eq 0 ]]; then
				current_selection=$((${#modules[@]} - 1))
			  else
				((current_selection--))
			  fi
			  ;;
			'[B') # 下箭头
			  if [[ $current_selection -eq $((${#modules[@]} - 1)) ]]; then
				current_selection=0
			  else
				((current_selection++))
			  fi
			  ;;
		  esac
		  ;;
		"") # Enter键
		  if [[ $current_selection -eq $((${#modules[@]} - 2)) ]]; then
			# 选择 "确认" 选项
			break
		  elif [[ $current_selection -eq $((${#modules[@]} - 1)) ]]; then
			# 选择 "退出" 选项
			exit 12
		  else
			# 切换选择状态
			selection_status[$current_selection]=$((1 - selection_status[$current_selection]))
		  fi
		  ;;
		'q') # 按 'q' 退出
		  break
		  ;;
	  esac
	  # 清除屏幕以准备下一轮显示
	  clear
	done

	# 构建命令行
	command="python3 server.py"
	if [ ${#selected_modules[@]} -ne 0 ]; then
	  command+=" --enable-module=$(IFS=,; echo "${selected_modules[*]}")"
	fi

	# 打印最终的命令行
	clear
	echo "正在启动相关酒馆拓展喵~:"
	echo "$command"
	eval $command
	
	
	
}
# 主菜单
echo -e "                                              
喵喵一键脚本
作者：hoping喵(懒喵~)，水秋喵(苦等hoping喵起床)
版本：酒馆:$st_version clewd:$clewd_version 脚本:$version
最新：\033[5;36m酒馆:$st_latest\033[0m \033[5;32mclewd:$clewd_latest\033[0m \033[0;33m脚本:$latest_version\033[0m
来自：Claude先行破限组
群号：704819371，910524479，304690608
类脑Discord: https://discord.gg/HWNkueX34q
相关教程：https://sqivg8d05rm.feishu.cn/wiki/EY5TwjuwliCwZpk7Gy7cPGH1nvb
此程序完全免费，不允许对脚本/教程进行盗用/商用。运行时需要稳定的魔法网络环境。"
while :
do 
    echo -e "\033[0;36mhoping喵~让你选一个执行（输入数字即可），懂了吗？\033[0;38m(｡ì _ í｡)\033[0m\033[0m
\033[0;33m--------------------------------------\033[0m
\033[0;33m选项0 启动ClewdR\033[0m
\033[0;37m选项1 启动Clewd\033[0m
\033[0;33m选项2 启动酒馆\033[0m
\033[0;37m选项3 Clewd设置\033[0m
\033[0;33m选项4 酒馆设置\033[0m
\033[0;37m选项5 ClewdR设置\033[0m
\033[0;33m选项6 神秘小链接$saclinkemoji\033[0m
\033[0;33m--------------------------------------\033[0m
\033[0;37m选项7 更新脚本\033[0m
\033[0;31m选项8 退出脚本\033[0m
\033[0;33m--------------------------------------\033[0m
\033[0;35m不准选其他选项，听到了吗？
\033[0m\n(⇀‸↼‶)"
    read -n 1 option
    echo 
    case $option in 
        0) 
            #启动ClewdR
            if [ ! -f "clewdr" ]; then
	            echo "正在下载喵...项目地址：https://github.com/Xerxes-2/clewdr"
	            curl -fL "https://github.com/Xerxes-2/clewdr/releases/latest/download/clewdr-android-aarch64.zip" -O
	            unzip clewdr-android-aarch64 -d .
	            chmod +x clewdr
            fi
            echo "ClewdR启动中喵，如果需要退出，请点击Ctrl+C。"
            ./clewdr
            echo "ClewdR已关闭, 即将返回主菜单"
            ;;
        1) 
            #启动Clewd
            port=$(grep -oP '"Port":\s*\K\d+' clewd/config.js)
            echo "端口为$port, 出现 (x)Login in {邮箱} 代表启动成功, 后续出现AI无法应答等报错请检查本窗口喵，可使用Ctrl+C退出Clewd。"
			ps -ef | grep clewd.js | awk '{print$2}' | xargs kill -9
            cd clewd
            bash start.sh
            echo "Clewd已关闭, 即将返回主菜单"
            cd ../
            ;; 
        2) 
            #启动SillyTavern
            echo "酒馆启动中，可使用Ctrl+C退出酒馆。"
			ps -ef | grep server.js | awk '{print$2}' | xargs kill -9
            cd SillyTavern
	        bash start.sh 
            echo "酒馆已关闭, 即将返回主菜单"
            cd ../
            ;; 
        3) 
            #Clewd设置
            clewdSettings
            ;; 
        4) 
            #SillyTavern设置
            sillyTavernSettings
            ;; 
		5) 
            #ClewdR设置
            clewdRSettings
            ;;
		6)
			saclinkname=$(curl -s https://raw.githubusercontent.com/hopingmiao/termux_using_Claue/main/secret_saclink | awk -F '|' '{print $1 }')
			echo -e "神秘小链接会不定期悄悄更新，这次的神秘小链接是..."
			sleep 2
			echo $saclinkname
			termux-open-url $(curl -s https://raw.githubusercontent.com/hopingmiao/termux_using_Claue/main/secret_saclink | awk -F '|' '{print $2 }')
			;;
        7)
            # 更新脚本
            echo -e "该选项仅用于更新脚本，如需更新Clewd或酒馆，请在对应设置里选择喵~"
            curl -O https://raw.githubusercontent.com/hopingmiao/termux_using_Claue/main/sac.sh
	        echo -e "重启终端或者输入bash sac.sh重新进入脚本喵~"
            break ;;
        8) 
            echo -e "重启终端或者输入bash sac.sh重新进入脚本喵~"
            break ;;
        *) 
            echo -e "m9( ｀д´ )!!!! \n\033[0;36m坏猫猫居然不听话，存心和我hoping喵~过不去是吧？\033[0m\n"
            ;;
    esac
done 
echo "已退出喵喵一键脚本，输入 bash sac.sh 可重新进入脚本喵~"
exit
