# LoGspot

## Usage

### Initialization

```
logger = LoGspot.new('/home/user/logs/production.log')
logger = LoGspot.new # STDOUT
logger = LoGspot.new(tag_block: ->(time, level) { "\033[30m[#{time.strftime('%H:%M:%S')}|#{level[0]}]\033[39m " }) # With custom tag format
```

### Outputs

```
logger.info 'Foo' # [2015/01/20 22:13:42 INFO] Foo
```

```
logger.tagged('Foo: ') do
  logger.info 'Bar'
  logger.info 'Foo'
end
# [2015/01/20 22:13:42 INFO] Foo: Bar
# [2015/01/20 22:13:42 INFO] Foo: Foo
```

```
logger.tagged_list('Foo: ') do
  logger.info 'Bar'
  logger.info 'Foo'
end
# [2015/01/20 22:13:42 INFO] Foo: Bar
#                                 Foo
```

```
logger.tagged('Foo: ') do
  logger.untagged do
    logger.info 'Bar'
	logger.info 'Foo'
  end
end
# [2015/01/20 22:13:42 INFO] Bar
# [2015/01/20 22:13:42 INFO] Foo
```

```
logger.hash(foo: 'bar') do |key, value|
  logger.info value
  logger.info 'Foo'
end
# [2015/01/20 22:13:42 INFO] foo: bar
# [2015/01/20 22:13:42 INFO]      Foo
```

```
logger.value(foo: ['bar', 'foo'])
# [2015/01/20 22:13:42 INFO] foo: 0: bar
#                                 1: foo
```
