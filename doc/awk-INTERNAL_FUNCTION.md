<h2>awk 简单用法(内置函数)</h2>
做为一个windows系统管理员,文本处理将是一个难点,但在linux 里面显然就是一盘小白菜.在linux 文本处理工具上面,awk占了60%的份量,另外还有sed与grep ,这里主要记录一些awk常见的使用方法,详细的大家可以举一反三,
awk 这不是一个单词,而是这门语言的创始人(三个人: Alfred V. Aho、Peter J. We i n b e rg e r、Brian W. Kernighan)简称,所以你别指望着从你的英文字典里面找出这个单词的意思.呵呵
言归正传:
gawk 是GNU计划下的awk ,包含了awk下的所有功能,一门程序语言,故就有着他固定的格式.gawk 当然也不能例外了,基本格式为:
  gawk '/pattern/ {action}' file.txt
里面的pattern用//括起来,action 用花括号括起来,action也可以不写.
好,先让我们一起看个例子吧:
  gawk '/rpcuser/' /etc/passwd
这句话指的是将/etc/passwd这个file中包含了rpcuser的整行一起输出,是不是很方便呀?
当然你也许还有更苛刻的需求,要求输出第3个字段,想知道他是否能够登录?这样你只需要在里面增加一个action就OK了,试试看吧:
  gawk '/rpcuser/ {print $3}' /etc/passwd
解释一下:
    /rpcuser/ 这里面的/ /是一个pattern 指include rpcuser 的所有line;  {print $3}是一个action,用{}来表示,默认gawk 是以空格或者tab键来给每一行分区块的,第一个区块为$1,第二个区块为$2 依此类推
当然你也可以将区块分隔符号修改成其它,如冒号,分号,逗号等,举例如下:
gawk -F ":" '/rpcuser/ {print $2}' /etc/passwd
注意:在这里面-F中的F一定要大写

还可以将文件区域进行计算.如:
运算符说明示例
+ 加法运算
- 减法运算
* 乘法运算
/ 除法运算
^ 乘方运算3^2 (=9)
% 求余数9%4 (=1)
在awk 中如下表示:gawk '/**/ {print $2/100}' file.txt  第三个字段除以一百的结果
还支持表达式,如action也可以写成这样{print $1+$2*$3}

awk 还有一些内部函数,如
g a w k中有各种的内部函数，现在介绍如下：
6.6.1 随机数和数学函数
sqrt(x) 求x 的平方根
sin(x) 求x 的正弦函数
cos(x) 求x 的余弦函数
a t a n 2 ( x，y) 求x / y的余切函数
log(x) 求x 的自然对数
exp(x) 求x 的e 次方
int(x) 求x 的整数部分
rand() 求0 和1之间的随机数
srand(x) 将x 设置为r a n d ( )的种子数

还有字符串的内部函数,如:
index 函数  格式:{print index("technical", "ch")} 寻找ch 出现在字符串technical中位置,结果为3.

length 函数 格式: length(abcde) 结果5 .
match (string, example)  在字符串string中找到最靠左边的example 的位置.
sprintf 与printf 相似
sub ( regexp，replacement，target) 在字符串target中寻找符合regexp 的最长、最靠左的地方,以字串replacement 代替最左边的regexp。
例如：
str = "water，water，everywhere"
sub ( /at/， "ith"，str)
返回结果为:wither, water, everywhere

substr (string, start, length )返回字符串string的子字符串,如:
substr (washingdun,5,3) 返回的字符串为从第五个字符开始,长度为三个字符,即ing

tolower (string) 将string转化为小写字母
toupper (string) 将string转化为大写字母

close (filename) 关闭文件
system(command),这个函数允许执行系统命令.
gawk '$1 != "Tim" {print}' testfile 
      testfile文本当中第一个字段不等于Tim的行打印出来.
格式化输出:
    gawk '$1 != "Tim" {print $1,$5,$6,$2}' testfile

进一步，你可以在print动作中加入字符串，例如：
gawk '$1!="Tim" {print "The entry for "，$ 1，"is not Tim. "，$2}' testfile
注意:print 中的每一部份都得用逗号隔开.


很神奇吧,可我想知道gawk 到底能用在哪些地方:
• 根据要求选择文件的某几行，几列或部分字段以供显示输出。
• 分析文档中的某一个字出现的频率、位置等。
• 根据某一个文档的信息准备格式化输出。
• 以一个功能十分强大的方式过滤输出文档。
• 根据文档中的数值进行计算。
