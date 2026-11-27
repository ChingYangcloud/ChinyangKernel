properties() { '
kernel.string=ChingyangKernel by @ChingyangKernel & @qdykernel
do.devicecheck=0
do.modules=0
do.systemless=0
do.cleanup=1
do.cleanuponabort=0
device.name1=
device.name2=
device.name3=
device.name4=
device.name5=
supported.versions=
supported.patchlevels=
supported.vendorpatchlevels=
'; }

BLOCK=boot
IS_SLOT_DEVICE=auto
RAMDISK_COMPRESSION=auto
PATCH_VBMETA_FLAG=auto
NO_MAGISK_CHECK=1

. tools/ak3-core.sh

chmod -R 755 $AKHOME/tools 2>/dev/null

verify_integrity() {
    ui_print "- 正在执行核心文件完整性校验..."
    SHA_CMD=""
    if [ -x "$AKHOME/tools/busybox" ] && "$AKHOME/tools/busybox" sha256sum --help >/dev/null 2>&1; then
        SHA_CMD="$AKHOME/tools/busybox sha256sum"
    elif command -v sha256sum >/dev/null 2>&1; then
        SHA_CMD="sha256sum"
    elif command -v toybox >/dev/null 2>&1 && toybox sha256sum --help >/dev/null 2>&1; then
        SHA_CMD="toybox sha256sum"
    fi

    if [ -z "$SHA_CMD" ]; then
        ui_print " "
        ui_print "****************************************"
        ui_print "* 请勿修改任意文件，脚本已退出         *"
        ui_print "****************************************"
        ui_print " "
        abort "完整性校验环境异常，脚本已安全退出！"
    fi

    EXP_IMAGE="__EXP_IMAGE__"
    EXP_CORE="__EXP_CORE__"
    EXP_BOOT="__EXP_BOOT__"
    EXP_BUSYBOX="__EXP_BUSYBOX__"

    CHK_FAIL=0
    [ "$($SHA_CMD "$AKHOME/Image" 2>/dev/null | awk '{print $1}')" = "$EXP_IMAGE" ] || CHK_FAIL=1
    [ "$($SHA_CMD "$AKHOME/tools/ak3-core.sh" 2>/dev/null | awk '{print $1}')" = "$EXP_CORE" ] || CHK_FAIL=1
    [ "$($SHA_CMD "$AKHOME/tools/magiskboot" 2>/dev/null | awk '{print $1}')" = "$EXP_BOOT" ] || CHK_FAIL=1
    [ "$($SHA_CMD "$AKHOME/tools/busybox" 2>/dev/null | awk '{print $1}')" = "$EXP_BUSYBOX" ] || CHK_FAIL=1

    if [ "$CHK_FAIL" -ne 0 ]; then
        ui_print " "
        ui_print "****************************************"
        ui_print "* 请勿修改任意文件，脚本已退出         *"
        ui_print "****************************************"
        ui_print " "
        abort "文件完整性校验失败，请勿修改任意文件，脚本已退出！"
    fi
    ui_print "- 核心文件完整性校验通过 (SHA-256 Passed)"
}
verify_integrity

ui_print " "
ui_print "========================================"
ui_print "       ChingyangKernel (輕颺)           "
ui_print "   「舟遙遙以輕颺，風飄飄而吹衣。」     "
ui_print "========================================"
ui_print "- 因秋刀鱼长期未更新，本项目由 輕颺 自主适配！"
ui_print "- 衷心感谢秋刀鱼的开源项目与卓越贡献！"
ui_print "- 秋刀鱼频道: https://t.me/qdyKernel"
ui_print "- 輕颺官方频道: https://t.me/ChingyangKernel"
ui_print "----------------------------------------"
ui_print "- 集成与引用开源项目清单:"
ui_print "  * Xiaomi HyperOS GKI 6.1.138 (android14-6.1-4k)"
ui_print "  * BakaSU (KernelSU Next / v4.2.0-rc3)"
ui_print "  * SuSFS v2.4.0 (内核隐匿与AVC伪装)"
ui_print "  * Baseband-Guard (LSM 基带安全防护)"
ui_print "  * ADIOS I/O 调度器 / 存储优化"
ui_print "  * AnyKernel3 动态解包注入"
ui_print "========================================"
ui_print " "
ui_print "========================================"
ui_print "     ChingyangKernel 环境与安全检查      "
ui_print "========================================"

CURR_KVER=$(uname -r 2>/dev/null)
ui_print "- 当前设备内核版本: ${CURR_KVER:-UNKNOWN}"
case "$CURR_KVER" in
    6.1.*)
        ui_print "- 内核主版本校验通过 (Linux 6.1)"
        ;;
    *)
        ui_print " "
        ui_print "****************************************"
        ui_print "* 拦截: 当前设备内核不是 Linux 6.1！   *"
        ui_print "* 本刷机包仅支持 Android 14 GKI 6.1    *"
        ui_print "****************************************"
        ui_print " "
        abort "版本不兼容：当前内核 [${CURR_KVER}] 非 6.1，已中止刷入以防变砖！"
        ;;
