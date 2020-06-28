# 网卡驱动e1000e源码剖析

## 网卡驱动与内核的接口

```
static const struct net_device_ops e1000e_netdev_ops = {
	.ndo_open		= e1000e_open,
	.ndo_stop		= e1000e_close,
	.ndo_start_xmit		= e1000_xmit_frame,
#ifdef HAVE_NDO_GET_STATS64
	.ndo_get_stats64	= e1000e_get_stats64,
#else /* HAVE_NDO_GET_STATS64 */
	.ndo_get_stats		= e1000_get_stats,
#endif /* HAVE_NDO_GET_STATS64 */
	.ndo_set_rx_mode	= e1000e_set_rx_mode,
	.ndo_set_mac_address	= e1000_set_mac,
    // ......
}
```

## 网卡的启动

```
e1000e_open
```
