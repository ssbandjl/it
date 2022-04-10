Fio 最初是为了在我想测试特定工作负载时省去编写特殊测试用例程序的麻烦，无论是出于性能原因还是查找/重现错误。编写这样一个测试应用程序的过程可能很烦人，尤其是如果你必须经常这样做的话。因此，我需要一个能够模拟给定 I/O 工作负载的工具，而无需一次又一次地编写定制的测试用例。

但是，测试工作量很难定义。可以涉及任意数量的进程或线程，并且它们每个都可以使用自己的方式来生成 I/O。您可能有人在内存映射文件中弄脏大量内存，或者可能有多个线程使用异步 I/O 发出读取。 fio 需要足够灵活以模拟这两种情况，甚至更多。

Fio 会产生许多线程或进程来执行用户指定的特定类型的 I/O 操作。 fio 采用许多全局参数，每个参数都由线程继承，除非给定的参数覆盖了该设置。 fio 的典型用途是编写一个与想要模拟的 I/O 负载相匹配的作业文件。



Fio 由 Jens Axboe <axboe@kernel.dk> 编写，以实现对 Linux I/O 子系统和调度程序的灵活测试。 他厌倦了编写特定的测试应用程序来模拟给定的工作负载，并发现现有的 I/O 基准测试/测试工具不够灵活，无法满足他的要求。

Jens Axboe <axboe@kernel.dk> 20060905



编译

请注意，GNU make 是必需的。 在 BSD 上，它可以从 ports 目录中的 devel/gmake 获得； 在 Solaris 上，它位于 SUNWgmake 包中。 在 GNU make 不是默认的平台上，键入 gmake 而不是 make。

配置将打印启用的选项。 请注意，在基于 Linux 的平台上，必须安装 libaio 开发包才能使用 libaio 引擎。 根据发行版，它通常称为 libaio-devel 或 libaio-dev。

对于 gfio，需要安装 gtk 2.18（或更新版本）、相关的 glib 线程和 cairo。 gfio 不是自动构建的，可以使用 --enable-gfio 选项进行配置。

使用交叉编译器构建 fio：

$ 清理
$ make CROSS_COMPILE=/path/to/toolchain/prefix
Configure 将尝试自动确定目标平台。

也可以为 ESX 构建 fio，使用 --esx 开关进行配置。



文档:

Fio 使用 Sphinx 从 reStructuredText 文件生成文档。 要构建 HTML 格式的文档，请运行 make -C doc html 并将浏览器定向到 ./doc/output/html/index.html。 要构建手册页，请运行 make -C doc man，然后运行 man doc/output/man/fio.1。 要查看支持的其他输出格式，请运行 make -C doc help。



平台:

Fio 可在（至少）Linux、Solaris、AIX、HP-UX、OSX、NetBSD、OpenBSD、Windows、FreeBSD 和 DragonFly 上运行。某些功能和/或选项可能仅在某些平台上可用，通常是因为这些功能仅适用于该平台（如 solarisaio 引擎或 Linux 上的拼接引擎）。

有些功能在 FreeBSD/Solaris 上不可用，即使它们可以实现，我很乐意为此提供补丁。一个例子是磁盘实用程序统计和（我认为）大页面支持，FreeBSD/Solaris 中确实存在对它的支持。

Fio 使用 pthread 互斥体进行信号和锁定，并且某些平台不支持进程共享 pthread 互斥体。因此，在此类平台上仅支持线程。这可以通过 sysv ipc 锁定或其他锁定替代方案来解决。

其他 *BSD 平台未经测试，但 fio 几乎可以直接在其中工作。由于我不在这些平台上进行测试运行甚至编译，因此您的里程可能会有所不同。非常感谢向我发送其他平台的补丁。在所有平台上提供相同的测试/基准测试工具有很多价值。

请注意，在 AIX 上默认情况下不启用 POSIX aio。像这样的消息：





