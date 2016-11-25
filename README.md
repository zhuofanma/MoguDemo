# MoguDemo
蘑菇租房Demo

模块载入和扩展：
自定义一个可装载模块数据和加载状态的类，初始化五个类，将五个不同接口得到的数据分别载入其中一个，用tableView读取类的内容来展示模块的各种状态。扩展时只需增加初始化自定义类的数量即可。

防止加载数据时阻塞UI：
添加Core Data stack，添加使用非主队列线程的backgroundContext，将之与使用主队列线程的mainContext用parent/child关系链接。把加载数据的代码放在backgroundContext的队列中执行，防止加载时阻塞UI。

只加载必须加载的图片：
若数据中包含图片，需另开子线程加载，防止阻塞UI，并且只到图片所在cell可见时才加载。

