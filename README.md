# mkCoreOS
Make a CoreOS Image following the guide [here](https://coreos.com/os/docs/latest/booting-with-libvirt.html

Tell it where to get it's cloud-config file (should be an URL), or use the example:

```
make example
```

Which does this, which you can do manually:

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


If you like you can have it pull user_data so you can edit it

```
make coreos1
```

edit the user_data now

```
vim coreos1/openstack/latest/user_data
```

now finally run it

```
make run
```