1.8.运行 fio
运行 fio 通常是最简单的部分 - 你只需将作业文件（或作业文件）作为参数给它：

$ fio [选项] [作业文件] ...
它会开始做jobfile告诉它做的事情。您可以在命令行上提供多个作业文件，fio 将序列化这些文件的运行。在内部，这与使用参数部分中描述的石墙参数相同。

如果作业文件只包含一个作业，你也可以在命令行中给出参数。命令行参数与作业参数相同，但有一些额外的控制全局参数。例如，对于作业文件参数 iodepth=2，镜像命令行选项将为 --iodepth 2 或 --iodepth=2。您还可以使用命令行来提供多个作业条目。对于 fio 看到的每个 --name 选项，它将使用该名称启动一个新作业。 --name 条目之后的命令行条目将应用于该作业，直到没有更多条目或看到新的 --name 条目。这类似于作业文件选项，其中每个选项都适用于当前作业，直到看到新的 [] 作业条目。

fio 不需要以 root 身份运行，除非作业部分中指定的文件或设备需要这样做。其他一些选项也可能会受到限制，例如内存锁定、I/O 调度程序切换和降低 nice 值。

如果 jobfile 指定为 -，则将从标准输入中读取作业文件。



1.9。 fio的工作原理
让 fio 模拟所需的 I/O 工作负载的第一步是编写一个描述该特定设置的作业文件。作业文件可能包含任意数量的线程和/或文件——作业文件的典型内容是定义共享参数的全局部分，以及描述所涉及作业的一个或多个作业部分。运行时，fio 会解析此文件并按照描述设置所有内容。如果我们从上到下分解一个作业，它包含以下基本参数：

输入输出类型

定义发布给文件的 I/O 模式。我们可能只是从这个文件中顺序读取，或者我们可能是随机写入。甚至可以按顺序或随机混合读取和写入。我们应该做缓冲 I/O，还是直接/原始 I/O？
块大小

我们以多大的块发出 I/O？这可以是单个值，也可以描述块大小的范围。
输入输出大小

我们要读/写多少数据。
输入输出引擎

我们如何发出 I/O？我们可以对文件进行内存映射，可以使用常规读/写，可以使用拼接、异步 I/O 甚至 SG（SCSI 通用 sg）。
输入输出深度

如果 I/O 引擎是异步的，我们希望保持多大的队列深度？
目标文件/设备

我们将工作量分散到多少个文件上。
线程、进程和作业同步

我们应该将这个工作负载分散到多少个线程或进程上。
以上是为工作负载定义的基本参数，此外还有许多参数可以修改此作业行为的其他方面。



引擎:

1.12.10。输入输出引擎
ioengine=str
定义作业如何向文件发出 I/O。定义了以下类型：

