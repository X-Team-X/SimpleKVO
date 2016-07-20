# SimpleKVO
###Simple block based category of NSObject for KVO. Modified from NSObject+YYAddForKVO. Thanks to ibireme!

####KVO block only triggered when property value changed (different from raw KVO, simplify the logical processing for the caller)

###一个从YYAddForKVO修改而来的极致简化的KVO封装（从API参数设计到调用方式）

###注意:  
####这里监听的是值的变化，其值确实改变后才会触发回调；   
####其行为和原始KVO以及YYAddForKVO都不同。   
####后两者的行为是只要被赋值就会触发(由KVO的实现原理决定的，而simpleKVO作了特别处理),使其更易用于某些业务场景的需求实现。
