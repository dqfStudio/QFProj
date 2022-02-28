## 海外谷歌/苹果上架及推广具体情况表



### 一、谷歌/苹果上架
> 谷歌上架--6000RMB
> 苹果上架--8000RMB
 ``` 
说明：由于是要上架App Store，而且是色情类的APP，所以需要咱们自己做个马甲包，这个马甲包他们负责上架，马甲包上架后强制更新成咱们的色情APP；如果别人举报导致被封或下架，会帮代为再次上架，不过会另外收费，这个收费标准视对上架账号造成的风险而定，大概范围是2000-5000RNM
 ```



### 二、推广
> 当地网红
> > 按照粉丝数和粉丝活跃度来收费，收费标准需要等明天发给我们
> 
> 支持担保
> > 说是由担保方收取担保费，按照业务的4%收取；如果信得过他们，也可以直接交易，不用担保
> 

 ``` 
说明：他们只做海外业务，没做国内的业务
 ```

```mermaid
graph TB
A(工业用地效率)-->B1(土地利用强度)
A-->B2(土地经济效益)
B1-->C1(容积率)
B1-->C2(建筑系数)
B1-->C3(亩均固定资本投入)
B2-->D1(亩均工业产值)
B2-->D2(亩均税收)
```


```mermaid
graph LR
A(工业用地效率)-->B1(土地利用强度)
A-->B2(土地经济效益)
B1-->C1(容积率)
B1-->C2(建筑系数)
B1-->C3(亩均固定资本投入)
B2-->D1(亩均工业产值)
B2-->D2(亩均税收)
```


```mermaid
graph TB;
subgraph 分情况
A(开始)-->B{判断}
end
B--第一种情况-->C[第一种方案]
B--第二种情况-->D[第二种方案]
B--第三种情况-->F{第三种方案}
subgraph 分种类
F-.第1个.->J((测试圆形))
F-.第2个.->H>右向旗帜形]
end
H---I(测试完毕)
C--票数100---I(测试完毕)
D---I(测试完毕)
J---I(测试完毕)
```

```mermaid
pie
 title Pie Chart
 "Dogs" : 386
 "cats" : 567
 "rabbit" : 700
 "pig":365
 "tiger" : 15
```

```mermaid
gantt
 dateFormat  YYYY-MM-DD
 title     软件开发任务进度安排 
 excludes   weekends

 section 软硬件选型 
 硬件选择      :done,desc1, 2020-01-01,6w 
 软件设计      :active,desc2, after desc1,3w

 section 编码准备
 软件选择       :crit,done,desc3,2020-01-01,2020-01-29
 编码和测试软件   :1w
 安装测试系统    :2020-02-12,1w

 section 完成论文
 编写手册      :desc5,2020-01-01,10w
 论文修改      :crit,after desc3,3w
 论文定稿      :after desc5,3w
```

```mermaid
sequenceDiagram
Title: 小明买书

participant consumer as 小明
participant store as 书店
participant publisher as 出版社

consumer ->> store: 想买一本限量版书籍
store -->> consumer: 缺货
consumer ->> store: 隔一个月再次询问
store -->> consumer: 抢完了
loop 一个星期一次
consumer -x +store: 有货了吗
store --x -consumer: 正在订,有货马上通知你
end

store ->> publisher: 我要订购一批货
publisher --x store: 返回所有书籍的类别信息

alt 书籍类别符合要求
store ->> publisher: 请求书单信息
publisher --x store: 返回该类别书单信息
else 书单里的书有市场需求
store ->> publisher: 购买指定数据
publisher --x store: 确认订单
else 书籍不符合要求
store -->> publisher: 暂时不购买
end

par 并行执行
publisher ->> publisher : 生产
publisher ->> publisher : 销售
end

opt 书籍购买量>=500 && 库存>=50
publisher ->> store : 出货
store --x publisher : 确认收货
end

Note left of consumer : 图书收藏家
Note over consumer,store : 去书店购买书籍
Note left of store : 全国知名书店
Note over store,publisher : 去出版社进货
Note left of publisher : 持有版权的出版社
```


```flow
start=>start: 开始
input=>inputoutput: 输入
operation=>operation: 操作
condition=>condition: 操作出错？
output=>inputoutput: 输出
error=>operation: 请重新输入
end=>end: 结束

start->input
input->operation
operation->condition
condition(no,bottom)->output
condition(yes)->error(top)->input
output->end
```
