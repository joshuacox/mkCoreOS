# mkCoreOS
Make a CoreOS Image following the guide [here](https://coreos.com/os/docs/latest/booting-with-libvirt.html

Tell it where to get it's cloud-config file (should be an URL), or use the example:

```
cp USER_DATA_URL.example USER_DATA_URL
```

then set up the network, or use the example

```
cp NETWORK.example NETWORK
```

then set the mac address, or use the example

```
cp MAC.example MAC
```

now finally run it

```
make run
```