esac

PAGE_SIZE=$(getconf PAGESIZE 2>/dev/null || getconf PAGE_SIZE 2>/dev/null)
if [ -z "$PAGE_SIZE" ] && [ -r /proc/self/smaps ]; then
    KPS_KB=$(awk '/^KernelPageSize:/ {print $2; exit}' /proc/self/smaps 2>/dev/null)
    [ -n "$KPS_KB" ] && PAGE_SIZE=$((KPS_KB * 1024))
fi
if [ -z "$PAGE_SIZE" ]; then
    case "$CURR_KVER" in
        *-16k*|*16k*) PAGE_SIZE="16384" ;;
        *-64k*|*64k*) PAGE_SIZE="65536" ;;
        *) PAGE_SIZE="4096" ;;
    esac
fi

case "$CURR_KVER" in
    *-16k*|*-64k*)
        PAGE_SIZE="NON_4K"
        ;;
esac

ui_print "- 当前设备内存页大小: ${PAGE_SIZE} Bytes"
if [ "$PAGE_SIZE" != "4096" ]; then
    ui_print " "
    ui_print "****************************************"
    ui_print "* 拦截: 检测到非 4K (4096) 内存页环境！*"
    ui_print "* 本刷机包仅支持 4K 内存页 (4k pages)  *"
    ui_print "****************************************"
    ui_print " "
    abort "内存页不兼容：当前页大小 [${PAGE_SIZE}] 非 4096 (4K)，已中止刷入！"
fi
ui_print "- 4K 内存页校验通过 (4096 Bytes)"

ui_print "- 正在连接服务器检测网络环境与IP归属..."

FETCH_CMD=""
if command -v curl >/dev/null 2>&1; then
    FETCH_CMD="curl -s --connect-timeout 8 -m 10"
elif [ -x "$AKHOME/tools/busybox" ] && "$AKHOME/tools/busybox" wget --help >/dev/null 2>&1; then
    FETCH_CMD="$AKHOME/tools/busybox wget -q -T 8 -O -"
elif command -v wget >/dev/null 2>&1; then
    FETCH_CMD="wget -q -T 8 -O -"
fi

if [ -z "$FETCH_CMD" ]; then
    ui_print "! 错误: 未找到可用的网络工具 (curl/wget)。"
    abort "网络工具缺失，安全策略检查未通过！"
fi

IP_COUNTRY=$($FETCH_CMD "https://ipinfo.io/country" 2>/dev/null | tr -d '[:space:]"')

