30分的加分題都有寫
找出comment的regular expresstion將comment token吃入並且利用\n此token與讀取到//或是
/**/找出comment行數
利用lookup_symbol此function來實作
當有宣告var...然後查看下一個token的variable是否在Hash Table中如果已經存在則redefined
當讀到ID時，也是利用lookup_symbol如果在HashTable中不存在，則undefined