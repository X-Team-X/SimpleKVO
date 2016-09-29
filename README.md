# SimpleKVO
###Simple&safe block based category of NSObject for KVO. Modified from NSObject+YYAddForKVO. Thanks to ibireme!

####KVO block only triggered when property value changed (different from raw KVO, simplify the logical processing for the caller)

###一个从YYAddForKVO修改而来的极致简化的KVO封装（从API参数设计到调用方式），增加了特定场景的保护（对象释放时仍未解除观察会导致crash）

###注意:  
* 这里监听的是值的变化，其值确实改变后才会触发回调；   
* 其行为和原始KVO以及YYAddForKVO都不同。   
* 后两者的行为是只要被赋值就会触发(由KVO的实现原理决定的，而simpleKVO作了特别处理),使其更易用于某些业务场景的需求实现。
* 通过method swizz的方法对nsobject的dealloc进行了替换,其中增加调用了解除kvo的操作，使得对象释放前可以自动解除kvo，避免潜在的crash可能，建议在小型应用或者个人研究时使用该功能，代码更加简洁。  
PS:该功能需要打开ENABLE_SWIZZ_IN_SIMPLEKVO宏后才起作用，默认情况下不使用SWIZZ,需要手动解除kvo（用于成熟商用应用中，无任何后顾之忧）。