import QtQuick 2.15

QtObject {
    function toBillion(num) {
        return (num / (1000 * 1000 * 1000)).toFixed(2) + "B";
    }

    function toMillion(num) {
        return (num / (1000 * 1000)).toFixed(2) + "M";
    }

    function toThousand(num) {
        return (num / 1000).toFixed(2) + "K";
    }

    function asBillion(num, fixed) {
        return Number((num / (1000 * 1000 * 1000)).toFixed(fixed));
    }

    function billionAsNum(num) {
        return Number(num) * 1000 * 1000 * 1000;
    }

    function millionAsNum(num) {
        return Number(num) * 1000 * 1000;
    }

    function asMillion(num, fixed) {
        return Number((num / (1000 * 1000)).toFixed(fixed));
    }

    function asMillionOrBillion(num, fixed) {
        if (Number(num) > 1000 * 1000 * 1000)
            return asBillion(num, fixed);

        return asMillion(num, fixed);
    }

    function isAsBillion(num) {
        if (Number(num) > 1000 * 1000 * 1000)
            return true;

        return false;
    }

    function toFixedPrice(num) {
        num = Number(num);
        var flag = num > 0;
        num = Math.abs(num);
        const billion = 1000 * 1000 * 1000;
        const million = 1000 * 1000;
        if (num >= billion)
            return flag ? toBillion(num) : -toBillion(num);
        else if (num >= million)
            return flag ? toMillion(num) : -toMillion(num);
        else if (num >= 1000 * 100)
            return flag ? toThousand(num) : -toThousand(num);
        else if (num >= 1000)
            return flag ? num.toFixed(0) : -num.toFixed(0);
        else if (num >= 0.01)
            return flag ? num.toFixed(2) : -num.toFixed(2);
        else if (num >= 0.0001)
            return flag ? num.toFixed(4) : -num.toFixed(4);
        else
            return flag ? num.toFixed(6) : -num.toFixed(6);
    }

    function toPercentString(num) {
        return num.toFixed(2) + "%";
    }

    function seconds2milliseconds(num) {
        return Number(num) * 1000;
    }

    function minus2seconds(num) {
        return Number(num) * 60;
    }

    function hours2seconds(num) {
        return Number(num) * 3600;
    }

    function seconds2minus(num) {
        return Number(num) / 60;
    }

    function seconds2Hours(num) {
        return Number(num) / 3600;
    }

    function seconds2FixedTime(num) {
        var num = Number(num);
        if (num > 60 * 60)
            return seconds2Hours(num) + "h";
        else if (num > 60)
            return seconds2minus(num) + "m";
        else if (num > 1)
            return num + "s";
        else
            return seconds2milliseconds(num) + "ms";
    }

    function paddingSpace(num) {
        return String(" ").repeat(Number(num));
    }

    function quit() {
        Qt.quit();
        utility.exit_qml(0);
    }

    function prettyNumStr(text) {
        var is_neg = false;
        if (Number(text) < 0) {
            is_neg = true;
            text = -Number(text);
        }
        text = String(text);
        var list = text.split(".");
        if (list[0].length <= 0)
            return text;

        var text = list[0];
        for (var i = text.length - 3; i > 0; i -= 3) {
            text = text.substring(0, i) + "," + text.substring(i);
        }
        return (is_neg ? "-" : "") + text + (list.length > 1 ? "." + list[1] : "");
    }

    function prettyDateStr(text) {
        for (var i = text.length - 2; i > 2; i -= 2) {
            text = text.substring(0, i) + "-" + text.substring(i);
        }
        return text;
    }

    function clip(minNum, num, maxNum) {
        return Math.min(Math.max(minNum, num), maxNum);
    }

    function calWidth(twidth, iwidthList) {
        if (twidth <= 0 || !Array.isArray(iwidthList))
            return [];

        var sum = 0;
        var expandIndex = -1;
        var tlist = [];
        for (var i = 0; i < iwidthList.length; i++) {
            var iwidth = iwidthList[i];
            if (iwidth === "expand") {
                tlist.push(0);
                if (expandIndex !== -1) {
                    console.log("only one item can set expand");
                    return [];
                }
                expandIndex = i;
            } else {
                var l = iwidth.split("px");
                if (l.length === 2) {
                    var n = Number(l[0]);
                    tlist.push(n);
                    sum += n;
                } else {
                    var l = iwidth.split("%");
                    if (l.length === 2) {
                        var n = Number(l[0]) * twidth / 100;
                        tlist.push(n);
                        sum += n;
                    } else {
                        return [];
                    }
                }
            }
        }
        if (expandIndex !== -1) {
            if (sum < twidth)
                tlist[expandIndex] = twidth - sum;

        }
        return tlist;
    }

}
