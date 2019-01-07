# cl-maprcli

## Overview
This project implements the MapR Control System (MCS) REST API for Common Lisp.

`maprcli` is a tool for the command-line interface (CLI). The MapR MCS provides a REST API for language agnostic programming. Please refer to the [MapR Reference Guide](http://maprdocs.mapr.com/home/ReferenceGuide/maprcli-REST-API-Syntax.html) for details.

## Installing
This project is not in Quicklisp. Start by cloning the repository into a directory known to ASDF or Quicklisp. E.g.

```
git clone https://github.com/incjung/cl-maprcli.git
```
then in repl session `(ql:quickload "cl-maprcli")` or `(asdf:load-system "cl-maprcli")`

## Configuring
MapR/CS (MapR Control System) needs to know the host that MCS is
running on and the login credentials. Those can be set with `set-host` and `set-authentication`. For example:

```
(set-host "https://192.168.2.51:8443/rest")
(set-authentication '("mapr" "mapr")')
```

To get information from another remote server without setting the host:
```
(volume-info :host "https://192.168.2.51:8443/rest" :path "/")
```
where :host is mcs host.

## Using the MapR Control System
MapR's `maprcli` shell syntax is:
```
maprcli <command> [<subcommand>...] ?<parameters>
```

For example, if you want to get information about a particular MapR
volume, `maprcli` command can be used like this from a UNIX shell:

```
maprcli volume info
    [ -cluster <cluster name> ]
    [ -output terse | verbose ]
    [ -path <mount directory> ]
    [ -name <volume name> ]
    [ -columns <column name> ]
```

You must specify either name or path, but not both. The CL interface
mirrors this with the `maprcli` function, e.g. `maprcli volume info -path /`

With `cl-maprcli`, you can get same information with `(maprcli
"/volume/info" :path "/")` or `(volume-info :path "/")`. The first
form more closely duplicates the existing command line interface and
might be more familar to existing MapR administrators. The second form
is idiomatic lisp.

Here is another example of two equivalent forms:
```
(maprcli "volume/create" :path "/test07" :name "helloworld")
```
and
```
(volume-create :path "/test07" :name "helloworld") ; create volume
```

The syntax for commands is:
```
(maprcli "/<command>/<subcommand>" :param-name <param-value>* [:host *host* :output :pretty])
(<command>-?<subcommand> :param-name <param-value>* [:host *host* :output :pretty])
```
:host is mcs host 
:output can be `:clos`, `:pretty`, `:json`, `:list`.
 - :pretty is used if result has `data` field (default)
 - :json is returning json format
 - :clos return object that support some functions
    ```
     (STATUS class-instance) : status of communication with MCS
     (DATA class-instance) : information of message body
     (PRETTY class-instance) : output 
    ```

## Getting Help
You can use the 'help' command to learn more about a command. For
example, when you want to see the alarms for a cluster (i.e. the
"alarm list"), then you can use
```
(help :/alarm/list)
```