同步
基本读 (2) 或写 (2) I/O。 lseek(2) 用于定位 I/O 位置。请参阅 fsync 和 fdatasync 以同步写入 I/O。
同步
基本的 pread(2) 或 pwrite(2) I/O。在除 Windows 之外的所有支持的操作系统上都是默认设置。
垂直同步
基本的 readv(2) 或 writev(2) I/O。将通过将相邻 I/O 合并为单个提交来模拟排队。
同步
基本 preadv(2) 或 pwritev(2) I/O。
pvsync2
基本 preadv2(2) 或 pwritev2(2) I/O。
io_uring
快速的 Linux 原生异步 I/O。支持直接和缓冲 IO 的异步 IO。该引擎定义了引擎特定的选项。
libaio
Linux 本机异步 I/O。请注意，Linux 可能仅支持非缓冲 I/O 的排队行为（设置 direct=1 或 buffered=0）。该引擎定义了引擎特定的选项。
波西沙约
使用 aio_read(3) 和 aio_write(3) 的 POSIX 异步 I/O。
太阳能
Solaris 本机异步 I/O。
窗户赛奥
Windows 本机异步 I/O。 Windows 上的默认设置。
地图
文件使用 mmap(2) 进行内存映射，并使用 memcpy(3) 将数据复制到/从内存中复制。
拼接
splice(2) 用于传输数据，vmsplice(2) 用于将数据从用户空间传输到内核。
SG
SCSI 通用 sg v3 I/O。可以使用 SG_IO ioctl 进行同步，或者如果目标是 sg 字符设备，我们使用 read(2) 和 write(2) 进行异步 I/O。需要文件名选项来指定块设备或字符设备。该引擎支持修剪操作。 sg 引擎包括引擎特定的选项。
libzbc
使用 libzbc 库对分区块设备进行读取、写入、修整和 ZBC/ZAC 操作。目标可以是 SG 字符设备或块设备文件。
空值
不传输任何数据，只是假装。这主要用于锻炼 fio 本身以及用于调试/测试目的。
网
通过网络传输到给定的主机：端口。根据所使用的协议，主机名、端口、侦听和文件名选项用于指定要建立哪种类型的连接，而协议选项确定将使用哪种协议。该引擎定义了引擎特定的选项。
网络拼接
与 net 类似，但使用 splice(2) 和 vmsplice(2) 来映射数据和发送/接收。该引擎定义了引擎特定的选项。
cpuio
不传输任何数据，但会根据 cpuload、cpuchunks 和 cpumode 选项消耗 CPU 周期。设置 cpuload=85 将导致该作业只消耗 85% 的 CPU。对于 SMP 机器，使用 numjobs=<nr_of_cpu> 来获得所需的 CPU 使用率，因为 cpuload 仅以所需的速率加载单个 CPU。除非至少有一个非 cpuio 作业，否则作业永远不会完成。设置 cpumode=qsort 用 qsort 算法替换默认的 noop 指令循环以消耗更多能量。
rdma
RDMA I/O 引擎支持 InfiniBand、RoCE 和 iWARP 协议的 RDMA 内存语义 (RDMA_WRITE/RDMA_READ) 和通道语义 (Send/Recv)。该引擎定义了引擎特定的选项。
法洛克
执行定期 fallocate 以模拟数据传输的 I/O 引擎作为 fio ioengine。

DDIR_READ
fallocate(,mode = FALLOC_FL_KEEP_SIZE,)。
DDIR_WRITE
fallocate(,mode = 0)。
DDIR_TRIM
fallocate(,mode = FALLOC_FL_KEEP_SIZE|FALLOC_FL_PUNCH_HOLE)。
截断
发送 ftruncate(2) 操作以响应写入 (DDIR_WRITE) 事件的 I/O 引擎。发出的每个 ftruncate 都会将文件的大小设置为当前块偏移量。块大小被忽略。
e4defrag
I/O 引擎执行常规 EXT4_IOC_MOVE_EXT ioctls 以模拟对 DDIR_WRITE 事件的请求中的碎片整理活动。
雷达
I/O 引擎支持通过 librados 直接访问 Ceph Reliable Autonomic Distributed Object Store (RADOS)。此 ioengine 定义引擎特定的选项。
rbd
I/O 引擎支持通过 librbd 直接访问 Ceph Rados 块设备 (RBD)，无需使用内核 rbd 驱动程序。此 ioengine 定义引擎特定的选项。
http
I/O 引擎支持通过 HTTP(S) 与 libcurl 到 WebDAV 或 S3 端点的 GET/PUT 请求。此 ioengine 定义引擎特定的选项。

本引擎只支持iodepth=1的直接IO；你需要通过 numjobs 来扩展它。 blocksize 定义要创建的对象的大小。

TRIM 被翻译为对象删除。

