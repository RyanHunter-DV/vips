# RhAhb5MstDriver
## mainProcess
### get sequence item
1. any time get sequence, if processDelay, wait delay
2. then push address item into address queue, if is write, wait one cycle, push data item into data queue
### process address phase
1. when no data in waiting, send address directly and wait next cycle.
2. when data in waiting, send address and wait hready high
3. when address queue has no item, send idle address
### process data phase
1. send data, and wait hready high
2. when queue is empty, then send 0 data