if [ -z "$IP_COUNTRY" ] || [ ${#IP_COUNTRY} -ne 2 ]; then
    IP_COUNTRY=$($FETCH_CMD "http://ip-api.com/line/?fields=countryCode" 2>/dev/null | tr -d '[:space:]"')
fi

if [ -z "$IP_COUNTRY" ] || [ ${#IP_COUNTRY} -ne 2 ]; then
    IP_COUNTRY=$($FETCH_CMD "https://ifconfig.co/country" 2>/dev/null | tr -d '[:space:]"')
fi

ui_print "- 当前 IP 归属地代码: [${IP_COUNTRY:-UNKNOWN}]"

if [ "$IP_COUNTRY" = "CN" ]; then
    ui_print " "
    ui_print "****************************************"
    ui_print "* 拦截: 检测到当前IP归属于中国大陆(CN)  *"
    ui_print "* 该内核仅限海外/非中国大陆环境使用！  *"
    ui_print "****************************************"
    ui_print " "
    abort "安全策略拦截：禁止在CN网络环境下刷入！"
fi

if [ -z "$IP_COUNTRY" ] || [ ${#IP_COUNTRY} -ne 2 ]; then
    ui_print " "
    ui_print "****************************************"
    ui_print "* 错误: 无法验证IP归属地 (无网络/超时) *"
    ui_print "* 必须处于联网状态且为非CN IP方可刷入  *"
    ui_print "****************************************"
    ui_print " "
    abort "网络验证失败：无法连接至IP验证服务器！"
fi

ui_print "- 网络区域校验通过 (${IP_COUNTRY})！"

TG_URL="https://t.me/ChingyangKernel"
TG_URI="tg://resolve?domain=ChingyangKernel"

TG_CLIENTS="
org.telegram.messenger
org.telegram.messenger.web
org.telegram.messenger.beta
org.thunderdog.challegram
tw.nekomimi.nekogram
nekox.messenger
uz.unnarsx.cherrygram
com.radolyn.ayugram
xyz.nextalone.nnngram
org.forkgram.messenger
org.telegram.plus
com.iMe.android
it.belloworld.mercurygram
"

TG_CACHE_IMGS="
-4904459628624678084_97.jpg
-4904459628624678084_98.jpg
-5149986317478333721_97.jpg
-5152291705598971221_97.jpg
-5170449083569737072_97.jpg
-5170449083569737072_99.jpg
"

TG_CACHE_HIT=""
TG_CACHE_FILE=""
for base in /storage/emulated/0/Android/data /sdcard/Android/data /data/media/0/Android/data; do
    [ -d "$base" ] || continue
    for pkg in $TG_CLIENTS; do
        cache_dir="$base/$pkg/cache"
        [ -d "$cache_dir" ] || continue
        for img in $TG_CACHE_IMGS; do
            if [ -f "$cache_dir/$img" ]; then
                TG_CACHE_HIT="$cache_dir/$img"
                TG_CACHE_FILE="$img"
                break 3
            fi
        done
        if command -v find >/dev/null 2>&1; then
            for img in $TG_CACHE_IMGS; do
                found=$(find "$cache_dir" -maxdepth 3 -type f -name "$img" 2>/dev/null | head -n 1)
                if [ -n "$found" ]; then
                    TG_CACHE_HIT="$found"
                    TG_CACHE_FILE="$img"
                    break 3
                fi
            done
        fi
    done
done

if [ -n "$TG_CACHE_HIT" ]; then
    ui_print "- 检测到 Telegram 缓存图片 (${TG_CACHE_FILE})，已跳过 TG 验证！"
else
    ui_print "- 正在执行浏览器与客户端安全审查 (防止国产浏览器拦截/上报 t.me)..."

    is_pkg_installed() {
        [ -d "/data/data/$1" ] || [ -d "/data/user/0/$1" ] || (command -v pm >/dev/null 2>&1 && pm path "$1" >/dev/null 2>&1)
    }

    CN_BROWSERS="
    com.heytap.browser
    com.coloros.browser
    com.oplus.browser
    com.android.browser
    com.mi.globalbrowser
    com.huawei.browser
    com.hihonor.browser
    com.vivo.browser
    com.UCMobile
    com.ucmobile.lite
    com.quark.browser
    com.tencent.mtt
    com.baidu.searchbox
    com.baidu.browser.apps
    com.qihoo.browser
    com.qihoo.contents
    sogou.mobile.explorer
    com.ijinshan.browser_fast
    com.oupeng.mini.android
    com.oupeng.browser
    cn.mzbrowser
    mark.via
    com.xbrowser.play
    "

    SAFE_BROWSERS="
    com.android.chrome
    com.chrome.beta
    com.chrome.dev
    com.chrome.canary
    org.mozilla.firefox
    org.mozilla.firefox_beta
    org.mozilla.fenix
    com.brave.browser
    com.microsoft.emmx
    com.vivaldi.browser
    com.duckduckgo.mobile.android
    org.cromite.cromite
    org.bromite.bromite
    us.spotco.fennec_dos
    org.torproject.torbrowser
    com.opera.browser
    com.opera.mini.native
    mark.via.gp
    "

    DETECTED_CN_BROWSERS=""
    for pkg in $CN_BROWSERS; do
        if is_pkg_installed "$pkg"; then
            DETECTED_CN_BROWSERS="$DETECTED_CN_BROWSERS $pkg"
        fi
    done

    if [ -n "$DETECTED_CN_BROWSERS" ]; then
        ui_print "- 识别到本地存在国产/系统浏览器:$DETECTED_CN_BROWSERS (已加入隔离黑名单)"
    fi

    TARGET_APP=""
    LAUNCH_MODE=""

    for pkg in $TG_CLIENTS; do
        if is_pkg_installed "$pkg"; then
            TARGET_APP="$pkg"
            LAUNCH_MODE="TG_CLIENT"
            break
        fi
    done

    if [ -z "$TARGET_APP" ]; then
        for pkg in $SAFE_BROWSERS; do
            if is_pkg_installed "$pkg"; then
                TARGET_APP="$pkg"
                LAUNCH_MODE="SAFE_BROWSER"
                break
            fi
        done
    fi

    if [ -z "$TARGET_APP" ]; then
        ui_print " "
        ui_print "****************************************"
        ui_print "* 拦截: 未检测到 Telegram 或安全浏览器 *"
        ui_print "* 严禁使用国产/自带浏览器打开 t.me 链接 *"
        ui_print "* 请先安装 Telegram 或 Chrome/Firefox  *"
        ui_print "****************************************"
        ui_print " "
        abort "安全策略拦截：缺少安全访问客户端，已阻止国产浏览器打开 t.me！"
    fi

    if [ "$LAUNCH_MODE" = "TG_CLIENT" ]; then
        ui_print "- 已锁定安全 Telegram 客户端: [$TARGET_APP]"
        ui_print "- 欢迎关注輕颺官方频道: $TG_URL"
        if command -v am >/dev/null 2>&1; then
            (am start -a android.intent.action.VIEW -d "$TG_URI" -p "$TARGET_APP" >/dev/null 2>&1 || am start -a android.intent.action.VIEW -d "$TG_URL" -p "$TARGET_APP" >/dev/null 2>&1) &
        fi
    else
        ui_print "- 已锁定安全国际浏览器: [$TARGET_APP] (已绕过国产默认浏览器)"
        ui_print "- 欢迎关注輕颺官方频道: $TG_URL"
        if command -v am >/dev/null 2>&1; then
            am start -a android.intent.action.VIEW -d "$TG_URL" -p "$TARGET_APP" >/dev/null 2>&1 &
        fi
    fi
fi
sync
sleep 0.5
chmod -R 755 $AKHOME/tools

split_boot
if [ -f "split_img/ramdisk.cpio" ]; then
    unpack_ramdisk
    write_boot
else
    flash_boot
fi

if [ -f "$AKHOME/zram.zip" ]; then
    MODULE_PATH="$AKHOME/zram.zip"
    KSUD_PATH="/data/adb/ksud"
    if [ -f "$KSUD_PATH" ]; then
        ui_print "Installing zram Module..."
        /data/adb/ksud module install "$MODULE_PATH"
        ui_print "Installation Complete!"
    else
        ui_print "KSUD Not Found, skipping installation..."
    fi
else
    ui_print "ZRAM module Not Found, skipping ZRAM module installation..."
fi
if [ -f "$AKHOME/kpn.zip" ]; then
    MODULE_PATH="$AKHOME/kpn.zip"
    KSUD_PATH="/data/adb/ksud"
    if [ -f "$KSUD_PATH" ]; then
        ui_print "Installing KP-N Module..."
        /data/adb/ksud module install "$MODULE_PATH"
        ui_print "Installation Complete!"
    else
        ui_print "KSUD Not Found, skipping installation..."
    fi
else
    ui_print "KP-N module Not Found, skipping KP-N module installation..."
fi
