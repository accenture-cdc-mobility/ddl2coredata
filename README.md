#如何使用这个工具

## 1. 命令行执行方式
```
sh importSqliteDDL2CoreData.sh 参数1 参数2 参数3 参数4
```
### 1.1 参数说明：

- 参数1 -- sqlite数据库文件名称
- 参数2 -- 要执行的ddl sql文件路径
- 参数3 -- 生成的CoreData model定义文件的名称
- 参数4 -- xcode工程目录里的xcdatamodeld文件路径，不包括路径分隔符

### 1.2 输出说明
在执行后，在用户Home目录里会生成一个新的文件夹[output]，这个文件夹下面就会出现一个由参数3指定名称的CoreData Model定义文件

#注意点
这种方式不能自动进行CoreData的版本化工作，而是生成一个新的Model，因此请使用xcode进行Add Version操作来使用心得model

## 2. 生成实体代码
### 1. 自动化生成
可以使用其他自动化工具从生成的CoreData Model文件里，自动生成CoreData Entity Classes，例如: [Mogenerator](https://github.com/rentzsch/mogenerator)；还可以把这个生成过程嵌入工程编译过程(Build Phases -> Add Script)，可以反复执行；下面是一个例子：

```
MODELS_DIR="${PROJECT_DIR}/$PROJECT_NAME"
DATA_MODEL_PACKAGE="$MODELS_DIR/MogModel.xcdatamodeld/MogModel.xcdatamodel"
# - 替换相应的 xxxxx.xcdatamodeld名称

if [ -x /usr/local/bin/mogenerator ]; then
echo "mogenerator exists in /usr/local/bin path";
MOGENERATOR_DIR="/usr/local/bin";
elif [ -x /usr/bin/mogenerator ]; then
echo "mogenerator exists in /usr/bin path";
MOGENERATOR_DIR="/usr/bin";
else
echo "mogenerator not found"; exit 1;
fi
$MOGENERATOR_DIR/mogenerator -m "$DATA_MODEL_PACKAGE" -M "$MODELS_DIR/CoreData/Machine/" -H "$MODELS_DIR/CoreData/Human/"
# 如果是ARC工程，加上 --template-var arc=true就行了，即mogenerator命令换成：
# $MOGENERATOR_DIR/mogenerator --template-var arc=true -m "$DATA_MODEL_PACKAGE" -M "$MODELS_DIR/CoreData/Machine/" -H "$MODELS_DIR/CoreData/Human/"
```

在每次替换了model或者添加了新的版本，只需要执行一次build就可以生成新的class