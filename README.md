#LoGspot

##Usage

### Initialization

```
logger = LoGspot.new('/home/user/logs/production.log')
logger = LoGspot.new # STDOUT
```

### Output

```
logger.info 'Foo' # [2015/01/20 22:13:42 INFO] Foo
```

```
logger.tagged 'Foo: ' do
  logger.info 'Bar'
  logger.info 'Foo'
end
# [2015/01/20 22:13:42 INFO] Foo: Bar
# [2015/01/20 22:13:42 INFO] Foo: Foo
```

```
logger.tagged_list 'Foo: ' do
  logger.info 'Bar'
  logger.info 'Foo'
end
# [2015/01/20 22:13:42 INFO] Foo: Bar
#                                 Foo
```
