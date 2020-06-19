local e=require"nixio.fs"
function sync_value_to_file(e,t)
e=e:gsub("\r\n?","\n")
local a=nixio.fs.readfile(t)
if e~=a then
nixio.fs.writefile(t,e)
end
end
local e=""
local a=(luci.sys.call("pidof haproxy > /dev/null")==0)
local t=luci.sys.exec("uci get network.lan.ipaddr")
if a then
e="<b><font color=\"green\">"..translate("Running").."</font></b>"
else
e="<b><font color=\"red\">"..translate("Not running").."</font></b>"
end
m=Map("haproxy",translate("HAProxy"),translate("HAProxy能够检测Shadowsocks服务器的连通情况，从而实现负载均衡和高可用的功能，支持主备用服务器宕机自动切换，并且可以设置多个主服务器用于分流，规定每个分流节点的流量比例等。前提条件是你的所有Shadowsocks服务器的【加密方式】和【密码】一致。<br><br>使用方法：配置好你的Shadowsocks服务器ip地址和端口，然后开启Shadowsocks服务，将服务器地址填写为【127.0.0.1】，端口【1181】，其他参数和之前一样即可，你可以通过访问【路由器的IP:1188】，来观察各节点健康状况，红色为宕机，绿色正常").."<br><br>后台监控页面：<a href='http://"..t..":1188'>"..t..":1188</a>".."<br><br>状态 - "..e)
s=m:section(TypedSection,"arguments","")
s.addremove=false
s.anonymous=true
view_enable=s:option(Flag,"enabled",translate("Enable"))
s=m:section(TypedSection,"main_server","<b>"..translate("Main Server List").."<b>")
s.anonymous=true
s.addremove=true
o=s:option(Value,"server_name",translate("Display Name"),translate("Only English Characters,No spaces"))
o.rmempty=false
o=s:option(Flag,"validate",translate("validate"))
o=s:option(Value,"server_ip",translate("Proxy Server IP"))
o=s:option(Value,"server_port",translate("Proxy Server Port"))
o.datatype="uinteger"
o=s:option(Value,"server_weight",translate("Weight"))
o.datatype="uinteger"
s=m:section(TypedSection,"backup_server","<b>"..translate("Backup Server List").."<b>")
s.anonymous=true
s.addremove=true
o=s:option(Value,"server_name",translate("Display Name"),translate("Only English Characters,No spaces"))
o.rmempty=false
o=s:option(Flag,"validate",translate("validate"))
o=s:option(Value,"server_ip",translate("Proxy Server IP"))
o=s:option(Value,"server_port",translate("Proxy Server Port"))
o.datatype="uinteger"
local e=luci.http.formvalue("cbi.apply")
if e then
os.execute("/etc/haproxy_init.sh restart >/dev/null 2>&1 &")
end
return m
