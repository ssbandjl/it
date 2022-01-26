# protobuf

Protocol Buffers(协议缓冲)是谷歌的数据交互格式.



## 参考

[官方仓库protocolbuffers/protobuf](https://github.com/protocolbuffers/protobuf)

[谷歌开发者-protocal-buffers](https://developers.google.com/protocol-buffers/)



## 概述

Protocal Buffers(简称protobuf), 是出自谷歌跨语言, 跨平台, 可扩展的机制, 用于将结构化数据序列化. 你也可以查看[官方文档](https://developers.google.com/protocol-buffers/).

本文包含protobuf安装说明, 为了安装protobuf, 你需要安装协议编译器, 用于编译.proto文件, 并且选择对应编程语言的protobuf运行时.



## Protocol编译器安装

协议编译器是用C++写的, 如果你使用的语言是C++, 请参考[C++ Installation Instructions](https://github.com/protocolbuffers/protobuf/blob/master/src/README.md)来安装protoc和C++运行时.

对于非C++用户, 最简单的方法是下载我们发布的预编译二进制包, 下载地址: https://github.com/protocolbuffers/protobuf/releases

对于每个发布版本, 你可以找到对应的预编译二进制ZIP包, 格式为:protoc-版本-$平台.zip. 它包含了protoc二进制文件以及一组随protobuf一起发布的标准.proto文件.

如果你需要更早的版本, 请从下面的maven仓库检出: https://repo1.maven.org/maven2/com/google/protobuf/protoc/

预编译的版本值包含发布版本, 如果你想使用最新的主干master版本, 或你想要修改protobuf源码, 或你使用C++, 建议从源码构建protoc二进制包.

如果你想从源码编译构建protoc二进制包, 请参考[C++ Installation Instructions](https://github.com/protocolbuffers/protobuf/blob/master/src/README.md).



## Protobuf运行时安装

Protobuf支持多种不同编程语言, 参考下面的表格, 选择使用的语言, 对应的源码目录有使用手册和protobuf运行时安装指南.

| Language                             | Source                                                       | Ubuntu                                                       | MacOS                                                        | Windows                                                      |
| ------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| C++ (include C++ runtime and protoc) | [src](https://github.com/protocolbuffers/protobuf/blob/master/src) | [![Build status](https://camo.githubusercontent.com/54d800f6a46be9b25455bb621947ceb9856c3f57a5e8916edc3a9a346e224ad8/68747470733a2f2f73746f726167652e676f6f676c65617069732e636f6d2f70726f746f6275662d6b6f6b6f726f2d726573756c74732f7374617475732d62616467652f6c696e75782d6370705f64697374636865636b2e706e67)](https://fusion.corp.google.com/projectanalysis/current/KOKORO/prod:protobuf%2Fgithub%2Fmaster%2Fubuntu%2Fcpp_distcheck%2Fcontinuous) [![Build status](https://camo.githubusercontent.com/f9672657e6ed992eca7273bda53cbfdfb54679acd21f7deea2e93ff10dc7a6e2/68747470733a2f2f73746f726167652e676f6f676c65617069732e636f6d2f70726f746f6275662d6b6f6b6f726f2d726573756c74732f7374617475732d62616467652f6c696e75782d62617a656c2e706e67)](https://fusion.corp.google.com/projectanalysis/current/KOKORO/prod:protobuf%2Fgithub%2Fmaster%2Fubuntu%2Fbazel%2Fcontinuous) [![Build status](https://camo.githubusercontent.com/699bea910662de9f8b567bb236c102e0b165991c8f1eae1f10ea024bfffe78af/68747470733a2f2f73746f726167652e676f6f676c65617069732e636f6d2f70726f746f6275662d6b6f6b6f726f2d726573756c74732f7374617475732d62616467652f6c696e75782d646973745f696e7374616c6c2e706e67)](https://fusion.corp.google.com/projectanalysis/current/KOKORO/prod:protobuf%2Fgithub%2Fmaster%2Fubuntu%2Fdist_install%2Fcontinuous) | [![Build status](https://camo.githubusercontent.com/38015cce91ccf24a92fa860b07cfdd9104c46a484012c13d9107a4189bda3f06/68747470733a2f2f73746f726167652e676f6f676c65617069732e636f6d2f70726f746f6275662d6b6f6b6f726f2d726573756c74732f7374617475732d62616467652f6d61636f732d6370702e706e67)](https://fusion.corp.google.com/projectanalysis/current/KOKORO/prod:protobuf%2Fgithub%2Fmaster%2Fmacos%2Fcpp%2Fcontinuous) [![Build status](https://camo.githubusercontent.com/2c6eaea543d91ebb258c0970bef336ca89defa88a1df365a13f19f8d65f9e75c/68747470733a2f2f73746f726167652e676f6f676c65617069732e636f6d2f70726f746f6275662d6b6f6b6f726f2d726573756c74732f7374617475732d62616467652f6d61636f732d6370705f64697374636865636b2e706e67)](https://fusion.corp.google.com/projectanalysis/current/KOKORO/prod:protobuf%2Fgithub%2Fmaster%2Fmacos%2Fcpp_distcheck%2Fcontinuous) | [![Build status](https://camo.githubusercontent.com/c8fe4e7c77eca20fa515e565474cd28416cb5a0addaed1be04759440518d4b05/68747470733a2f2f63692e6170707665796f722e636f6d2f6170692f70726f6a656374732f7374617475732f3733637465653675613477327275696e3f7376673d74727565)](https://ci.appveyor.com/project/protobuf/protobuf) |
| Java                                 | [java](https://github.com/protocolbuffers/protobuf/blob/master/java) | [![Build status](https://camo.githubusercontent.com/d4453548148740c74607467dbd9dd0f5e378aa15a3cfe582522267db613978d0/68747470733a2f2f73746f726167652e676f6f676c65617069732e636f6d2f70726f746f6275662d6b6f6b6f726f2d726573756c74732f7374617475732d62616467652f6c696e75782d6a6176615f636f6d7061746962696c6974792e706e67)](https://fusion.corp.google.com/projectanalysis/current/KOKORO/prod:protobuf%2Fgithub%2Fmaster%2Fubuntu%2Fjava_compatibility%2Fcontinuous) [![Build status](https://camo.githubusercontent.com/acbaca6808f87cd4ee3a5b9839719decde8be31ac277567e5f3f832d72aed5a7/68747470733a2f2f73746f726167652e676f6f676c65617069732e636f6d2f70726f746f6275662d6b6f6b6f726f2d726573756c74732f7374617475732d62616467652f6c696e75782d6a6176615f6a646b372e706e67)](https://fusion.corp.google.com/projectanalysis/current/KOKORO/prod:protobuf%2Fgithub%2Fmaster%2Fubuntu%2Fjava_jdk7%2Fcontinuous) [![Build status](https://camo.githubusercontent.com/4255e6f4cd334ea9d6f0be54a3aba530e8cd2a14d0859dfe546b6cabcdb06331/68747470733a2f2f73746f726167652e676f6f676c65617069732e636f6d2f70726f746f6275662d6b6f6b6f726f2d726573756c74732f7374617475732d62616467652f6c696e75782d6a6176615f6f7261636c65372e706e67)](https://fusion.corp.google.com/projectanalysis/current/KOKORO/prod:protobuf%2Fgithub%2Fmaster%2Fubuntu%2Fjava_oracle7%2Fcontinuous) [![Build status](https://camo.githubusercontent.com/ff523640ff721fd06d82d26e7887f22d6fa88ff7177ae1396ee4bb2cb9d25278/68747470733a2f2f73746f726167652e676f6f676c65617069732e636f6d2f70726f746f6275662d6b6f6b6f726f2d726573756c74732f7374617475732d62616467652f6c696e75782d6a6176615f6c696e6b6167655f6d6f6e69746f722e706e67)](https://fusion.corp.google.com/projectanalysis/current/KOKORO/prod:protobuf%2Fgithub%2Fmaster%2Fubuntu%2Fjava_linkage_monitor%2Fcontinuous) |                                                              |                                                              |
| Python                               | [python](https://github.com/protocolbuffers/protobuf/blob/master/python) | [![Build status](https://camo.githubusercontent.com/654b09a05b6af140b00e8086f00fa2230cc842ddae0ef4c7186aa8142c0f97b9/68747470733a2f2f73746f726167652e676f6f676c65617069732e636f6d2f70726f746f6275662d6b6f6b6f726f2d726573756c74732f7374617475732d62616467652f6c696e75782d707974686f6e32372e706e67)](https://fusion.corp.google.com/projectanalysis/current/KOKORO/prod:protobuf%2Fgithub%2Fmaster%2Fubuntu%2Fpython27%2Fcontinuous) [![Build status](https://camo.githubusercontent.com/87a1900d08f0d3868e5b4e56b8278d530c42de689cfa468bfdce6e1cf3571f17/68747470733a2f2f73746f726167652e676f6f676c65617069732e636f6d2f70726f746f6275662d6b6f6b6f726f2d726573756c74732f7374617475732d62616467652f6c696e75782d707974686f6e33352e706e67)](https://fusion.corp.google.com/projectanalysis/current/KOKORO/prod:protobuf%2Fgithub%2Fmaster%2Fubuntu%2Fpython35%2Fcontinuous) [![Build status](https://camo.githubusercontent.com/07465e0b5642a6ca66460b24dd9806e7dd1625caf47d3c34ef735863de35d9f7/68747470733a2f2f73746f726167652e676f6f676c65617069732e636f6d2f70726f746f6275662d6b6f6b6f726f2d726573756c74732f7374617475732d62616467652f6c696e75782d707974686f6e33362e706e67)](https://fusion.corp.google.com/projectanalysis/current/KOKORO/prod:protobuf%2Fgithub%2Fmaster%2Fubuntu%2Fpython36%2Fcontinuous) [![Build status](https://camo.githubusercontent.com/9400606d17c0ff42e845dc93867ecca5328fa9c363c3bbe0e709064f951bbcf6/68747470733a2f2f73746f726167652e676f6f676c65617069732e636f6d2f70726f746f6275662d6b6f6b6f726f2d726573756c74732f7374617475732d62616467652f6c696e75782d707974686f6e33372e706e67)](https://fusion.corp.google.com/projectanalysis/current/KOKORO/prod:protobuf%2Fgithub%2Fmaster%2Fubuntu%2Fpython37%2Fcontinuous) [![Build status](https://camo.githubusercontent.com/97bb3a50d72cb3d07f2d60d985718df30d74ac8b41ebd6268a5c5ff0e7bc676d/68747470733a2f2f73746f726167652e676f6f676c65617069732e636f6d2f70726f746f6275662d6b6f6b6f726f2d726573756c74732f7374617475732d62616467652f6c696e75782d707974686f6e5f636f6d7061746962696c6974792e706e67)](https://fusion.corp.google.com/projectanalysis/current/KOKORO/prod:protobuf%2Fgithub%2Fmaster%2Fubuntu%2Fpython_compatibility%2Fcontinuous) [![Build status](https://camo.githubusercontent.com/aa8213efb9c92bff3df0ef996d1c99333a4a0c8abd0f8433924c06ff1f0e2fae/68747470733a2f2f73746f726167652e676f6f676c65617069732e636f6d2f70726f746f6275662d6b6f6b6f726f2d726573756c74732f7374617475732d62616467652f6c696e75782d707974686f6e32375f6370702e706e67)](https://fusion.corp.google.com/projectanalysis/current/KOKORO/prod:protobuf%2Fgithub%2Fmaster%2Fubuntu%2Fpython27_cpp%2Fcontinuous) [![Build status](https://camo.githubusercontent.com/82638240ccd5bd7693826761aaaf4eb41d3d6fd77d67b53c6f2fd1431beea138/68747470733a2f2f73746f726167652e676f6f676c65617069732e636f6d2f70726f746f6275662d6b6f6b6f726f2d726573756c74732f7374617475732d62616467652f6c696e75782d707974686f6e33355f6370702e706e67)](https://fusion.corp.google.com/projectanalysis/current/KOKORO/prod:protobuf%2Fgithub%2Fmaster%2Fubuntu%2Fpython35_cpp%2Fcontinuous) [![Build status](https://camo.githubusercontent.com/352f1366bc2929eed568bd6d00350dbad8c1bffdf050b5226257f3e8edb0c086/68747470733a2f2f73746f726167652e676f6f676c65617069732e636f6d2f70726f746f6275662d6b6f6b6f726f2d726573756c74732f7374617475732d62616467652f6c696e75782d707974686f6e33365f6370702e706e67)](https://fusion.corp.google.com/projectanalysis/current/KOKORO/prod:protobuf%2Fgithub%2Fmaster%2Fubuntu%2Fpython36_cpp%2Fcontinuous) [![Build status](https://camo.githubusercontent.com/ff93c2d939de0c7ba8b8b3766e1713eeb21b5feac991a3540bb0def7e3fbbae2/68747470733a2f2f73746f726167652e676f6f676c65617069732e636f6d2f70726f746f6275662d6b6f6b6f726f2d726573756c74732f7374617475732d62616467652f6c696e75782d707974686f6e33375f6370702e706e67)](https://fusion.corp.google.com/projectanalysis/current/KOKORO/prod:protobuf%2Fgithub%2Fmaster%2Fubuntu%2Fpython37_cpp%2Fcontinuous) [![Build status](https://camo.githubusercontent.com/9be5a79f32a084e8ef5e0e52b12d796e4e93e050d6523e2caa18f3dda6aee908/68747470733a2f2f73746f726167652e676f6f676c65617069732e636f6d2f70726f746f6275662d6b6f6b6f726f2d726573756c74732f7374617475732d62616467652f6c696e75782d707974686f6e2d72656c656173652e706e67)](https://fusion.corp.google.com/projectanalysis/current/KOKORO/prod:protobuf%2Fgithub%2Fmaster%2Fubuntu%2Fpython_release%2Fcontinuous) | [![Build status](https://camo.githubusercontent.com/1eae746c5c1ac08bc44d275b4416148b721f33a6d20df99046ceeb88aaaea84b/68747470733a2f2f73746f726167652e676f6f676c65617069732e636f6d2f70726f746f6275662d6b6f6b6f726f2d726573756c74732f7374617475732d62616467652f6d61636f732d707974686f6e2e706e67)](https://fusion.corp.google.com/projectanalysis/current/KOKORO/prod:protobuf%2Fgithub%2Fmaster%2Fmacos%2Fpython%2Fcontinuous) [![Build status](https://camo.githubusercontent.com/a02429de4b23462a06e3044d9c5fe10475ee53a4b189a022c29a011111febd6d/68747470733a2f2f73746f726167652e676f6f676c65617069732e636f6d2f70726f746f6275662d6b6f6b6f726f2d726573756c74732f7374617475732d62616467652f6d61636f732d707974686f6e5f6370702e706e67)](https://fusion.corp.google.com/projectanalysis/current/KOKORO/prod:protobuf%2Fgithub%2Fmaster%2Fmacos%2Fpython_cpp%2Fcontinuous) [![Build status](https://camo.githubusercontent.com/086b174ddae4959e7af7f168bf071448682d4e2314d88567614ce680969e1861/68747470733a2f2f73746f726167652e676f6f676c65617069732e636f6d2f70726f746f6275662d6b6f6b6f726f2d726573756c74732f7374617475732d62616467652f6d61636f732d707974686f6e2d72656c656173652e706e67)](https://fusion.corp.google.com/projectanalysis/current/KOKORO/prod:protobuf%2Fgithub%2Fmaster%2Fmacos%2Fpython_release%2Fcontinuous) | [![Build status](https://camo.githubusercontent.com/fbf42409c9a3c424106d67b24889c40106e73203186df7b945a929fbd8180c13/68747470733a2f2f73746f726167652e676f6f676c65617069732e636f6d2f70726f746f6275662d6b6f6b6f726f2d726573756c74732f7374617475732d62616467652f77696e646f77732d707974686f6e2d72656c656173652e706e67)](https://fusion.corp.google.com/projectanalysis/current/KOKORO/prod:protobuf%2Fgithub%2Fmaster%2Fwindows%2Fpython_release%2Fcontinuous) |
| Objective-C                          | [objectivec](https://github.com/protocolbuffers/protobuf/blob/master/objectivec) |                                                              | [![Build status](https://camo.githubusercontent.com/cc7d0e38a02d88d1d46fb491ea44fcfa4667c11ac692efbd668a11061745e0c7/68747470733a2f2f73746f726167652e676f6f676c65617069732e636f6d2f70726f746f6275662d6b6f6b6f726f2d726573756c74732f7374617475732d62616467652f6d61636f732d6f626a656374697665635f636f636f61706f64735f696e746567726174696f6e2e706e67)](https://fusion.corp.google.com/projectanalysis/current/KOKORO/prod:protobuf%2Fgithub%2Fmaster%2Fmacos%2Fobjectivec_cocoapods_integration%2Fcontinuous) [![Build status](https://camo.githubusercontent.com/82a620534ca202f51c50a4878c4e2104c3976ddf6f8fb5acf7f33a76e7381a3a/68747470733a2f2f73746f726167652e676f6f676c65617069732e636f6d2f70726f746f6275662d6b6f6b6f726f2d726573756c74732f7374617475732d62616467652f6d61636f732d6f626a656374697665635f696f735f64656275672e706e67)](https://fusion.corp.google.com/projectanalysis/current/KOKORO/prod:protobuf%2Fgithub%2Fmaster%2Fmacos%2Fobjectivec_ios_debug%2Fcontinuous) [![Build status](https://camo.githubusercontent.com/94b692bd4633fe3496e8023fc7685197bfabd038ef3dfc7dbd11866351f579b8/68747470733a2f2f73746f726167652e676f6f676c65617069732e636f6d2f70726f746f6275662d6b6f6b6f726f2d726573756c74732f7374617475732d62616467652f6d61636f732d6f626a656374697665635f696f735f72656c656173652e706e67)](https://fusion.corp.google.com/projectanalysis/current/KOKORO/prod:protobuf%2Fgithub%2Fmaster%2Fmacos%2Fobjectivec_ios_release%2Fcontinuous) [![Build status](https://camo.githubusercontent.com/6a8993aa614c9871066417f5c87ff7da2b9dbd6a6cdf099765d555356840013e/68747470733a2f2f73746f726167652e676f6f676c65617069732e636f6d2f70726f746f6275662d6b6f6b6f726f2d726573756c74732f7374617475732d62616467652f6d61636f732d6f626a656374697665635f6f73782e706e67)](https://fusion.corp.google.com/projectanalysis/current/KOKORO/prod:protobuf%2Fgithub%2Fmaster%2Fmacos%2Fobjectivec_osx%2Fcontinuous) |                                                              |
| C#                                   | [csharp](https://github.com/protocolbuffers/protobuf/blob/master/csharp) | [![Build status](https://camo.githubusercontent.com/f6f95a2f33efbd60f565a9785859ee141aaf7613d60c87bd929eea499c045f8a/68747470733a2f2f73746f726167652e676f6f676c65617069732e636f6d2f70726f746f6275662d6b6f6b6f726f2d726573756c74732f7374617475732d62616467652f6c696e75782d6373686172702e706e67)](https://fusion.corp.google.com/projectanalysis/current/KOKORO/prod:protobuf%2Fgithub%2Fmaster%2Fubuntu%2Fcsharp%2Fcontinuous) |                                                              | [![Build status](https://camo.githubusercontent.com/c8fe4e7c77eca20fa515e565474cd28416cb5a0addaed1be04759440518d4b05/68747470733a2f2f63692e6170707665796f722e636f6d2f6170692f70726f6a656374732f7374617475732f3733637465653675613477327275696e3f7376673d74727565)](https://ci.appveyor.com/project/protobuf/protobuf) [![Build status](https://camo.githubusercontent.com/71622a2686601fe1f0931c5c44512d7a51e68043035a1e3502873499a284b8f8/68747470733a2f2f73746f726167652e676f6f676c65617069732e636f6d2f70726f746f6275662d6b6f6b6f726f2d726573756c74732f7374617475732d62616467652f77696e646f77732d6373686172702d72656c656173652e706e67)](https://fusion.corp.google.com/projectanalysis/current/KOKORO/prod:protobuf%2Fgithub%2Fmaster%2Fwindows%2Fcsharp_release%2Fcontinuous) |
| JavaScript                           | [js](https://github.com/protocolbuffers/protobuf/blob/master/js) | [![Build status](https://camo.githubusercontent.com/55ab487ba3137d07a52bd85baf1f670af2e35072b1f991ecee7554cd5ecbafb0/68747470733a2f2f73746f726167652e676f6f676c65617069732e636f6d2f70726f746f6275662d6b6f6b6f726f2d726573756c74732f7374617475732d62616467652f6c696e75782d6a6176617363726970742e706e67)](https://fusion.corp.google.com/projectanalysis/current/KOKORO/prod:protobuf%2Fgithub%2Fmaster%2Fubuntu%2Fjavascript%2Fcontinuous) | [![Build status](https://camo.githubusercontent.com/f3aa1e101b1294795b6674bd18eb4474f11c6707fdafcdf588e7d5484bd3fb01/68747470733a2f2f73746f726167652e676f6f676c65617069732e636f6d2f70726f746f6275662d6b6f6b6f726f2d726573756c74732f7374617475732d62616467652f6d61636f732d6a6176617363726970742e706e67)](https://fusion.corp.google.com/projectanalysis/current/KOKORO/prod:protobuf%2Fgithub%2Fmaster%2Fmacos%2Fjavascript%2Fcontinuous) |                                                              |
| Ruby                                 | [ruby](https://github.com/protocolbuffers/protobuf/blob/master/ruby) | [![Build status](https://camo.githubusercontent.com/da5b45bb7e4d831fc8cfcb0afc9d4c2063d1c55f2847eab5121dc6aebbe00c1a/68747470733a2f2f73746f726167652e676f6f676c65617069732e636f6d2f70726f746f6275662d6b6f6b6f726f2d726573756c74732f7374617475732d62616467652f6c696e75782d7275627932332e706e67)](https://fusion.corp.google.com/projectanalysis/current/KOKORO/prod:protobuf%2Fgithub%2Fmaster%2Fubuntu%2Fruby23%2Fcontinuous) [![Build status](https://camo.githubusercontent.com/9287681cf36ef75773ed9fda4b3737cd599bd462d8562992abf1ba72b833ecb4/68747470733a2f2f73746f726167652e676f6f676c65617069732e636f6d2f70726f746f6275662d6b6f6b6f726f2d726573756c74732f7374617475732d62616467652f6c696e75782d7275627932342e706e67)](https://fusion.corp.google.com/projectanalysis/current/KOKORO/prod:protobuf%2Fgithub%2Fmaster%2Fubuntu%2Fruby24%2Fcontinuous) [![Build status](https://camo.githubusercontent.com/8a5ccd6670d7e21e4dff1d6c2a28f0cec8bf4f52b2d9165257b2d02160d586ff/68747470733a2f2f73746f726167652e676f6f676c65617069732e636f6d2f70726f746f6275662d6b6f6b6f726f2d726573756c74732f7374617475732d62616467652f6c696e75782d7275627932352e706e67)](https://fusion.corp.google.com/projectanalysis/current/KOKORO/prod:protobuf%2Fgithub%2Fmaster%2Fubuntu%2Fruby25%2Fcontinuous) [![Build status](https://camo.githubusercontent.com/f92ead89f6b46c231ec4ab6c508bdd438f94af2c410552fe99abe8d44cd554e2/68747470733a2f2f73746f726167652e676f6f676c65617069732e636f6d2f70726f746f6275662d6b6f6b6f726f2d726573756c74732f7374617475732d62616467652f6c696e75782d7275627932362e706e67)](https://fusion.corp.google.com/projectanalysis/current/KOKORO/prod:protobuf%2Fgithub%2Fmaster%2Fubuntu%2Fruby26%2Fcontinuous) [![Build status](https://camo.githubusercontent.com/86868c763b35ec4fb359d220aa5c633724b97699441dfbb3855d8ea46ee614ba/68747470733a2f2f73746f726167652e676f6f676c65617069732e636f6d2f70726f746f6275662d6b6f6b6f726f2d726573756c74732f7374617475732d62616467652f6c696e75782d727562792d72656c656173652e706e67)](https://fusion.corp.google.com/projectanalysis/current/KOKORO/prod:protobuf%2Fgithub%2Fmaster%2Fubuntu%2Fruby_release%2Fcontinuous) | [![Build status](https://camo.githubusercontent.com/ac9a302b9f2e7db4a11e2e95f7956d8baaf2acfa47be4d3d8a84ef1675a730f2/68747470733a2f2f73746f726167652e676f6f676c65617069732e636f6d2f70726f746f6275662d6b6f6b6f726f2d726573756c74732f7374617475732d62616467652f6d61636f732d7275627932332e706e67)](https://fusion.corp.google.com/projectanalysis/current/KOKORO/prod:protobuf%2Fgithub%2Fmaster%2Fmacos%2Fruby23%2Fcontinuous) [![Build status](https://camo.githubusercontent.com/064eef15cb9614d9341748facfd18a667d2dee0a245051a7ba0939113ddf7f96/68747470733a2f2f73746f726167652e676f6f676c65617069732e636f6d2f70726f746f6275662d6b6f6b6f726f2d726573756c74732f7374617475732d62616467652f6d61636f732d7275627932342e706e67)](https://fusion.corp.google.com/projectanalysis/current/KOKORO/prod:protobuf%2Fgithub%2Fmaster%2Fmacos%2Fruby24%2Fcontinuous) [![Build status](https://camo.githubusercontent.com/2963e60b8b79d71d15d4ebfa0bed1ef35963239672b9fa0a037946671f8f1a7e/68747470733a2f2f73746f726167652e676f6f676c65617069732e636f6d2f70726f746f6275662d6b6f6b6f726f2d726573756c74732f7374617475732d62616467652f6d61636f732d7275627932352e706e67)](https://fusion.corp.google.com/projectanalysis/current/KOKORO/prod:protobuf%2Fgithub%2Fmaster%2Fmacos%2Fruby25%2Fcontinuous) [![Build status](https://camo.githubusercontent.com/320071c3e1855863caf966e7eae9603a6d9bc677742efd5dff755876c8133f01/68747470733a2f2f73746f726167652e676f6f676c65617069732e636f6d2f70726f746f6275662d6b6f6b6f726f2d726573756c74732f7374617475732d62616467652f6d61636f732d7275627932362e706e67)](https://fusion.corp.google.com/projectanalysis/current/KOKORO/prod:protobuf%2Fgithub%2Fmaster%2Fmacos%2Fruby26%2Fcontinuous) [![Build status](https://camo.githubusercontent.com/8a813e8b63fe339f466f7317ff0582c294d0f4c6dd034a936adfc10d04fb4745/68747470733a2f2f73746f726167652e676f6f676c65617069732e636f6d2f70726f746f6275662d6b6f6b6f726f2d726573756c74732f7374617475732d62616467652f6d61636f732d727562792d72656c656173652e706e67)](https://fusion.corp.google.com/projectanalysis/current/KOKORO/prod:protobuf%2Fgithub%2Fmaster%2Fmacos%2Fruby_release%2Fcontinuous) |                                                              |
| Go                                   | [protocolbuffers/protobuf-go](https://github.com/protocolbuffers/protobuf-go) |                                                              |                                                              |                                                              |
| PHP                                  | [php](https://github.com/protocolbuffers/protobuf/blob/master/php) | [![Build status](https://camo.githubusercontent.com/7292e33a90124f42a3a80a0d3f9d379001bb9e01553390a9bf89f90e9134c422/68747470733a2f2f73746f726167652e676f6f676c65617069732e636f6d2f70726f746f6275662d6b6f6b6f726f2d726573756c74732f7374617475732d62616467652f6c696e75782d7068705f616c6c2e706e67)](https://fusion.corp.google.com/projectanalysis/current/KOKORO/prod:protobuf%2Fgithub%2Fmaster%2Fubuntu%2Fphp_all%2Fcontinuous) [![Build status](https://camo.githubusercontent.com/4d487ecd2f2d7d5e5a844ca2314939d940de1c9247c87bc26191a1d2dbf47ea6/68747470733a2f2f73746f726167652e676f6f676c65617069732e636f6d2f70726f746f6275662d6b6f6b6f726f2d726573756c74732f7374617475732d62616467652f6c696e75782d33322d6269742e706e67)](https://fusion.corp.google.com/projectanalysis/current/KOKORO/prod:protobuf%2Fgithub%2Fmaster%2Fubuntu%2F32-bit%2Fcontinuous) | [![Build status](https://camo.githubusercontent.com/a7863048a1b40aca9fd17d138f22c56dc15d40d22a77090b6934a11d7543e966/68747470733a2f2f73746f726167652e676f6f676c65617069732e636f6d2f70726f746f6275662d6b6f6b6f726f2d726573756c74732f7374617475732d62616467652f6d61636f732d706870352e365f6d61632e706e67)](https://fusion.corp.google.com/projectanalysis/current/KOKORO/prod:protobuf%2Fgithub%2Fmaster%2Fmacos%2Fphp5.6_mac%2Fcontinuous) [![Build status](https://camo.githubusercontent.com/c352f4d8690656379f8c9680cd466f7f7bc9d12b6d91257c4c4cd8e872bca0a0/68747470733a2f2f73746f726167652e676f6f676c65617069732e636f6d2f70726f746f6275662d6b6f6b6f726f2d726573756c74732f7374617475732d62616467652f6d61636f732d706870372e305f6d61632e706e67)](https://fusion.corp.google.com/projectanalysis/current/KOKORO/prod:protobuf%2Fgithub%2Fmaster%2Fmacos%2Fphp7.0_mac%2Fcontinuous) |                                                              |
| Dart                                 | [dart-lang/protobuf](https://github.com/dart-lang/protobuf)  | [![Build Status](https://camo.githubusercontent.com/b9149e9abf91438ab21dbcab2de5bc6d7d3535973a17622a218325dab90ecdf8/68747470733a2f2f7472617669732d63692e6f72672f646172742d6c616e672f70726f746f6275662e7376673f6272616e63683d6d6173746572)](https://travis-ci.org/dart-lang/protobuf) |                                                              |                                                              |



## 快速开始

学习怎样使用protobuf最好的方法, 就是跟着我们的开发者指南动手实操:

https://developers.google.com/protocol-buffers/docs/tutorials

[Go教程](./tutorials/go.md)

如果你想从示例代码中学习, 你可以参考本项目的 [examples](https://github.com/protocolbuffers/protobuf/blob/master/examples) 目录.



## 文档

关于Protocol Buffers完整的文档, 请参考Goolge开发者protocal-buffers网站:https://developers.google.com/protocol-buffers/
