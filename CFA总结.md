# 道德

IPS至少每年更新，有重大事件也要更新

由团队完成的项目，向他人展示时也要披露自己都干了啥

# 数量

### 名词

#### 几种收益率

* Holding period yield(持有至到期收益率)

  $$ HPY = \frac{P_{1} - P_{0} + CF_{1}}{P_{0}}$$

  说白了就是。。算了，顾名思义吧

* Effective annual yield(有效年利率)

  $$EAY = (1 + HPY)^{365/T} - 1$$

  就是把持有至到期收益率年化一下

* Nominal risk-free rate(名义无风险利率)

  $$Real risk-free rate + expected inflation rate$$

* Required interest rate on a security(要求回报率)

  $$ Nominal risk-free rate + 违约风险溢价 + 流动性溢价 + 到期日风险溢价$$




#### 几种measurement scales

* Nominal scales
* Ordinal scales
* Interval scales
* Ratio scales



#### 峰度、偏度、变异系数

* Kurtosis(峰度)

  $$ K = \frac{1}{n}\frac{\sum_{i = 1}^{n}(X-\bar{X})^{4}}{s^{4}}$$

  跟3比，>3 尖峰肥尾

* Skewness(偏度)

  $$ S = \frac{1}{n}\frac{\sum_{i = 1}^{n}(X-\bar{X})^{3}}{s^{3}}$$

  跟0比，>0 右拖尾

* Coefficient of Variation(变异系数)

  标准差比均值




#### 切比雪夫不等式

$$  P(|X - \mu| \leq k\sigma)\geq 1 - 1/k^{2}$$



#### 置信区间

* **68%** $\sigma$
* **90%** $1.65\sigma$
* **95%** $1.96\sigma$
* **99%** $2.58\sigma$



#### 几种bias

* Data-mining bias

  过度利用了数据

* look-ahead bias

  用了还没出来的数据进行估计，比如选取某年前十天等等，这个时候报表还没出，并没有数据。

* Survivorship bias

  生存这偏差

* Sample selection bias

  有意剔除或者挑选样本

* Time-period bias

  选取的数据时间跨度太大或者太小




#### 几种Ratio

* Sharpe ratio

  $$ R = \frac{E[R_{p}]-R_{f}}{\sigma_{p}}$$

  每单位风险带来的投资组合的超额收益率

* Safety-first ratio

  $$ R = \frac{E[R_{p}]-R_{L}}{\sigma_{p}}$$

  每单位风险带来的投资组合的**超过门槛收益率的收益率**

* Treynor ratio
  $$ R = \frac{R_{p}-R_{f}}{\beta}$$

  感觉就是市场的超额收益。。。




#### 两类统计学错误

* 第一类错误

  弃真错误

* 第二类错误
  存伪错误





# 经济学

### 微观经济

#### 几种不同商品

- 一般商品(Normal Goods)：收入效应为正

- 劣等品(Inferior Goods)：收入效应为负

  - 吉芬商品(Giffen Goods)：收入效应 > 替代效应

    具有斜向上的需求曲线(upward-sloping demand curve, viz. slope > 0)

    可以用消费者选择理论解释

- 韦伯伦商品(Veblen goods/ Conspicuous goods)

  一种特殊的**奢侈品**，一定范围内也具有斜向上的需求曲线  ~~太贵了就谁都买不起了 :)~~

  价格本身是一种社会地位的象征

  不能用消费者选择理论来解释




#### 几种市场




### 宏观经济

#### 货币(Money)政策&财政(Fiscal)政策



#### Business Cycle(经济周期)

##### 四个周期

Inventory，Inventory-to-sales ratio，unemployment rate是比较重要的判别指标

* Expansion
* Peak
* Contraction
* Trough



#### IS、LM曲线

real interest rate 和 real aggregate income

* $$(S-I) = (G-T) + (X-M)$$

  总储蓄量等于政府赤字加上净出口额

* IS曲线




#### 总供给曲线和总需求曲线(Aggregate S&D)

##### AS

* 超短期

  产量增加不影响价格水平

* 短期
  产量增加影响价格水平，因为会影响**部分**原材料的价格

  使短期总供给曲线移动的因素有：劳动力生产率，原材料价格，税和补贴，汇率，未来商品价格的期望值

