# mkCoreOS
Make a CoreOS Image following the guide [here](https://coreos.com/os/docs/latest/booting-with-libvirt.html

Tell it where to get it's cloud-config file (should be an URL), or take the example:

```
cp USER_DATA_URL.example USER_DATA_URL
```

```
make run
```