gfapi
使用 GlusterFS libgfapi 同步接口直接访问 GlusterFS 卷，而无需通过 FUSE。此 ioengine 定义引擎特定的选项。
gfapi_async
使用 GlusterFS libgfapi 异步接口直接访问 GlusterFS 卷，而无需通过 FUSE。此 ioengine 定义引擎特定的选项。
库文件
通过 Hadoop (HDFS) 读写。 filename 选项用于指定要连接的 hdfs 名称节点的主机、端口。该引擎对偏移的解释略有不同。在 HDFS 中，文件一旦创建就无法修改，因此无法进行随机写入。为了模仿这一点，libhdfs 引擎期望在 HDFS 上创建一堆小文件，并将根据偏移量从它们中随机选择一个文件

由 fio 后端编写（请参阅示例作业文件以创建此类文件，使用 rw=write 选项）。请注意，可能需要设置环境变量才能正确使用 HDFS/libhdfs。每个作业都使用自己的 HDFS 连接。
mtd
读取、写入和擦除 MTD 字符设备（例如 /dev/mtd0）。丢弃被视为擦除。根据底层设备类型，I/O 可能必须以某种模式进行，例如，在 NAND 上，顺序写入擦除块并在覆盖之前丢弃。 trimwrite 模式适用于此约束。
pmemblk
通过 PMDK libpmemblk 库，使用文件系统 DAX 读取和写入文件系统上的文件，该文件系统通过 DAX 安装在持久性内存设备上。
开发达克斯
通过 PMDK libpmem 库使用设备 DAX 对持久内存设备（例如 /dev/dax0.0）进行读写。
外部的
指定加载外部 I/O 引擎对象文件的前缀。附加引擎文件名，例如ioengine=external:/tmp/foo.o 在 /tmp 中加载 ioengine foo.o。路径可以是绝对的或相对的。有关编写外部 I/O 引擎的详细信息，请参阅engines/skeleton_external.c。
文件创建
只需创建文件并且不对它们执行 I/O。您仍然需要设置文件大小，以便仍然进行所有记帐，但除了创建文件之外不会执行任何实际 I/O。
文件统计
只需执行 stat() 并且不对文件执行 I/O。您需要设置“filesize”和“nrfiles”，以便创建文件。该引擎用于测量文件查找和元数据访问。
归档删除
只需通过 unlink() 删除文件并且不对它们执行 I/O。您需要设置“filesize”和“nrfiles”，以便创建文件。该引擎用于测量文件删除。
libpmem
通过 PMDK libpmem 库，使用 mmap I/O 读取和写入文件系统上的文件，该文件系统通过 DAX 安装在持久性内存设备上。
ime_psync
使用 DDN 的无限内存引擎 (IME) 进行同步读写。这个引擎非常基础，只要 IO 排队，就会调用 IME。
ime_psyncv
使用 DDN 的无限内存引擎 (IME) 进行同步读写。此引擎使用 iovecs 并会在发出对 IME 的调用之前尝试堆叠尽可能多的 IO（如果 IO 是“连续的”并且不超过 IO 深度）。
ime_aio
使用 DDN 的无限内存引擎 (IME) 进行异步读写。该引擎将尝试通过创建 IME 请求来堆叠尽可能多的 IO。然后 FIO 将决定何时提交这些请求。
图书馆
使用 libiscsi 读写 iscsi lun。
nbd
读取和写入网络块设备 (NBD)。
库文件
支持 libcufile 同步访问 nvidia-fs 和 GPUDirect 存储支持的文件系统的 I/O 引擎。该引擎执行 I/O 而不在用户空间和内核之间传输缓冲区，除非设置了 verify 或 cuda_io 为 posix。 iomem 不能是 cudamalloc。此 ioengine 定义引擎特定的选项。
dfs
I/O 引擎支持通过 libdfs 对 DAOS 文件系统 (DFS) 进行异步读写操作。
nfs
I/O 引擎支持通过 libnfs 从用户空间对 NFS 文件系统进行异步读写操作。这对于实现比内核 NFS 更高的并发性和吞吐量非常有用。
执行
执行第 3 方工具。可用于在作业运行时执行监控。