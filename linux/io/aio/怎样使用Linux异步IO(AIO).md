*Note, Linux AIO is now subsumed by the io_uring API ([tutorial](https://blogs.oracle.com/linux/an-introduction-to-the-io_uring-asynchronous-io-framework), [LWN coverage](https://lwn.net/Articles/810414/)). The below explanation is mostly useful for old kernels.*

请注意，Linux AIO 现在包含在 io_uring API（教程，LWN 覆盖范围）中。 下面的解释对旧内核最有用。

参考链接: 

Linux-aio:https://github.com/littledan/linux-aio

Man: https://man7.org/linux/man-pages/man2/io_submit.2.html

## 概念

## iocb(IO控制块结构)

linux/aio_abi.h中定义的iocb（I/O控制块）结构, 用于定义控制 I/O 操作的参数



## Introduction 简介

The Asynchronous Input/Output (AIO) interface allows many I/O requests to be submitted in parallel without the overhead of a thread per request. The purpose of this document is to explain how to use the Linux AIO interface, namely the function family `io_setup`, `io_submit`, `io_getevents`, `io_destroy`. Currently, the AIO interface is best for `O_DIRECT` access to a raw block device like a disk, flash drive or storage array.

异步输入/输出 (AIO) 接口允许并行提交许多 I/O 请求，而不会产生每个请求的线程开销。 本文档的目的是解释如何使用 Linux AIO 接口，即函数家族 `io_setup`、`io_submit`、`io_getevents`、`io_destroy`。 目前，AIO 接口最适合“O_DIRECT”访问原始块设备，如磁盘、闪存驱动器或存储阵列。

## What is AIO? 
Input and output functions involve a device, like a disk or flash drive, which works much slower than the CPU. Consequently, the CPU can be doing other things while waiting for an operation on the device to complete. There are multiple ways to handle this:

- In the **synchronous I/O model**, the application issues a request from a thread. The thread blocks until the operation is complete. The operating system creates the illusion that issuing the request to the device and receiving the result was just like any other operation that would proceed just on the CPU, but in reality, it may switch in other threads or processes to make use of the CPU resources and to allow other device requests to be issued to the device in parallel, originating from the same CPU.
- In the **asynchronous I/O (AIO) model**, the application can submit one or many requests from a thread. Submitting a request does not cause the thread to block, and instead the thread can proceed to do other computations and submit further requests to the device while the original request is in flight. The application is expected to process completions and organize logical computations itself without depending on threads to organize the use of data.

Asynchronous I/O can be considered “lower level” than synchronous I/O because it does not make use of a system-provided concept of threads to organize its computation. However, it is often more efficient to use AIO than synchronous I/O due the nondeterministic overhead of threads.

输入和输出功能涉及一个设备，如磁盘或闪存驱动器，它的工作速度比 CPU 慢得多。因此，CPU 可以在等待设备上的操作完成时做其他事情。有多种方法可以处理这个问题：

- 在**同步 I/O 模型**中，应用程序从线程发出请求。线程阻塞直到操作完成。操作系统给人一种假象，认为向设备发出请求并接收结果就像任何其他只在 CPU 上进行的操作一样，但实际上它可能会切换到其他线程或进程以利用 CPU 资源并允许从同一个 CPU 发出的其他设备请求并行发送到设备。
- 在**异步 I/O (AIO) 模型**中，应用程序可以从一个线程提交一个或多个请求。提交请求不会导致线程阻塞，而是线程可以继续进行其他计算，并在原始请求进行时向设备提交更多请求。该应用程序应自行处理完成并组织逻辑计算，而不依赖于线程来组织数据的使用。

异步 I/O 可以被认为比同步 I/O “更低级别”，因为它没有使用系统提供的线程概念来组织其计算。但是，由于线程的不确定性开销，使用 AIO 通常比使用同步 I/O 更有效。



## The Linux AIO model 模型

The Linux AIO model is used as follows:

1. Open an I/O context to submit and reap I/O requests from.
1. Create one or more request objects and set them up to represent the desired operation
1. Submit these requests to the I/O context, which will send them down to the device driver to process on the device
1. Reap completions from the I/O context in the form of event completion objects,
1. Return to step 2 as needed.

Linux AIO 模型使用如下：

1. 打开一个 I/O 上下文用来提交和获取 I/O 请求。
1. 创建一个或多个请求对象并设置它们以表示所需的操作
1. 将这些请求提交到 I/O 上下文，这会将它们发送到设备驱动程序以在设备上处理
1. 以事件完成对象的形式从 I/O 上下文中获取完成，
1. 根据需要返回步骤 2。

## I/O context和iocb(control block)控制块
`io_context_t` is a pointer-sized opaque datatype that represents an “AIO context”. It can be safely passed around by value. Requests in the form of a `struct iocb` are submitted to an `io_context_t` and completions are read from the `io_context_t`. Internally, this structure contains a queue of completed requests. The length of the queue forms an upper bound on the number of concurrent requests which may be submitted to the `io_context_t`.

`io_context_t` 是一个指针大小的不透明数据类型，表示“AIO 上下文”。 它可以通过值安全地传递。 `struct iocb` 形式的请求被提交到 `io_context_t` 并从 `io_context_t` 读取完成。 在内部，此结构包含已完成请求的队列。 队列的长度构成了可以提交给 io_context_t 的并发请求数的上限。

To create a new `io_context_t`, use the function

```c
int io_setup(int maxevents, io_context_t *ctxp);
```

Here, `ctxp` is the output and `maxevents` is the input. The function creates an `io_context_t` with an internal queue of length `maxevents`. To deallocate an `io_context_t`, use

这里，`ctxp` 是输出，`maxevents` 是输入。 该函数创建一个具有长度为“maxevents”的内部队列的“io_context_t”。 要释放 `io_context_t`，请使用

```c
int io_destroy(io_context_t ctx);
```

There is a system-wide maximum number of allocated `io_context_t` objects, set at 65536.

An `io_context_t` object can be shared between threads, both for submission and completion. No guarantees are provided about ordering of submission and completion with respect to interaction from multiple threads. There may be performance implications from sharing `io_context_t` objects between threads.

系统范围内分配的 `io_context_t` 对象的最大数量设置为 65536。

`io_context_t` 对象可以在线程之间共享，用于提交和完成。 对于来自多个线程的交互，不保证提交和完成的顺序。 在线程之间共享 `io_context_t` 对象可能会影响性能。

## Submitting requests
`struct iocb` represents a single request for a read or write operation. The following struct shows a simplification on the struct definition; a full definition is found in `<libaio.h>` within the libaio source code.

`struct iocb` 表示对读取或写入操作的单个请求。 以下结构显示了结构定义的简化； 在 libaio 源代码中的 `<libaio.h>` 中可以找到完整的定义。

```c
struct iocb {
    void *data;
    short aio_lio_opcode;
    int aio_fildes;

    union {
        struct {
            void *buf;
            unsigned long nbytes;
            long long offset;
        } c;
    } u;
};
```

The meaning of the fields is as follows: data is a pointer to a user-defined object used to represent the operation

- `aio_lio_opcode` is a flag indicate whether the operation is a read (`IO_CMD_PREAD`) or a write (`IO_CMD_PWRITE`) or one of the other supported operations
- `aio_fildes` is the fd of the file that the iocb reads or writes
- `buf` is the pointer to memory that is read or written
- `nbytes` is the length of the request
- `offset` is the initial offset of the read or write within the file

字段的含义如下： data 是指向用户自定义对象的指针，用来表示操作

- `aio_lio_opcode` 是一个标志，指示操作是读取（`IO_CMD_PREAD`）还是写入（`IO_CMD_PWRITE`）或其他支持的操作之一
- `aio_fildes` 是 iocb 读取或写入的文件的 fd
- `buf` 是指向被读取或写入的内存的指针
- `nbytes` 是请求的长度
- `offset` 是文件内读取或写入的初始偏移量

The convenience functions `io_prep_pread` and `io_prep_pwrite` can be used to initialize a `struct iocb`.
New operations are sent to the device with `io_submit`.

便利函数 `io_prep_pread` 和 `io_prep_pwrite` 可用于初始化IO控制块 `iocb`。
新操作通过 `io_submit` 发送到设备

```c
int io_submit(io_context_t ctx, long nr, struct iocb *ios[]);
```

`io_submit` allows an array of pointers to `struct iocb`s to be submitted all at once. In this function call, `nr` is the length of the `ios` array. If multiple operations are sent in one array, then no ordering guarantees are given between the `iocb`s. Submitting in larger batches sometimes results in a performance improvement due to a reduction in CPU usage. A performance improvement also sometimes results from keeping many I/Os ‘in flight’ simultaneously.

If the submission includes too many iocbs such that the internal queue of the `io_context_t` would overfill on completion, then `io_submit` will return a non-zero number and set `errno` to `EAGAIN`.

When used under the right conditions, `io_submit` should not block. However, when used in certain ways, it may block, undermining the purpose of asynchronous I/O. If this is a problem for your application, be sure to use the `O_DIRECT` flag when opening a file, and operate on a raw block device. Work is ongoing to fix the problem.

`io_submit` 允许一次提交所有指向 `struct iocb` 的指针数组。 在这个函数调用中，`nr` 是 `ios` 数组的长度。 如果在一个数组中发送多个操作，则在 `iocb` 之间不提供排序保证。 由于 CPU 使用率的降低，大批量提交有时会导致性能提升。 有时，同时保持许多 I/O 处于“运行状态”也会导致性能提升。

如果提交包含太多 iocb，以至于 `io_context_t` 的内部队列在完成时会溢出，则 `io_submit` 将返回一个非零数字并将 `errno` 设置为 `EAGAIN`。

在正确的条件下使用时，`io_submit` 不应阻塞。 但是，当以某些方式使用时，它可能会阻塞，从而破坏异步 I/O 的目的。 如果这对您的应用程序来说是个问题，请务必在打开文件时使用 `O_DIRECT` 标志，并在原始块设备上进行操作。 解决问题的工作正在进行中。

## Processing results 处理结果
Completions read from an `io_context_t` are of the type `struct io_event`, which contains the following relevant fields.

从 `io_context_t` 读取的完成属于 `struct io_event` 类型(IO事件)，其中包含以下相关字段。

```c
struct io_event {
    void *data;
    struct iocb *obj;
    long long res;
};
```

Here, `data` is the same data pointer that was passed in with the `struct iocb`, and `obj` is the original `struct iocb`. `res` is the return value of the read or write.

这里，`data` 是与 `struct iocb` 一起传入的相同数据指针，而 `obj` 是原始的 `struct iocb`。 `res` 是读取或写入的返回值。

Completions are reaped with `io_getevents`.

```c
int io_getevents(io_context_t ctx_id, long min_nr, long nr, struct io_event *events, struct timespec *timeout);
```

This function has a good number of parameters, so an explanation is in order:

- `ctx_id` is the `io_context_t` that is being reaped from.
- `min_nr` is the minimum number of `io_events` to return. `io_gevents` will block until there are `min_nr` completions to report, if this is not already the case when the function call is made.
- `nr` is the maximum number of completions to return. It is expected to be the length of the `events` array.
- `events` is an array of `io_events` into which the information about completions is written.
- `timeout` is the maximum time that a call to `io_getevents` may block until it will return. If `NULL` is passed, then `io_getevents` will block until `min_nr` completions are available.

这个函数有很多参数，所以按序解释一下：

- `ctx_id` 是从中获取的`io_context_t`。
- `min_nr` 是要返回的 `io_events` 的最小数量。 `io_gevents` 将阻塞，直到有 `min_nr` 完成报告，如果在进行函数调用时还没有这种情况。
- `nr` 是要返回的最大完成数。 它应该是 `events` 数组的长度。
- `events` 是 `io_events` 的数组，其中写入了有关完成的信息。
- `timeout` 是对 `io_getevents` 的调用在返回之前可能阻塞的最长时间。 如果传递了 `NULL`，则 `io_getevents` 将阻塞，直到 `min_nr` 完成可用。

The return value represents how many completions were reported, i.e. how much of events was written. The return value will be between 0 and `nr`. The return value may be lower than `min_nr` if the timeout expires; if the timeout is `NULL`, then the return value will be between `min_nr` and `nr`.

The parameters give a broad range of flexibility in how AIO can be used.

- `min_nr = 0` (or, equivalently, `timeout = 0`). This option forms a non-blocking polling technique: it will always return immediately, regardless of whether any completions are available. It makes sense to use `min_nr = 0` when calling `io_getevents` as part of a main run-loop of an application, on each iteration.
- `min_nr = 1`. This option blocks until a single completion is available. This parameter is the minimum value which will produce a blocking call, and therefore may be the best value for low latency operations for some users. When an application notices that an `eventfd` corresponding to an iocb is triggered (see the next section about `epoll`), then the application can call `io_getevents` on the corresponding `io_context_t` with a guarantee that no blocking will occur.
- `min_nr > 1`. This option waits for multiple completions to return, unless the timeout expires. Waiting for multiple completions may improve throughput due to reduced CPU usage, both due to fewer `io_getevents` calls and because if there is more space in the completion queue due to the removed completions, then a later `io_submit` call may have a larger granularity, as well as a reduced number of context switches back to the calling thread when the event is available. This option runs the risk of increasing the latency of operations, especially when the operation rate is lower.

Even if `min_nr = 0` or `1`, it is useful to make nr a bit bigger for performance reasons: more than one event may be already complete, and it could be processed without multiple calls to `io_getevents`. The only cost of a larger nr value library is that the user must allocate a larger array of events and be prepared to accept them.

这些参数为如何使用 AIO 提供了广泛的灵活性。

- `min_nr = 0`（或者，等效地，`timeout = 0`）。此选项形成了一种非阻塞轮询技术：无论是否有任何完成可用，它总是会立即返回。在每次迭代中调用 `io_getevents` 作为应用程序的主运行循环的一部分时，使用 `min_nr = 0` 是有意义的。
- `min_nr = 1`。此选项会阻塞，直到有一个完成可用。该参数是产生阻塞调用的最小值，因此对于某些用户来说可能是低延迟操作的最佳值。当应用程序注意到触发了对应于 iocb 的 `eventfd` 时（请参阅下一节有关 `epoll` 的内容），然后应用程序可以在相应的 `io_context_t` 上调用 `io_getevents`，并保证不会发生阻塞。
- `min_nr > 1`。此选项等待多个完成返回，除非超时到期。由于减少了 CPU 使用率，等待多个完成可能会提高吞吐量，这既是由于更少的 io_getevents 调用，也是因为如果完成队列中由于删除完成而有更多空间，那么稍后的 io_submit 调用可能具有更大的粒度，以及在事件可用时减少上下文切换回调用线程的次数。此选项存在增加操作延迟的风险，尤其是在操作率较低时。

即使 `min_nr = 0` 或 `1`，出于性能原因，将 nr 设置得更大一点也很有用：可能已经完成了多个事件，并且可以在不多次调用 `io_getevents` 的情况下对其进行处理。更大的 nr 值库的唯一成本是用户必须分配更大的事件数组并准备好接受它们。

## Use with epoll
Any `iocb` can be set to notify an `eventfd` on completion using the libaio function `io_set_eventfd`. The `eventfd` can be put in an `epoll` object. When the `eventfd` is triggered, then the `io_getevents` function can be called on the corresponding `io_context_t`.

There is no way to use this API to trigger an eventfd only when multiple operations are complete--the eventfd will always be triggered on the first operation. Consequently, as described in the previous section, it will often make sense to use `min_nr = 1` when using `io_getevents` after an `epoll_wait` call that indicates an `eventfd` involved in AIO.

任何 `iocb` 都可以使用 libaio 函数 `io_set_eventfd` 设置为在完成时通知 `eventfd`。 `eventfd` 可以放在`epoll` 对象中。 当 `eventfd` 被触发时，可以在对应的 `io_context_t` 上调用 `io_getevents` 函数。

仅当多个操作完成时，无法使用此 API 触发 eventfd - eventfd 将始终在第一个操作时触发。 因此，如前一节所述，在指示 AIO 中涉及的 `eventfd` 的调用 `epoll_wait` 之后使用 `io_getevents` 时，使用 `min_nr = 1` 通常是有意义的。

## Performance considerations 性能优化
- **Blocking during `io_submit` on ext4, on buffered operations, network access, pipes, etc.** Some operations are not well-represented by the AIO interface. With completely unsupported operations like buffered reads, operations on a socket or pipes, the entire operation will be performed during the io_submit syscall, with the completion available immediately for access with io_getevents. AIO access to a file on a filesystem like ext4 is partially supported: if a metadata read is required to look up the data block (ie if the metadata is not already in memory), then the io_submit call will block on the metadata read. Certain types of file-enlarging writes are completely unsupported and block for the entire duration of the operation.
- **CPU overhead.** When performing small operations on a high-performance device and targeting a very high operation rate from single CPU, a CPU bottleneck may result. This can be resolved by submitting and reaping AIO from multiple threads.
- **Lock contention when many CPUs or requests share an io_context_t.** There are several circumstances when the kernel datastructure corresponding to an io_context_t may be accessed from multiple CPUs. For example, multiple threads may submit and get events from the same io_context_t. Some devices may use a single interrupt line for all completions. This can cause the lock to be bounced around between cores or the lock to be heavily contended, resulting in higher CPU usage and potentially lower throughput. One solution is to shard into multiple io_context_t objects, for example by thread and a hash of the address.
- **Ensuring sufficient parallelism.** Some devices require many concurrent operations to reach peak performance. This means making sure that there are several operations ‘in flight’ simultaneously. On some high-performance storage devices, when operations are small, tens or hundreds must be submitted in parallel in order to achieve maximum throughput. For disk drives, performance may improve with greater parallelism if the elevator scheduler can make better decisions with more operations simultaneously in flight, but the effect is expected to be small in many situations.

- **在 ext4 上的 `io_submit` 期间阻塞，在缓冲操作、网络访问、管道等上** 一些操作没有被 AIO 接口很好地表示。对于缓冲读取、套接字或管道上的操作等完全不受支持的操作，整个操作将在 io_submit 系统调用期间执行，完成后立即可用 io_getevents 访问。部分支持对文件系统（如 ext4）上文件的 AIO 访问：如果需要读取元数据来查找数据块（即，如果元数据不在内存中），则 io_submit 调用将阻塞元数据读取。某些类型的文件放大写入完全不受支持，并在整个操作期间阻塞。
- **CPU 开销。** 当在高性能设备上执行小操作并针对单个 CPU 的非常高的操作率时，可能会导致 CPU 瓶颈。这可以通过从多个线程提交和获取 AIO 来解决。
- **当多个 CPU 或请求共享一个 io_context_t 时的锁争用。** 在某些情况下，可以从多个 CPU 访问对应于 io_context_t 的内核数据结构。例如，多个线程可以从同一个 io_context_t 提交和获取事件。一些设备可能对所有完成使用单个中断线。这可能导致锁在内核之间反弹或锁被严重竞争，从而导致更高的 CPU 使用率和潜在的更低吞吐量。一种解决方案是分片成多个 io_context_t 对象，例如通过线程和地址的哈希。
- **确保足够的并行性。** 一些设备需要许多并发操作才能达到峰值性能。这意味着要确保同时有多个“正在运行”的操作。在一些高性能存储设备上，当操作量较小时，必须并行提交数十或数百个，才能达到最大吞吐量。对于磁盘驱动器，如果电梯调度程序可以在飞行中同时进行更多操作做出更好的决策，则性能可能会随着更大的并行性而提高，但在许多情况下预计效果会很小。

## Alternatives to Linux AIO 备选方案
- **Thread pool of synchronous I/O threads.** This can work for many use cases, and it may be easier to program with. Unlike with AIO, all functions can be parallelized via a thread pool. Some users find that a thread pool does not work well due to the overhead of threads in terms of CPU and memory bandwidth usage from context switching. This comes up as an especially big problem with small random reads on high-performance storage devices.
- **POSIX AIO.** Another asynchronous I/O interface is POSIX AIO. It is implemented as part of glibc. However, the glibc implementation uses a thread pool internally. For cases where this is acceptable, it might be better to use your own thread pool instead. Joel Becker implemented [a version](https://oss.oracle.com/projects/libaio-oracle/files/) of POSIX AIO based on the Linux AIO mechanism described above. IBM DeveloperWorks has [a good introduction](http://www.ibm.com/developerworks/linux/library/l-async/index.html) to POSIX AIO.
- **epoll.** Linux has limited support for using epoll as a mechanism for asynchronous I/O. For reads to a file opened in buffered mode (that is, without O_DIRECT), if the file is opened as O_NONBLOCK, then a read will return EAGAIN until the relevant part is in memory. Writes to a buffered file are usually immediate, as they are written out with another writeback thread. However, these mechanisms don’t give the level of control over I/O that direct I/O gives.

- **同步 I/O 线程的线程池。** 这适用于许多用例，并且可能更易于编程。与 AIO 不同，所有功能都可以通过线程池并行化。一些用户发现线程池不能很好地工作，因为线程在 CPU 和内存带宽使用方面的开销来自上下文切换。对于高性能存储设备上的小随机读取，这是一个特别大的问题。
- **POSIX AIO。**另一个异步 I/O 接口是 POSIX AIO。它是作为 glibc 的一部分实现的。但是，glibc 实现在内部使用线程池。对于可以接受的情况，最好改用您自己的线程池。 Joel Becker 基于上述 Linux AIO 机制实现了 POSIX AIO [一个版本](https://oss.oracle.com/projects/libaio-oracle/files/)。 IBM DeveloperWorks 对 POSIX AIO 有 [很好的介绍](http://www.ibm.com/developerworks/linux/library/l-async/index.html)。
- **epoll.** Linux 对使用 epoll 作为异步 I/O 机制的支持有限。对于以缓冲模式（即没有 O_DIRECT）打开的文件的读取，如果文件以 O_NONBLOCK 方式打开，则读取将返回 EAGAIN，直到相关部分在内存中。对缓冲文件的写入通常是立即的，因为它们是通过另一个写回线程写出的。但是，这些机制并没有提供直接 I/O 提供的对 I/O 的控制级别。

## Sample code 示例代码
Below is some example code which uses Linux AIO. I wrote it at Google, so it uses the [Google glog logging library](https://github.com/google/glog) and the [Google gflags command-line flags library](http://gflags.github.io/gflags/), as well as a loose interpretation of [Google’s C++ coding conventions](https://google.github.io/styleguide/cppguide.html). When compiling it with gcc, pass `-laio` to dynamically link with libaio. (It isn’t included in glibc, so it must be explicitly included.)

下面是一些使用 Linux AIO 的示例代码。 我是在 Google 写的，所以它使用 [Google glog 日志库](https://github.com/google/glog) 和 [Google gflags 命令行标志库](http://gflags.github.io /gflags/)，以及对 [Google 的 C++ 编码约定](https://google.github.io/styleguide/cppguide.html) 的松散解释。 使用 gcc 编译时，通过 `-laio` 与 libaio 动态链接。 （它不包含在 glibc 中，因此必须明确包含。）gcc -laio

```c
// Code written by Daniel Ehrenberg, released into the public domain

#include <fcntl.h>
#include <gflags/gflags.h>
#include <glog/logging.h>
#include <libaio.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/stat.h>
#include <sys/types.h>

DEFINE_string(path, "/tmp/testfile", "Path to the file to manipulate");
DEFINE_int32(file_size, 1000, "Length of file in 4k blocks");
DEFINE_int32(concurrent_requests, 100, "Number of concurrent requests");
DEFINE_int32(min_nr, 1, "min_nr");
DEFINE_int32(max_nr, 1, "max_nr");

// The size of operation that will occur on the device
static const int kPageSize = 4096;

class AIORequest {
 public:
  int* buffer_;

  virtual void Complete(int res) = 0;

  AIORequest() {
    int ret = posix_memalign(reinterpret_cast<void**>(&buffer_),
                             kPageSize, kPageSize);
    CHECK_EQ(ret, 0);
  }

  virtual ~AIORequest() {
    free(buffer_);
  }
};

class Adder {
 public:
  virtual void Add(int amount) = 0;

  virtual ~Adder() { };
};

class AIOReadRequest : public AIORequest {
 private:
  Adder* adder_;

 public:
  AIOReadRequest(Adder* adder) : AIORequest(), adder_(adder) { }

  virtual void Complete(int res) {
    CHECK_EQ(res, kPageSize) << "Read incomplete or error " << res;
    int value = buffer_[0];
    LOG(INFO) << "Read of " << value << " completed";
    adder_->Add(value);
  }
};

class AIOWriteRequest : public AIORequest {
 private:
  int value_;

 public:
  AIOWriteRequest(int value) : AIORequest(), value_(value) {
    buffer_[0] = value;
  }

  virtual void Complete(int res) {
    CHECK_EQ(res, kPageSize) << "Write incomplete or error " << res;
    LOG(INFO) << "Write of " << value_ << " completed";
  }
};

class AIOAdder : public Adder {
 public:
  int fd_;
  io_context_t ioctx_;
  int counter_;
  int reap_counter_;
  int sum_;
  int length_;

  AIOAdder(int length)
      : ioctx_(0), counter_(0), reap_counter_(0), sum_(0), length_(length) { }

  void Init() {
    LOG(INFO) << "Opening file";
    fd_ = open(FLAGS_path.c_str(), O_RDWR | O_DIRECT | O_CREAT, 0644);
    PCHECK(fd_ >= 0) << "Error opening file";
    LOG(INFO) << "Allocating enough space for the sum";
    PCHECK(fallocate(fd_, 0, 0, kPageSize * length_) >= 0) << "Error in fallocate";
    LOG(INFO) << "Setting up the io context";
    PCHECK(io_setup(100, &ioctx_) >= 0) << "Error in io_setup";
  }

  virtual void Add(int amount) {
    sum_ += amount;
    LOG(INFO) << "Adding " << amount << " for a total of " << sum_;
  }

  void SubmitWrite() {
    LOG(INFO) << "Submitting a write to " << counter_;
    struct iocb iocb;
    struct iocb* iocbs = &iocb;
    AIORequest *req = new AIOWriteRequest(counter_);
    io_prep_pwrite(&iocb, fd_, req->buffer_, kPageSize, counter_ * kPageSize);
    iocb.data = req;
    int res = io_submit(ioctx_, 1, &iocbs);
    CHECK_EQ(res, 1);
  }

  void WriteFile() {
    reap_counter_ = 0;
    for (counter_ = 0; counter_ < length_; counter_++) {
      SubmitWrite();
      Reap();
    }
    ReapRemaining();
  }

  void SubmitRead() {
    LOG(INFO) << "Submitting a read from " << counter_;
    struct iocb iocb;
    struct iocb* iocbs = &iocb;
    AIORequest *req = new AIOReadRequest(this);
    io_prep_pread(&iocb, fd_, req->buffer_, kPageSize, counter_ * kPageSize);
    iocb.data = req;
    int res = io_submit(ioctx_, 1, &iocbs);
    CHECK_EQ(res, 1);
  }

  void ReadFile() {
    reap_counter_ = 0;
    for (counter_ = 0; counter_ < length_; counter_++) {
        SubmitRead();
        Reap();
    }
    ReapRemaining();
  }

  int DoReap(int min_nr) {
    LOG(INFO) << "Reaping between " << min_nr << " and "
              << FLAGS_max_nr << " io_events";
    struct io_event* events = new io_event[FLAGS_max_nr];
    struct timespec timeout;
    timeout.tv_sec = 0;
    timeout.tv_nsec = 100000000;
    int num_events;
    LOG(INFO) << "Calling io_getevents";
    num_events = io_getevents(ioctx_, min_nr, FLAGS_max_nr, events,
                              &timeout);
    LOG(INFO) << "Calling completion function on results";
    for (int i = 0; i < num_events; i++) {
      struct io_event event = events[i];
      AIORequest* req = static_cast<AIORequest*>(event.data);
      req->Complete(event.res);
      delete req;
    }
    delete events;
    
LOG(INFO) << "Reaped " << num_events << " io_events";
    reap_counter_ += num_events;
    return num_events;
  }

  void Reap() {
    if (counter_ >= FLAGS_min_nr) {
      DoReap(FLAGS_min_nr);
    }
  }

  void ReapRemaining() {
    while (reap_counter_ < length_) {
      DoReap(1);
    }
  }

  ~AIOAdder() {
    LOG(INFO) << "Closing AIO context and file";
    io_destroy(ioctx_);
    close(fd_);
  }

  int Sum() {
    LOG(INFO) << "Writing consecutive integers to file";
    WriteFile();
    LOG(INFO) << "Reading consecutive integers from file";
    ReadFile();
    return sum_;
  }
};

int main(int argc, char* argv[]) {
  google::ParseCommandLineFlags(&argc, &argv, true);
  AIOAdder adder(FLAGS_file_size);
  adder.Init();
  int sum = adder.Sum();
  int expected = (FLAGS_file_size * (FLAGS_file_size - 1)) / 2;
  LOG(INFO) << "AIO is complete";
  CHECK_EQ(sum, expected) << "Expected " << expected << " Got " << sum;
  printf("Successfully calculated that the sum of integers from 0"
         " to %d is %d\n", FLAGS_file_size - 1, sum);
  return 0;
}
```

另一个示例

```c
#define _GNU_SOURCE
#define __STDC_FORMAT_MACROS

#include <stdio.h>
#include <errno.h>
#include <libaio.h>
#include <sys/eventfd.h>
#include <sys/epoll.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>
#include <stdint.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <inttypes.h>

#define TEST_FILE "aio_test_file"
#define TEST_FILE_SIZE (127 * 1024)
#define NUM_EVENTS 128
#define ALIGN_SIZE 512
#define RD_WR_SIZE 1024

/*
环境: 在centos 6.2 (libaio-devel 0.3.107-10) 上运行通过
参考: linux异步IO编程实例分析(https://zhuanlan.zhihu.com/p/258464210)
执行:
gcc aio.c -laio
*/

struct custom_iocb
{
  struct iocb iocb;
  int nth_request;
};

void aio_callback(io_context_t ctx, struct iocb *iocb, long res, long res2)
{
  struct custom_iocb *iocbp = (struct custom_iocb *)iocb;
  printf("nth_request: %d, request_type: %s, offset: %lld, length: %lu, res: %ld, res2: %ld\n",
         iocbp->nth_request, (iocb->aio_lio_opcode == IO_CMD_PREAD) ? "READ" : "WRITE",
         iocb->u.c.offset, iocb->u.c.nbytes, res, res2);
}

int main(int argc, char *argv[])
{
  int efd, fd, epfd;
  io_context_t ctx;
  struct timespec tms;
  struct io_event events[NUM_EVENTS];
  struct custom_iocb iocbs[NUM_EVENTS];
  struct iocb *iocbps[NUM_EVENTS];
  struct custom_iocb *iocbp;
  int i, j, r;
  void *buf;
  struct epoll_event epevent;

  // 这里的resfd是通过系统调用eventfd生成的, eventfd是linux 2.6.22内核之后加进来的syscall，作用是内核用来通知应用程序发生的事件的数量，从而使应用程序不用频繁地去轮询内核是否有时间发生，而是由内核将发生事件的数量写入到该fd，应用程序发现fd可读后，从fd读取该数值，并马上去内核读取, 有了eventfd，就可以很好地将libaio和epoll事件循环结合起来
  efd = eventfd(0, EFD_NONBLOCK | EFD_CLOEXEC);
  if (efd == -1)
  {
    perror("eventfd");
    return 2;
  }

  fd = open(TEST_FILE, O_RDWR | O_CREAT | O_DIRECT, 0644);
  if (fd == -1)
  {
    perror("open");
    return 3;
  }
  ftruncate(fd, TEST_FILE_SIZE);

  ctx = 0;
  // 1. 建立IO任务   int io_setup (int maxevents, io_context_t *ctxp);
  if (io_setup(8192, &ctx))
  {
    perror("io_setup");
    return 4;
  }

  // 读写的buf都必须是按扇区对齐的，可以用posix_memalign来分配
  if (posix_memalign(&buf, ALIGN_SIZE, RD_WR_SIZE))
  {
    perror("posix_memalign");
    return 5;
  }
  printf("buf: %p\n", buf);

  for (i = 0, iocbp = iocbs; i < NUM_EVENTS; ++i, ++iocbp)
  {
    iocbps[i] = &iocbp->iocb;
    // 填充iocb结构体, void io_prep_pread(struct iocb *iocb, int fd, void *buf, size_t count, long long offset)
    io_prep_pread(&iocbp->iocb, fd, buf, RD_WR_SIZE, i * RD_WR_SIZE);
    io_set_eventfd(&iocbp->iocb, efd); // 将eventfd设置到iocb中
    io_set_callback(&iocbp->iocb, aio_callback);
    iocbp->nth_request = i + 1;
  }

  // 2.提交IO任务, long io_submit (aio_context_t ctx_id, long nr, struct iocb **iocbpp);
  if (io_submit(ctx, NUM_EVENTS, iocbps) != NUM_EVENTS)
  {
    perror("io_submit");
    return 6;
  }

  // 创建一个epollfd，并将eventfd加到epoll中
  epfd = epoll_create(1);
  if (epfd == -1)
  {
    perror("epoll_create");
    return 7;
  }

  epevent.events = EPOLLIN | EPOLLET;
  epevent.data.ptr = NULL;
  if (epoll_ctl(epfd, EPOLL_CTL_ADD, efd, &epevent))
  {
    perror("epoll_ctl");
    return 8;
  }

  i = 0;
  while (i < NUM_EVENTS)
  {
    uint64_t finished_aio;

    if (epoll_wait(epfd, &epevent, 1, -1) != 1)
    {
      perror("epoll_wait");
      return 9;
    }

    // 当eventfd可读时，从eventfd读出完成IO请求的数量，并调用io_getevents获取这些IO
    if (read(efd, &finished_aio, sizeof(finished_aio)) != sizeof(finished_aio))
    {
      perror("read");
      return 10;
    }

    printf("finished io number: %" PRIu64 "\n", finished_aio);

    while (finished_aio > 0)
    {
      tms.tv_sec = 0;
      tms.tv_nsec = 0;
      // 3.获取完成的IO, 提供一个io_event数组给内核来copy完成的IO请求到这里，数组的大小是io_setup时指定的maxevents,timeout是指等待IO完成的超时时间，设置为NULL表示一直等待所有到IO的完成
      // long io_getevents (aio_context_t ctx_id, long min_nr, long nr, struct io_event *events, struct timespec *timeout);
      r = io_getevents(ctx, 1, NUM_EVENTS, events, &tms);
      // printf("r:%d", r);
      if (r > 0)
      {
        for (j = 0; j < r; ++j)
        {
          ((io_callback_t)(events[j].data))(ctx, events[j].obj, events[j].res, events[j].res2);
        }
        i += r;
        finished_aio -= r;
      }
      else
      {
        finished_aio = 0;
        printf("finished_aio:%" PRIu64 "\n", finished_aio);
      }
    }
  }

  printf("end\n");
  close(epfd);
  free(buf);
  // 4.销毁IO任务, int io_destroy (io_context_t ctx);
  io_destroy(ctx);
  close(fd);
  close(efd);
  remove(TEST_FILE);

  return 0;
}
```