* 长期

  产量保持在完全就业水平，不受价格水平影响，表现为完全无弹性

  使长期供给曲线移动的：两人(劳动力的质量和数量)两物(资源和设备)一科技【经济增长也是他




#### 通胀和紧缩

* Recession\Deflation(紧缩)：**需求**的突然下降，通常危害大于通胀
* Inflation(通胀)：**需求**的突然上升
  * Disinflation：通胀速度减缓的通胀
  * Hyperinflation：恶性通胀

上面两个都要通过劳动力价格的变动来回到平衡点

* Stagflation(滞涨): **供给**的突然下降，非常严重！
* Core inflation(核心通胀率)：不计食物和能源的price index，因为这两个波动很大



#### 六个学派

- Neoclassical school
  * AD&AS的移动都是由**科技**引起的
  * 经济体有很强的趋于完全就业的趋势

- Keynesian school
  * AD&AS的移动是由**预期**引起的
  * wage are "downward sticky"(工资降不下来)
  * 主张政府干预

- New Keynesian school
  * 同上，但是所有生产要素都"downward sticky"

- Monetarist school
  * 外部原因或内部货币供给量不合时宜地下降会引起紧缩
  * 货币供给应该保持一个稳定可预期的增长，**但是并不倡导用货币政策对抗经济周期**

- Austrian school
  * 政府智障，经济周期都是政府瞎添乱引起的

- New Classical school

  real business cycle theory

  * 只有科技和external shocks会影响
  * Applies utility theory to macroeconomics
  * 政府不该管



#### 三种失业

##### Frictional unemployment

信息不对称；不严重。

##### ~~Structural unemployment(考纲没有了！)~~

~~caused by long-run changes in the economy;~~

~~得培训~~

##### ~~Cyclical unemployment(考纲没有了！)~~

~~Caused by changes in the general level of economic activity.~~

# 财报

#### 报表结构

通常的思路：BS的Asset —> IS的某一项进而影响NI —> BS的Retained earning

也有走OCI的

##### Balance Sheet

| **Asset**       | **Liability**       |
| --------------- | ------------------- |
| Cash            | A/P                 |
| A/R             | Pension             |
| Inv             | Long-term           |
| DTA             |                     |
| PPE             | **Equity**          |
| Intangible      | Contributed capital |
| Financial Asset | Retained earning    |
|                 | AOCI                |
|                 |                     |

##### Income Statement

———————————————————————————————————————————————

​     Net sales\ Revenue

— COGS(cost of good sales)

== gross profit

— SG&A(Selling, General and Administrative Expenses)

— Expense

== EBIT\ Operating profit

— Interest expense

== EBT

— tax

== Net Income from Continuing Operations 

————underline(U.S. GAAP下，上面的记在CFO，下面的在CFI，CFF在IS里没有)————

+\\- Unusual and infrequent items(net of tax)\Earnings(losses) from **discontinued** operations, net of tax

== Net Income

______

OCI

Dividend

———————————————————————————————————————————————

####  递延所得税



#### Capitalizing(资本化)



#### CFO



#### 资产减值



#### Cash Conversion Cycle



#### IASB下报表信息的四个特性

* Comparability
* Verifiability
* Timeliness
* Understandability


# 公司金融

#### 衡量项目的指标

##### NPV

##### IRR

##### Payback Period

* 就未来现金流加起来，够成本的时候是多少年。衡量流动性，不折现

* 缺点
  * 忽略了时间价值
  * 忽略了payback period 后的现金流

* Discount Payback Period

  考虑了折现，其他没变




##### Profitability Index

$$
PI = \frac{PV\ of\ future\ CF}{CF_{0}} = 1 + \frac{NPV}{CF_{0}}
$$

未来现金流现值 比上 初期流出

PI跟1比较的结论与NPV跟0比较一样

后期又进行投资的不适用。



#### WACC



#### Dividend Discount Model



#### Marginal Cost of Capital

##### Break Point



#### DOL, DFL, DTL



#### ROE杜邦三项五项



#### Breakeven



#### Book Value per Share

$$ BVPS = \frac{BV}{shares\ outstanding}$$








# 权益类投资



# 衍生品



# 固定收益



# 另类投资



# 投资组合



# 单词

**solicit** 征求

**lump-sum** 一次付费

**homogenous** 同质的

ROE

NI 和 Sales

