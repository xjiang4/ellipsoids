Ellipsoidal toolbox allows developers to use powerful java logging library called log4j.


# Log4j Usage #
To use logging in the code, developer must at first get an object of class "Logger". Code below demonstates getting the object:
```
import elltool.logging.Log4jConfigurator;
% if writing tests: import elltool.test.logging.Log4jConfigurator;
logger = Log4jConfigurator.getLogger();
```
Such object, when instantiated, will contain information about class it was called from. It is called category.

The `getLogger` function may be also called with a string-typed argument if a developer needs to provide information about category to log for explicitly. For example, the code
```
logger = Log4jConfigurator.getLogger('elltool.logging');
```
will instantiate a Logger object configured to log for `elltool.logging` class.

There are plenty of methods to write log messages of different importance. The types of messages are (in ascending order of priority): trace->debug->info->warn->error->fatal. For example:
```
% informational message
logger.info('Making some calculations...')

% debug message
logger.debug(sprintf('Value of variable is %d', var))

% error message. only if neccessary
logger.error('Got negative definite ellipsoid?!')
throwerror(...)
```
Corresponding methods are used to log other types of messages: `trace`, `debug`, etc. To check if logger is configured to print informational, debug or trace messages, use isInfoEnabled, isDebugEnabled and isTraceEnabled methods, like that
```
if (logger.isInfoEnabled())
  logger.info(sprintf('Method was called %d times', nTimes))
end
```

# Faster logging #
Though log4j is one of the fastest java logging engines, it significantly slows down the program within some circumstances nevertheless. So there are some tips:
  * "getLogger" is a slow method. Use persistent logger variable in methods or functions that are assumed to be run many times. Such code will help:
```
% once in the beginning of a method
import elltool.logging.Log4jConfigurator;
persistent logger;

% ...

% every time a logger should be called
if isempty(logger)
  logger = Log4jConfigurator.getLogger();
end
logger.info("Information")
```
  * Use output formatting with care. For example, in this code
```
logger.debug(sprintf('Value of variable is %d', var))
```
> the sprintf function will be run and even if logger will never print this message. So this will slow down actively used methods regardless of logger configuration. The solution is to use isInfoEnabled, isDebugEnabled methods before logging with sprintf or other formatting function:
```
if (logger.isDebugEnabled())
  logger.debug(sprintf('Value of variable is %d', var))
end
```
  * File output is slower than console output, so do not use it in release versions of actively used methods.
  * If a debug is needed, do not create a lot of temporary code for debugging. Instead create permament debug code and use debug messages in it. By default logger will accept only info and more important log messages levels and will not do extra job. But you can change logging settings in your copy of ET to accept debug messages and write it to file or console.

# Configuration #
Briefly speaking the log4j configuration consists of defining loggers and appenders with layouts. For full information see the [log4j manual](http://logging.apache.org/log4j/1.2/manual.html).

## Appenders ##
Appenders are mechanisms for writing logs to one or another location. Mostly used appenders are: `ConsoleAppender` and `FileAppender`

All appenders' configuration variables are preceded by `log4j.appender`, then after a dot comes appender name, then parameters. For example, `log4j.appender.stdout.layout` is the layout parameter of appender called stdout. Mostly used parameters are:
  * no parameters, just `log4j.appender.appender_name`: defines appender type. A developer can use `org.apache.log4j.ConsoleAppender` for console output and `org.apache.log4j.FileAppender` for file output. There are also plenty of others.
  * `File`: for FileAppender defines file to use for output. Matlab variables may be used here (and also everywhere within configuration), like that:
```
log4j.appender.Appender1.File=${elltool.log4j.logfile.dirwithsep}${elltool.log4j.logfile.main.name}
```
  * `layout`: Message formatter. Used to render the contents of log message. Use "`org.apache.log4j.PatternLayout`" value for sprintf-like renderer.
  * `layout.ConversionPattern`: when using PatternLayout, defines the sprintf-like log template. For example: "`%d %5p %c - %m%n`" defines such template: "DATE PRIORITY CATEGORY - MESSAGE LINEBREAK". See [Conversion characters](http://logging.apache.org/log4j/1.2/apidocs/org/apache/log4j/PatternLayout.html) for information on ConversionPattern syntax.

## Loggers ##

Loggers have hierarchical structure. The top logger is called `rootLogger`, and is configured by `log4j.rootLogger` configuration variable. Other logger names should be preceded by `log4j.logger`.

The value of logger parameter consists of lowest message priority to print and a list of appenders, comma separated. All loggers follow the basic selection rule: **a log request of level p in a logger with level q, is enabled (i.e. shown) if p is of less or equal importance as q**. For example:
```
log4j.rootLogger=ERROR, stdoutAppender, fileAppender1
log4j.logger.reach = INFO, fileAppender2
```
here `reach` logger will show informational messages, warnings, errors and fatals, and `rootLogger` will accept only error and fatal messages.


Categories of loggers could be used as logger name. For example, if a developer writes such code:
```
logger = Log4jConfigurator.getLogger('reach');
logger.info('Information')
```
or uses `getLogger` without arguments in a class called `reach`, then log4j will search for `log4j.logger.reach` configuration at first, and fall back to rootLogger only if not found.

Because of loggers' hierarchical nature, the descendant logger by default logs the message with its appender and then sends it to an ancestor logger. So in example above the message will be sent to `fileAppender2` and then to `stdoutAppender` and `fileAppender1`.
`log4j.additivity.logger` name parameter is used to disable such behavior. When using this configuration
```
log4j.rootLogger=INFO, stdoutAppender, fileAppender1
log4j.logger.reach = INFO, fileAppender2
log4j.additivity.reach = FALSE
```
the messages from loggers of `reach` category will be sent only to `fileAppender2`.