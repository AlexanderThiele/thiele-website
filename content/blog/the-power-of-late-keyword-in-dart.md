---
title: "The Power of the late keyword in Dart"
date: 2023-10-10
---

# The Power of the late keyword in Dart

One of the most underused keywords in Dart is `late`. I would even call
it a hidden champion, because you can do so much more than assign a
variable inside a class constructor and make it non-null.

So far I only used the late keyword to bypass the compiler and
initialize a variable a bit later so I don't have to write `?` or `!`
every time I use a variable. Let's look at an example:

`class AnyWidget extends StatelessWidget { late String aString; AnyWidget({super.key}){ aString = getAStringSomewhere(); } String getAStringSomewhere(){ return "Hello World"; } @override Widget build(BuildContext context) { return Text(aString); } }`

If it is not declared as late, it must be nullable otherwise there will
be compile-time errors.

## dart late keyword and its power

In dart, late is used to be initialized at a later time. The above
example is therefore correct, we initialize the variable at a later time
but the real advantage is when the variable is used.

Let's look at the above example again with a few print commands.

`class AnyWidget extends StatelessWidget { late String aString; AnyWidget({super.key}){ print("constructor started"); aString = getAStringSomewhere(); print("constructor finished"); } String getAStringSomewhere(){ print("we're generating a string now"); return "Hello World"; } @override Widget build(BuildContext context) { print("build"); return Text(aString); } }`

The print output is:

`flutter: constructor started flutter: we're generating a string now flutter: constructor finished flutter: build`

In this case, late would do nothing but declare the variable aString
null-safe.

However, if we move the getAStringSomewhere method directly into the
declaration, we get a completely different result:

`class AnyWidget extends StatelessWidget { late String aString = getAStringSomewhere(); AnyWidget({super.key}) { print("constructor finished"); } String getAStringSomewhere() { print("we're generating a string now"); return "Hello World"; } @override Widget build(BuildContext context) { print("build"); return Text(aString); } }`

with output:

`flutter: constructor finished flutter: build flutter: we're generating a string now`

The getAStringSomewhere method is executed only when the variable is
used and is executed only once for further use.

` @override Widget build(BuildContext context) { print("build"); return Column(children: [ Text(aString), Text(aString), Text(aString), Text(aString), Text(aString), ],); }`

The above example still has the same output:

`flutter: constructor finished flutter: build flutter: we're generating a string now`

🤯

I don't know about you, for me the small change was stunning because
this enabled so many more use-cases.

## Best practices using the dart late keyword

Here is a small collection of `late` use-cases where the late keyword
can improve the code by a lot.

### Access context and intl in StatefulWidget

You can access the intl package and retrieve a string in a
StatefulWidget. The intl string is loaded only once from the context and
can be used on each build.

This is also a performance improvement as the build method can be
executed thousands of times but the text is only retrieved once from the
context.

`late final String titleString = context.i18n.titleString;`

### Replace getter methods with late

Any getter method that always does the same thing can be replaced with a
late variable. Because getter are executed each time anew instead of
saving the result from the getter. With a late variable the result is
calculated once and made available for further use. This refers not only
to strings, but to all classes that are provided as getter.

Example: Chart data calculation. If we have a chart that does not change
during the app lifetime, the min value can be calculated using a getter.

`class ChartWidget extends StatefulWidget { final ChartData chartData; const ChartWidget({super.key, required this.chartData}); @override State<ChartWidget> createState() => _ChartWidgetState(); } class _ChartWidgetState extends State<ChartWidget> { /// some variables that requires you to use a Stateful widget ChartEntry? currentFocusPoint; /// getter that calculates the entry with the minimum value ChartEntry get minChartEntry => widget.chartData.calculateMin(); @override Widget build(BuildContext context) { return LineChart( minEntry: minChartEntry, entries: widget.chartData, ); } }`

With each build the getter is executed again. This means, if the build
method is executed 1000 times, the calculation is also executed 1000
times.

Now the late example:

`class ChartWidget extends StatefulWidget { final ChartData chartData; const ChartWidget({super.key, required this.chartData}); @override State<ChartWidget> createState() => _ChartWidgetState(); } class _ChartWidgetState extends State<ChartWidget> { /// some variables that requires you to use a Stateful widget ChartEntry? currentFocusPoint; /// getter that calculates the entry with the minimum value late final ChartEntry minChartEntry = widget.chartData.calculateMin(); @override Widget build(BuildContext context) { return LineChart( minEntry: minChartEntry, entries: widget.chartData, ); } }`

The change was made only in one place and the rest remained the same. If
the build method is now executed 1000 times, the calculation is only
performed 1 time. In a list sorting operation this can lead to enormous
performance increases.

### Save initState method

Normally with a StatefulWidget you declare the variables in the
initState method. In most cases you can save this and just use the late
keyword instead.

### Global & static variables are late by default

If you define your variable as global or static, it is late by default.
The variables are initialized only when you access them and then only
once, no matter how often you call them. There is even a linter rule
called
[unnecessary\_late](https://dart.dev/tools/linter-rules/unnecessary_late)
in case you accidentally mark a global variable as late.

Here is the global example:

`String aGlobalString = getAStringSomewhere(); String getAStringSomewhere() { print("we're generating a string now"); return "Hello World"; } void main() { print("start"); print(aGlobalString); print(aGlobalString); print("end"); }`

And the console output:

`start we're generating a string now Hello World Hello World end`

And here is the static example:

`void main() { Test().run(); } class Test { static Test2 aClass = Test2(); void run() { print("Start"); print(aClass); print(aClass); print(aClass); print("End"); } } class Test2 { Test2() { print("Test2 Constructor"); } }`

console output:

`Start Test2 Constructor Instance of 'Test2' Instance of 'Test2' Instance of 'Test2' End`

Do you have a neat use-case for the late keyword? write me a message on
[LinkedIn](https://www.linkedin.com/in/athiele/)

------------------------------------------------------------------------

[![Udemy Dart
Course](//images.ctfassets.net/z94tijvlkhs1/645ItWUXIZb8urB1zY2X5u/301359ac7ee54727911c6384d8936ba6/udemy_dart.png)](https://click.linksynergy.com/link?id=6e9PFS4QBkg&offerid=1074640.3388796&bids=1074640.3388796&bids=1074640.3388796&type=2&murl=https%3a%2f%2fwww.udemy.com%2fcourse%2fcomplete-dart-guide%2f&)

<img
src="https://ad.linksynergy.com/fs-bin/show?id=6e9PFS4QBkg&amp;offerid=1074640.3388796&amp;bids=1074640.3388796&amp;type=2&amp;subid=0"
data-border="0" width="1" height="1" />
