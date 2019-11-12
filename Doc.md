#  交易数据接口

## 雪球接口

1. 分时图
https://stock.xueqiu.com/v5/stock/realtime/quotec.json?symbol=SH600519&_=1573541018175

其中symbol是市场+股票代码, 茅台为 SH600519

2. 日线
https://stock.xueqiu.com/v5/stock/chart/kline.json?symbol=SH600519&begin=1573627598525&period=day&type=before&count=-30&indicator=kline,pe,pb,ps,pcf,market_capital,agt,ggt,balance

各个参数都比较简单一看便知, 其中 type=before表示前复权, 一般都用这个, 后复权是after
周线week, 月线month, 季线quarter, 年线year, N分线Nm, 其中N可为120, 60, 30, 15, 5, 1

数据格式如下:

```
{
    "data":{
        "symbol":"SH600519",
        "column":[
            "timestamp",
            "volume", //成交量
            "open", //开盘价
            "high", //最高价
            "low", //最低价
            "close", //收盘价
            "chg", //涨跌额
            "percent", //涨跌幅
            "turnoverrate", //换手率
            "amount", //成交额
            "volume_post",
            "amount_post",
            "pe",
            "pb",
            "ps",
            "pcf",
            "market_capital",
            "balance",
            "hold_volume_cn",
            "hold_ratio_cn",
            "net_volume_cn",
            "hold_volume_hk",
            "hold_ratio_hk",
            "net_volume_hk"
        ],
        "item":[
            [
                1573401600000,
                1734246,
                1201.5,
                1206.2,
                1193.51,
                1199,
                -6,
                -0.5,
                0.14,
                2082060830,
                null,
                null,
                36.804,
                12.025,
                17.567093324705763,
                37.208629717045284,
                1506181162200,
                null,
                99947378,
                7.95,
                -78062,
                null,
                null,
                null
            ],
            [
                1573488000000,
                1915055,
                1204,
                1209.6,
                1198.21,
                1201.6,
                2.6,
                0.22,
                0.15,
                2303205539,
                null,
                null,
                36.883,
                12.051,
                17.605187105059585,
                37.28931565304555,
                1509447276480,
                null,
                null,
                null,
                null,
                null,
                null,
                null
            ]
        ]
    },
    "error_code":0,
    "error_description":""
}
```

3. 5日线
https://stock.xueqiu.com/v5/stock/chart/minute.json?symbol=SH600519&period=5d


## 雪球接口Cookie

随便访问一下官网之后得到cookie,  设置一下即可使用.

```
NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];

[cookieJar setCookie:[NSHTTPCookie cookieWithProperties:@{
    NSHTTPCookieDomain: @".xueqiu.com",
    NSHTTPCookiePath: @"/",
    NSHTTPCookieName: @"xq_a_token",
    NSHTTPCookieValue: @"87993a504d5d350e6271c337ad8e9ec8809acb79",
    NSHTTPCookieExpires: [NSDate dateWithTimeIntervalSinceNow:60*60]
}]];

[cookieJar setCookie:[NSHTTPCookie cookieWithProperties:@{
    NSHTTPCookieDomain: @".xueqiu.com",
    NSHTTPCookiePath: @"/",
    NSHTTPCookieName: @"xqat",
    NSHTTPCookieValue: @"87993a504d5d350e6271c337ad8e9ec8809acb79",
    NSHTTPCookieExpires: [NSDate dateWithTimeIntervalSinceNow:60*60]
}]];

[cookieJar setCookie:[NSHTTPCookie cookieWithProperties:@{
    NSHTTPCookieDomain: @".xueqiu.com",
    NSHTTPCookiePath: @"/",
    NSHTTPCookieName: @"xq_r_token",
    NSHTTPCookieValue: @"2b9912fb63f07c0f11e94985018ad64e78cca498",
    NSHTTPCookieExpires: [NSDate dateWithTimeIntervalSinceNow:60*60]
}]];
```
