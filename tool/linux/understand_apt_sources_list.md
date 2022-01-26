# 理解 apt sources.list

注意：本文在解释 apt sources.list 时，通常使用 Ubuntu 系统来举例，但这并不意味着只有这些例子。

## [sources.list format][1]

```sh
deb http://site.example.com/debian distribution component1 component2 component3
deb-src http://site.example.com/debian distribution component1 component2 component3
```

- Archive type
  - deb: the archive contains binary packages (deb), the pre-compiled packages that we normally use.
  - deb-src: the archive contains source packages, which are the original program sources plus the Debian control file (.dsc)
             and the diff.gz containing the changes needed for packaging the program.

- Repository URL: A URL to the repository that you want to download the packages from.

- Distribution: can be either the release code name/alias or the release class.
  - release code name
    - [Xenial Xerus][3] （好客的非洲地松鼠）
    - [Bionic Beaver][4] （仿生海狸）
    - [Focal Fossa][5] （备受瞩目的马岛长尾狸猫）
  - release class
    - stable
    - testing
    - unstable

- [Component][11]
  - main: Canonical-supported free and open-source software.
  - restrict: Proprietary drivers for devices.
  - universe: Community-maintained free and open-source software.
  - multiverse: Software restricted by copyright or legal issues.

## Ubuntu Mirrors URL

- 常用的 Ubuntu 镜像
  - [阿里云 Ubuntu 镜像][6]
  - [华为云 Ubuntu 镜像][7]
  - [清华 Ubuntu 镜像][8]
  - [中科大 Ubuntu 镜像][9]
  - [Ubuntu CN 镜像][10]

- Ubuntu 镜像与 sources.list 的对应关系 （以下来自笔者的实践观察）
  - 首先，点击 sources.list 的 Repository URL，我们便进入到 Ubuntu 镜像的网站首页。
  - 从首页可以发现，Ubuntu 镜像是以静态文件的形式提供服务，呈现为多级目录结构。
  - 一般首页下有个`dists`的目录，进入该目录，我们可以看到下一级目录是按照 distribution 来划分的，有 xenial/bionic/focal 等
  - 随便进入一个 distribution 目录（比如 xenial），我们可以看到下一级目录是按照 component 来划分的，有 main/multiverse/restrict/universe 等

## [Ubuntu Release code name][2]

- The official name of an Ubuntu release is "Ubuntu X.YY" with X representing the year (minus 2000) and YY representing the month of eventual release within in that year.
  - For example, Ubuntu's first release, made in 2004 October (10th month) was Ubuntu 4.10.

- Since the actual release date is not known until it's ready and humans tend to prefer names rather than numbers,
  a set of codenames are used by developers and testers during the buildup to a release.

- The development codename of a release takes the form "Adjective Animal".
  - For example: Warty Warthog (Ubuntu 4.10), Hoary Hedgehog (Ubuntu 5.04), Breezy Badger (Ubuntu 5.10), are the first three releases of Ubuntu.

- In general, people refer to the release using the adjective, like "warty" or "breezy".

- `lsb_release -cd` Print distribution description and code name.

- `sources.list` 里面填错 distribution (即 release code name) 信息会有什么后果？
  - 填错 distribution 意味着填错操作系统信息，比如你的操作系统是 Ubuntu 16.04，那么 distribution 应该填 `xenial`；
    但你误填了 `trusty`（对应 Ubuntu 14.04），那么后面使用`apt install`就可能会报各种错误，即使安装不报错，也可能使用时出问题。
  - 比如，我在 Ubuntu 16.04 下将 `/etc/apt/sources.list` 的 distribution 填为 `trusty`后，安装 ffmpeg 就报以下错误：

  ```sh
  along:/etc/apt$ sudo apt install ffmpeg
  Reading package lists... Done
  Building dependency tree       
  Reading state information... Done
  Package ffmpeg is not available, but is referred to by another package.
  This may mean that the package is missing, has been obsoleted, or
  is only available from another source

  E: Package 'ffmpeg' has no installation candidate
  ```

  [1]: https://wiki.debian.org/SourcesList
  [2]: https://wiki.ubuntu.com/DevelopmentCodeNames
  [3]: https://baike.baidu.com/item/%E5%8D%97%E9%9D%9E%E5%9C%B0%E6%9D%BE%E9%BC%A0/668689?fr=aladdin
  [4]: https://baike.baidu.com/item/%E6%B5%B7%E7%8B%B8/1212649?fr=aladdin
  [5]: https://baike.baidu.com/item/Fossa/18718600?fr=aladdin
  [6]: https://developer.aliyun.com/mirror/ubuntu
  [7]: https://mirrors.huaweicloud.com/home
  [8]: https://mirrors.tuna.tsinghua.edu.cn/help/ubuntu/
  [9]: https://mirrors.ustc.edu.cn/help/ubuntu.html
  [10]: http://cn.archive.ubuntu.com/ubuntu/
  [11]: https://help.ubuntu.com/community/Repositories/Ubuntu
