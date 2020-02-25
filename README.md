# CCTrendChart 

![](https://img.shields.io/github/license/cocos543/CCTrendCharts)
![](https://img.shields.io/cocoapods/p/CCTrendCharts)
![](https://img.shields.io/github/last-commit/cocos543/CCTrendCharts)
![](https://img.shields.io/github/commit-activity/w/cocos543/CCTrendCharts)
![](https://img.shields.io/github/languages/code-size/cocos543/CCTrendCharts)

> 项目正在积极开发中, 基本功能已完成, 即将添加使用Demo, 喜欢请点个start, 谢谢 ~

## 安装方法
CocoaPods方式

```
pod 'CCTrendCharts'
```

## 已完成功能

### 一. 趋势图底层框架

1. 完成矩阵与坐标系的开发
2. 完成缩放功能的开发
3. 完成长按功能的开发
4. 完成滚动功能的开发
5. 完成图库模块化标准制定
6. 数据源接口标准制定
7. 渲染层接口标准制定
8. 支持组合视图, 共同响应手势.


###  二. 数据方面

1. 完成数据实体, 数据集, 数据整体的开发
2. 支持动态更新数据, 支持分页加载数据
3. 提供了两种数据的展示方式(从左到右:Default, 从右到左:RecentFirst)

###  三. 渲染方面

1. 支持实体按需渲染, 提高性能 
2. 默认的左Y轴, 右Y轴模块的数据提供者和渲染器
3. 默认的X轴模块的数据提供者和渲染器
4. 默认的指示器模块的数据提供者和渲染器
5. 默认的标记模块的数据提供者和渲染器
6. K线(candlestick)数据提供者和渲染器
7. 交易量条状图渲染器
8. 折线图数据提供者和渲染器
9. 贝塞尔曲线
10. TAI指标图例渲染器
11. 支持便捷组合各种视图, 并提供事件同步协议, 能将多个视图只要组合到一起, 共同响应手势.
12. 条形图渲染器

###  四. 趋势图技术指标 (Technical Analysis Indicators)

设计一个方案, 用来自由配置各类技术指标, 目前已经开发完成的指标列表如下

* 移动平均线MA(Moving average), 均线系数N可配置

### Demo

* K线图+指标
* 交易量图+指标
* 分时图
* 组合图
* 条形图
* Yunex交易所风格

## 正在开发
 
* 各项趋势图的指标计算
* 各类Demo

## 未完成功能

* 选中高亮
* 数据渲染器支持渐变
* 数据渲染器支持定制动画
* 各种风格的渲染器(涵盖主流证券公司的图表渲染器, 比如富途, 涨乐富, 蛋卷, 招商等等都将一一提供)
* 详细的图库使用教程demo
* 专业数据分析工具
* 支持swift最新版本
* 支持flutter?
* 支持MacOS
 
## 开发中的界面预览

<div>
<img src="https://raw.githubusercontent.com/cocos543/CCTrendCharts/dev/Screenshot/screenshot002.jpg"  width="30%"/>
<img src="https://raw.githubusercontent.com/cocos543/CCTrendCharts/dev/Screenshot/screenshot003.jpg"  width="30%"/>
<img src="https://raw.githubusercontent.com/cocos543/CCTrendCharts/dev/Screenshot/screenshot004.jpg"  width="30%"/>
<img src="https://raw.githubusercontent.com/cocos543/CCTrendCharts/dev/Screenshot/screenshot005.jpg"  width="30%"/>
<img src="https://raw.githubusercontent.com/cocos543/CCTrendCharts/dev/Screenshot/screenshot006.jpg"  width="30%"/>
<img src="https://raw.githubusercontent.com/cocos543/CCTrendCharts/dev/Screenshot/screenshot007.jpg"  width="30%"/>
</div>


滚动缩放画面稳定在60 FPS左右
<div>
<img src="https://raw.githubusercontent.com/cocos543/CCTrendCharts/dev/gpu_state.jpg" width="50%"/>
</div>
