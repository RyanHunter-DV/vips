This testplan is for VIP feature verification, and each of passed test/env can be an example for users.
# TestPoints
## SINGLE burst transactions
**stimulus**
- master sending multiple single bursts
- slave responding by the randomResponder
- HREADY delay
	- no delay
	- with delay
**checker**
- protocol checker, using assertion in interface
- compare req and rsp collected by master monitor and slave monitor, automatically enabled in env level.
- compare transactions from test and with master monitor
	- transactions in test level created by user and sent to VIP, [[#exp transaction by test, example]]

## INCR burst transaction
## INCR4 burst transaction
## WRAP4 burst transaction
## INCR8 burst
## WRAP8 burst
## INCR16 burst
## WRAP16 burst
## memory slave test
- with random burst type
- write a series of address with different burst type, then read by random
- with OK response, randomly with delay or no delay
## error responding
- with random burst type
- randomly error given by customResponder mode

# ENV
## omosEnv
This is the one master one slave environment, for VIP version 1.x, we only tested on omos.


# Tests
## RhAhb5BaseTest
[[RhAhb5BaseTest]]
## RhAhb5SingleTest
[[RhAhb5SingleTest]]
**stimulus**
- int testloop, 100 by default, can be configured by plusargs
- for each testloop, do following
	- create `RhAhb5SingleSeq`, randomize by:
		- master lock disabled.
		- send delay with 0~20 cycles.
	- get expection transactions from seq.expectTrans()
	- config env:
		- slave ready delay within 0~100 cycles.
		- using random responder of the slave.

## RhAhb5IncrTest
**stimulus**
similar case with [[#RhAhb5SingleTest]], using `RhAhb5IncrSeq`.


# Strategies

## exp transaction by test, example
```systemverilog
RhAhb5SingleSeq seq=new(xxx);
seq.randomize() with {...};
RhAhb5ReqTrans tr[$];
tr = seq.expectTrans();
foreach(tr[i]) expections.push_back(tr[i]);
seq.start(xxxx);
```
