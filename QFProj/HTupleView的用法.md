# HTupleView的用法




## 前言：

​	实现界面布局可以采用系统的xib、storyboard、constraint布局，或采用第三方的masonry布局，甚至可以直接采用计算坐标的方式进行实现；而此处引入一种新的布局方式：HTupleView



#### 旨在解决的问题：
 ``` 
1. 一个对象中众多全局变量的管理问题
2. cell的复用问题
3. cell之间通信的问题
4. 由cell之间通信产生的block释放问题
5. 重复定义太多cell的问题
6. 一个对象同时代理多个列表的问题
7. 一个对象同时代理多个列表的数据存储问题
8. 所有列表对象数据重新加载的问题
 ```


#### 实现机制和功能：

一、Flex box 机制
> cell flex box布局机制 

 

二、cell复用机制
> 初始block
> 复用类
> 是否带有前缀
> 是否包含indexPath



三、分身机制之多tuple
> 多个tuple的布局方式
> 多个tuple共用section处理方式
> 多个tuple全部section都共用的处理方式

 

四、分身机制之数据存储
> 多个tuple的数据存储

 

五、信号机制
> cell及tuple之间通信的方式



六、内存释放之block释放
> 通信block机制的内存方式

 

七、换肤机制
> 全工程所有tuple数据重新加载的问题

 

八、刷新和加载更多功能
> 刷新tuple
> 加载更多cell

 

九、HTupleViewCell

> 1. 单控件cell
> > HLabel
> > HTextView
> > HWebButtonView
> > HWebImageView
> > HTextField
>
>
>
>![HTupleViewCell-image](/Users/wind/Desktop/HTupleViewCell-image.png)
>
>
>
>2、多控件cell
> 
>> HTupleViewCell

 

十、HTupleViewCellVertValue1
> 垂直布局的64种组合方式



![HTupleViewCellVertValue1-image](/Users/wind/Desktop/HTupleViewCellVertValue1-image.png)

 


十一、HTupleViewCellHoriValue1

> 水平布局的192种组合方式 



![HTupleViewCellHoriValue1-image1](/Users/wind/Desktop/HTupleViewCellHoriValue1-image1.png)



![HTupleViewCellHoriValue1-image2](/Users/wind/Desktop/HTupleViewCellHoriValue1-image2.png)

